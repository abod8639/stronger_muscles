import 'dart:convert';
import 'dart:async'; // Required for TimeoutException
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../presentation/bindings/language_controller.dart';
import '../../config/api_config.dart';
import 'storage_service.dart';
import '../errors/failures.dart';

class ApiService {
  // Initialize the client
  final http.Client _client = http.Client();
  final Duration _timeout = const Duration(seconds: 15);

  Future<Map<String, String>> _getHeaders({bool includeAuth = true}) async {
    final token = includeAuth ? StorageService.getToken() : null;
    final languageCode = Get.find<LanguageController>().currentLocale.value.languageCode;
    
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Accept-Language': languageCode,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Uri _buildUri(String path, {Map<String, dynamic>? queryParameters}) {
    if (path.startsWith('http')) {
      return Uri.parse(path).replace(queryParameters: queryParameters);
    }
    
    final baseUrl = Uri.parse(ApiConfig.baseUrl);
    
    // Using pathSegments is safer than manual string concatenation
    List<String> combinedSegments = List.from(baseUrl.pathSegments);
    combinedSegments.addAll(path.split('/').where((s) => s.isNotEmpty));

    return baseUrl.replace(
      pathSegments: combinedSegments,
      queryParameters: queryParameters?.map((k, v) => MapEntry(k, v.toString())),
    );
  }

  // --- HTTP Methods ---

  Future<http.Response> get(String path, {Map<String, dynamic>? queryParameters, bool includeAuth = true}) async {
    try {
      final uri = _buildUri(path, queryParameters: queryParameters);
      print('🚀 Request: GET $uri');
      final response = await _client
          .get(uri, headers: await _getHeaders(includeAuth: includeAuth))
          .timeout(_timeout);
      
      return _handleResponse(response, path);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<http.Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters, bool includeAuth = true}) async {
    try {
      final uri = _buildUri(path, queryParameters: queryParameters);
      print('🚀 Request: POST $uri | Body: $data');
      final response = await _client
          .post(uri, headers: await _getHeaders(includeAuth: includeAuth), body: jsonEncode(data))
          .timeout(_timeout);
      
      return _handleResponse(response, path);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- Error Handling ---

  http.Response _handleResponse(http.Response response, String path) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      throw _handleHttpError(response, path);
    }
  }

  Failure _handleHttpError(http.Response response, String path) {
  String errorDescription = "خطأ غير متوقع: ${response.statusCode}";
  FailureType failureType = FailureType.server;

  // فحص أخطاء الطلب واستخراج الرسالة إن وجدت
  String? serverMessage;
  try {
    final dynamic body = jsonDecode(utf8.decode(response.bodyBytes));
    if (body is Map) {
      serverMessage = body['message'] ?? body['error'];
    }
  } catch (_) {}

  // فحص أخطاء الصلاحيات
  if (response.statusCode == 401 || response.statusCode == 403) {
    failureType = FailureType.auth;
    
    if (path.contains('login')) {
      errorDescription = serverMessage ?? "البريد الإلكتروني أو كلمة المرور غير صحيحة";
    } else {
      errorDescription = serverMessage ?? "انتهت الجلسة، يرجى تسجيل الدخول مجدداً";
      StorageService.deleteToken();
    }
    
    print('⚠️ Auth Error (${response.statusCode}): $errorDescription | Path: $path | Body: ${response.body}');
  } 
  else {
    errorDescription = serverMessage ?? errorDescription;
    print('❌ API Error (${response.statusCode}): $errorDescription | Body: ${response.body}');
  }

  return Failure(message: errorDescription, type: failureType);
}

  dynamic _handleError(dynamic error) {
    if (error is Failure) return error;

    String errorDescription = "حدث خطأ غير متوقع";
    FailureType failureType = FailureType.unknown;

    if (error is http.ClientException || error.toString().contains('SocketException')) {
       errorDescription = "تعذر الوصول إلى الخادم. تأكد من الاتصال بالشبكة";
       failureType = FailureType.network;
    } else if (error is TimeoutException) {
       errorDescription = "انتهت مهلة الاتصال بالخادم";
       failureType = FailureType.network;
    }

    return Failure(message: errorDescription, type: failureType);
  }

  Future<http.Response> delete(String path) async {
  try {
    final uri = _buildUri(path);
    final response = await _client.delete(uri, headers: await _getHeaders());
    return _handleResponse(response, path);
  } catch (e) {
    throw _handleError(e);
  }
}