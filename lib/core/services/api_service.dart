import 'dart:async';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import '../../features/profile/presentation/controllers/language_controller.dart';
import '../../config/api_config.dart';
import 'storage_service.dart';
import '../errors/failures.dart';

class ApiService {
  late final Dio _dio;
  final Duration _timeout = const Duration(seconds: 15);

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: _timeout,
        receiveTimeout: _timeout,
        responseType: ResponseType.json,
      ),
    );

    // إضافة Interceptor للتعامل مع الـ Headers والـ Logging تلقائياً
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = StorageService.getToken();
          final languageCode = getx.Get.find<LanguageController>()
              .currentLocale
              .value
              .languageCode;

          options.headers['Content-Type'] = 'application/json';
          options.headers['Accept'] = 'application/json';
          options.headers['Accept-Language'] = languageCode;

          if (token != null && !options.headers.containsKey('Authorization')) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          print('🚀 Request: ${options.method} ${options.uri}');
          if (options.data != null) print('📦 Body: ${options.data}');

          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );
  }

  // --- Methods ---

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool includeAuth = true,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: {'includeAuth': includeAuth}),
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw _handleGeneralError(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw _handleGeneralError(e);
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw _handleGeneralError(e);
    }
  }

  Future<Response> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw _handleGeneralError(e);
    }
  }

  // --- Error Handling ---

  Failure _handleDioError(DioException e) {
    String errorDescription = "حدث خطأ غير متوقع";
    FailureType failureType = FailureType.unknown;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        errorDescription = "انتهت مهلة الاتصال بالخادم";
        failureType = FailureType.network;
        break;
      case DioExceptionType.badResponse:
        return _handleHttpError(e.response!);
      case DioExceptionType.cancel:
        errorDescription = "تم إلغاء الطلب";
        break;
      case DioExceptionType.connectionError:
        errorDescription = "تعذر الوصول إلى الخادم. تأكد من الاتصال بالشبكة";
        failureType = FailureType.network;
        break;
      default:
        errorDescription = "خطأ في الاتصال بالشبكة";
        failureType = FailureType.network;
    }

    return Failure(message: errorDescription, type: failureType);
  }

  Failure _handleHttpError(Response response) {
    String errorDescription = "خطأ غير متوقع: ${response.statusCode}";
    FailureType failureType = FailureType.server;

    final dynamic data = response.data;
    String? serverMessage = data is Map
        ? (data['message'] ?? data['error'])
        : null;

    if (response.statusCode == 401 || response.statusCode == 403) {
      failureType = FailureType.auth;
      // التحقق من المسار إذا لزم الأمر عبر response.requestOptions.path
      if (response.requestOptions.path.contains('login')) {
        errorDescription =
            serverMessage ?? "البريد الإلكتروني أو كلمة المرور غير صحيحة";
      } else {
        errorDescription =
            serverMessage ?? "انتهت الجلسة، يرجى تسجيل الدخول مجدداً";
        StorageService.deleteToken();
      }
    } else if (response.statusCode == 422) {
      if (data is Map && data['errors'] != null) {
        final Map<String, dynamic> errors = data['errors'];
        final List<String> allErrors = [];
        errors.forEach((key, value) {
          if (value is List) {
            allErrors.addAll(value.map((e) => e.toString()));
          } else {
            allErrors.add(value.toString());
          }
        });
        errorDescription = allErrors.isNotEmpty
            ? allErrors.join('\n')
            : "بيانات المدخلات غير صالحة";
      }
    } else {
      errorDescription = serverMessage ?? errorDescription;
    }

    print('❌ API Error (${response.statusCode}): $errorDescription');
    return Failure(message: errorDescription, type: failureType);
  }

  Failure _handleGeneralError(dynamic error) {
    if (error is Failure) return error;
    return Failure(message: "حدث خطأ غير متوقع", type: FailureType.unknown);
  }
}
