import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../presentation/bindings/language_controller.dart';
import '../../config/api_config.dart';
import 'storage_service.dart';
import '../errors/failures.dart';

class ApiService {
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
    // Handle full URLs if path already contains http
    if (path.startsWith('http')) {
      return Uri.parse(path).replace(queryParameters: queryParameters);
    }
    
    // Construct URI from base URL and path
    // ApiConfig.baseUrl might include 'http://' prefix, so we parse it
    final baseUrl = Uri.parse(ApiConfig.baseUrl);
    
    // Combine paths correctly
    String finalPath = baseUrl.path;
    if (!finalPath.endsWith('/') && !path.startsWith('/')) {
      finalPath += '/$path';
    } else if (finalPath.endsWith('/') && path.startsWith('/')) {
      finalPath += path.substring(1);
    } else {
      finalPath += path;
    }

    return baseUrl.replace(
      path: finalPath,
      queryParameters: queryParameters?.map((key, value) => MapEntry(key, value.toString())),
    );
  }

  Future<http.Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final uri = _buildUri(path, queryParameters: queryParameters);
      print('DEBUG: GET $uri');
      
      final response = await _client.get(
        uri,
        headers: await _getHeaders(),
      ).timeout(_timeout);
      
      print('DEBUG: GET success: ${response.statusCode}');
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<http.Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final uri = _buildUri(path, queryParameters: queryParameters);
      final response = await _client.post(
        uri,
        headers: await _getHeaders(),
        body: data != null ? jsonEncode(data) : null,
      ).timeout(_timeout);
      
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<http.Response> put(String path, {dynamic data}) async {
    try {
      final uri = _buildUri(path);
      final response = await _client.put(
        uri,
        headers: await _getHeaders(),
        body: data != null ? jsonEncode(data) : null,
      ).timeout(_timeout);
      
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<http.Response> delete(String path) async {
    try {
      final uri = _buildUri(path);
      final response = await _client.delete(
        uri,
        headers: await _getHeaders(),
      ).timeout(_timeout);
      
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

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
    } else {
      try {
        final body = jsonDecode(response.body);
        if (body is Map && body['message'] != null) {
          errorDescription = body['message'];
        }
      } catch (_) {}
    }

    return Failure(
      message: errorDescription,
      type: failureType,
      originalError: response,
    );
  }

  Failure _handleError(dynamic error) {
    print('ApiService Error: $error');
    
    String errorDescription = "حدث خطأ غير متوقع";
    FailureType failureType = FailureType.unknown;

    if (error is http.ClientException || error.toString().contains('SocketException')) {
       errorDescription = "تعذر الوصول إلى الخادم. تأكد من تشغيل السيرفر وعنوان الـ IP";
       failureType = FailureType.network;
    } else if (error.toString().contains('TimeoutException')) {
       errorDescription = "انتهت مهلة الاتصال بالخادم";
       failureType = FailureType.network;
    }

    return Failure(
      message: errorDescription,
      type: failureType,
      originalError: error,
    );
  }
}
