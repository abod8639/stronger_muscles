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

  Future<Map<String, String>> _getHeaders() async {
    final token = StorageService.getToken();
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

  Future<http.Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final uri = _buildUri(path, queryParameters: queryParameters);
      final response = await _client
          .get(uri, headers: await _getHeaders())
          .timeout(_timeout);
      
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<http.Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final uri = _buildUri(path, queryParameters: queryParameters);
      final response = await _client
          .post(uri, headers: await _getHeaders(), body: jsonEncode(data))
          .timeout(_timeout);
      
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- Error Handling ---

  http.Response _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      throw _handleHttpError(response);
    }
  }

  Failure _handleHttpError(http.Response response) {
    String errorDescription = "خطأ في الخادم: ${response.statusCode}";
    FailureType failureType = FailureType.server;

    if (response.statusCode == 401 || response.statusCode == 403) {
      failureType = FailureType.auth;
      errorDescription = "غير مصرح لك بالوصول. يرجى تسجيل الدخول مجدداً";
      StorageService.deleteToken();
      // Optional: Get.offAllNamed('/login'); 
    } else {
      try {
        final body = jsonDecode(response.body);
        if (body is Map && body['message'] != null) {
          errorDescription = body['message'];
        }
      } catch (_) {
        
      }
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
}