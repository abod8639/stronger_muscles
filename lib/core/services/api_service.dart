import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/profile/presentation/controllers/language_controller.dart';
import '../config/api_config.dart';
import 'storage_service.dart';
import '../errors/errors.dart';

part 'api_service.g.dart';

@Riverpod(keepAlive: true)
ApiService apiService(ApiServiceRef ref) {
  return ApiService(ref);
}

class ApiService {
  late final Dio _dio;
  final Duration _defaultTimeout = const Duration(seconds: 15);
  final Ref _ref;

  ApiService(this._ref) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: _defaultTimeout,
        receiveTimeout: _defaultTimeout,
        sendTimeout: _defaultTimeout,
        responseType: ResponseType.json,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = StorageService.getToken();
          final locale = _ref.read(languageControllerProvider);
          final languageCode = locale.languageCode;

          options.headers['Content-Type'] = 'application/json';
          options.headers['Accept'] = 'application/json';
          options.headers['Accept-Language'] = languageCode;

          final bool includeAuth = options.headers.remove('includeAuth') != false;

          if (includeAuth && token != null && !options.headers.containsKey('Authorization')) {
            options.headers['Authorization'] = 'Bearer $token';
          }

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
    CancelToken? cancelToken,
    Duration? timeout,
  }) async {
    try {
      final options = Options(
        headers: {'includeAuth': includeAuth},
        sendTimeout: timeout,
        receiveTimeout: timeout,
      );
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e, st) {
      throw NetworkErrorHandler.handleDioError(e, st);
    } catch (e, st) {
      throw NetworkErrorHandler.handle(e, st);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Duration? timeout,
  }) async {
    try {
      final options = Options(
        sendTimeout: timeout,
        receiveTimeout: timeout,
      );
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e, st) {
      throw NetworkErrorHandler.handleDioError(e, st);
    } catch (e, st) {
      throw NetworkErrorHandler.handle(e, st);
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Duration? timeout,
  }) async {
    try {
      final options = Options(
        sendTimeout: timeout,
        receiveTimeout: timeout,
      );
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e, st) {
      throw NetworkErrorHandler.handleDioError(e, st);
    } catch (e, st) {
      throw NetworkErrorHandler.handle(e, st);
    }
  }

  Future<Response> delete(
    String path, {
    CancelToken? cancelToken,
    Duration? timeout,
  }) async {
    try {
      final options = Options(
        sendTimeout: timeout,
        receiveTimeout: timeout,
      );
      final response = await _dio.delete(
        path,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e, st) {
      throw NetworkErrorHandler.handleDioError(e, st);
    } catch (e, st) {
      throw NetworkErrorHandler.handle(e, st);
    }
  }
}
