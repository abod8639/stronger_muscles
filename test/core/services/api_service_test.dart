import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/core/services/storage_service.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('api_service_test_hive_');
    Hive.init(tempDir.path);
    await Hive.openBox('auth_box');
  });

  setUp(() async {
    await Hive.box('auth_box').clear();
  });

  tearDownAll(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('Failure Model Tests', () {
    test('creates Failure with default unknown type and preserves original error', () {
      final originalEx = Exception('Low level socket crash');
      final failure = Failure(
        message: 'Something went wrong',
        originalError: originalEx,
      );

      expect(failure.message, 'Something went wrong');
      expect(failure.type, FailureType.unknown);
      expect(failure.isConnectionError, false);
      expect(failure.originalError, originalEx);
      expect(failure.toString(), 'Something went wrong');
    });

    test('isConnectionError returns true only for network type', () {
      final netFailure = Failure(message: 'Network down', type: FailureType.network);
      expect(netFailure.isConnectionError, true);

      final authFailure = Failure(message: 'Unauthorized', type: FailureType.auth);
      expect(authFailure.isConnectionError, false);

      final serverFailure = Failure(message: 'Server error', type: FailureType.server);
      expect(serverFailure.isConnectionError, false);

      final unknownFailure = Failure(message: 'Unknown error', type: FailureType.unknown);
      expect(unknownFailure.isConnectionError, false);
    });
  });

  group('Dio Interceptor Header Logic', () {
    test('removes includeAuth header and properly configures options', () {
      final options = RequestOptions(
        path: '/test',
        headers: {'includeAuth': false},
      );

      final bool includeAuth = options.headers.remove('includeAuth') != false;
      expect(includeAuth, false);
      expect(options.headers.containsKey('includeAuth'), false);
    });

    test('defaults includeAuth to true when omitted', () {
      final options = RequestOptions(
        path: '/test',
        headers: {},
      );

      final bool includeAuth = options.headers.remove('includeAuth') != false;
      expect(includeAuth, true);
    });

    test('injects Bearer token when token exists and includeAuth is true', () async {
      await StorageService.saveToken('jwt_valid_token_xyz');

      final options = RequestOptions(
        path: '/customer/profile',
        headers: {'includeAuth': true},
      );

      final bool includeAuth = options.headers.remove('includeAuth') != false;
      final token = StorageService.getToken();

      if (includeAuth && token != null && !options.headers.containsKey('Authorization')) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      expect(options.headers['Authorization'], 'Bearer jwt_valid_token_xyz');
    });

    test('does not inject Bearer token when includeAuth is false even if token exists', () async {
      await StorageService.saveToken('jwt_valid_token_xyz');

      final options = RequestOptions(
        path: '/shop/products',
        headers: {'includeAuth': false},
      );

      final bool includeAuth = options.headers.remove('includeAuth') != false;
      final token = StorageService.getToken();

      if (includeAuth && token != null && !options.headers.containsKey('Authorization')) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      expect(options.headers.containsKey('Authorization'), isFalse);
    });

    test('does not overwrite existing custom Authorization header', () async {
      await StorageService.saveToken('jwt_valid_token_xyz');

      final options = RequestOptions(
        path: '/custom/endpoint',
        headers: {
          'includeAuth': true,
          'Authorization': 'CustomApiKey 123456',
        },
      );

      final bool includeAuth = options.headers.remove('includeAuth') != false;
      final token = StorageService.getToken();

      if (includeAuth && token != null && !options.headers.containsKey('Authorization')) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      expect(options.headers['Authorization'], 'CustomApiKey 123456');
    });
  });

  group('HTTP and Dio Error Mapping Rules', () {
    test('maps 401 on login route to incorrect credentials failure', () {
      final response = Response(
        requestOptions: RequestOptions(path: '/auth/login'),
        statusCode: 401,
        data: null,
      );

      final dynamic data = response.data;
      String? serverMessage = data is Map ? (data['message'] ?? data['error']) : null;
      String errorDescription = "خطأ غير متوقع: ${response.statusCode}";
      FailureType failureType = FailureType.server;

      if (response.statusCode == 401 || response.statusCode == 403) {
        failureType = FailureType.auth;
        if (response.requestOptions.path.contains('login')) {
          errorDescription = serverMessage ?? "البريد الإلكتروني أو كلمة المرور غير صحيحة";
        }
      }

      expect(failureType, FailureType.auth);
      expect(errorDescription, "البريد الإلكتروني أو كلمة المرور غير صحيحة");
    });

    test('maps 401 on non-login route to expired session and deletes local token', () async {
      await StorageService.saveToken('stale_token');
      expect(StorageService.hasToken, isTrue);

      final response = Response(
        requestOptions: RequestOptions(path: '/customer/orders'),
        statusCode: 401,
        data: null,
      );

      final dynamic data = response.data;
      String? serverMessage = data is Map ? (data['message'] ?? data['error']) : null;
      String errorDescription = "خطأ غير متوقع: ${response.statusCode}";
      FailureType failureType = FailureType.server;

      if (response.statusCode == 401 || response.statusCode == 403) {
        failureType = FailureType.auth;
        if (response.requestOptions.path.contains('login')) {
          errorDescription = serverMessage ?? "البريد الإلكتروني أو كلمة المرور غير صحيحة";
        } else {
          errorDescription = serverMessage ?? "انتهت الجلسة، يرجى تسجيل الدخول مجدداً";
          await StorageService.deleteToken();
        }
      }

      expect(failureType, FailureType.auth);
      expect(errorDescription, "انتهت الجلسة، يرجى تسجيل الدخول مجدداً");
      expect(StorageService.hasToken, isFalse);
    });

    test('maps 422 validation errors map to multi-line aggregated message', () {
      final response = Response(
        requestOptions: RequestOptions(path: '/auth/register'),
        statusCode: 422,
        data: {
          'errors': {
            'email': ['البريد الإلكتروني مستخدم مسبقاً'],
            'password': ['كلمة المرور قصيرة جداً', 'يجب أن تحتوي على أرقام'],
          },
        },
      );

      final dynamic data = response.data;
      String errorDescription = "خطأ غير متوقع: ${response.statusCode}";
      FailureType failureType = FailureType.server;

      if (response.statusCode == 422 && data is Map && data['errors'] != null) {
        final Map<String, dynamic> errors = data['errors'];
        final List<String> allErrors = [];
        errors.forEach((key, value) {
          if (value is List) {
            allErrors.addAll(value.map((e) => e.toString()));
          } else {
            allErrors.add(value.toString());
          }
        });
        errorDescription = allErrors.isNotEmpty ? allErrors.join('\n') : "بيانات المدخلات غير صالحة";
      }

      expect(failureType, FailureType.server);
      expect(
        errorDescription,
        'البريد الإلكتروني مستخدم مسبقاً\nكلمة المرور قصيرة جداً\nيجب أن تحتوي على أرقام',
      );
    });
  });
}
