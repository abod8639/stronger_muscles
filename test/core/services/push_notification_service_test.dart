import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/config/api_config.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/core/services/push_notification_service.dart';

class MockApiService implements ApiService {
  String? capturedPath;
  dynamic capturedData;
  dynamic mockResponseData;
  bool shouldThrowFailure = false;
  bool shouldThrowException = false;

  @override
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    capturedPath = path;
    capturedData = data;

    if (shouldThrowFailure) {
      throw Failure(message: 'Server error', type: FailureType.server);
    }
    if (shouldThrowException) {
      throw Exception('Unexpected socket crash');
    }

    return Response(
      requestOptions: RequestOptions(path: path),
      data: mockResponseData,
      statusCode: 200,
    );
  }

  @override
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters, bool includeAuth = true}) =>
      throw UnimplementedError();

  @override
  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) =>
      throw UnimplementedError();

  @override
  Future<Response> delete(String path) => throw UnimplementedError();
}

void main() {
  group('PushNotificationService Unit Tests', () {
    late MockApiService mockApi;
    late PushNotificationService service;

    setUp(() {
      mockApi = MockApiService();
      service = PushNotificationService(mockApi);
    });

    test('registerDeviceToken returns false immediately for empty or whitespace-only token', () async {
      final emptyResult = await service.registerDeviceToken('');
      final whitespaceResult = await service.registerDeviceToken('   \n  \t ');

      expect(emptyResult, isFalse);
      expect(whitespaceResult, isFalse);
      expect(mockApi.capturedPath, isNull);
    });

    test('registerDeviceToken posts trimmed token to ApiConfig.fcmToken and returns true on success', () async {
      mockApi.mockResponseData = {
        'status': 'success',
        'message': 'Token registered successfully',
      };

      final result = await service.registerDeviceToken('  device_token_xyz_123  ');

      expect(result, isTrue);
      expect(mockApi.capturedPath, ApiConfig.fcmToken);
      expect(mockApi.capturedData, {'fcm_token': 'device_token_xyz_123'});
    });

    test('registerDeviceToken returns false when server response status is not success', () async {
      mockApi.mockResponseData = {
        'status': 'failed',
        'message': 'Invalid token',
      };

      final result = await service.registerDeviceToken('device_token_fail');

      expect(result, isFalse);
    });

    test('registerDeviceToken returns false when response data is not a map', () async {
      mockApi.mockResponseData = 'non-map string payload';

      final result = await service.registerDeviceToken('device_token_abc');

      expect(result, isFalse);
    });

    test('registerDeviceToken catches Failure gracefully and returns false', () async {
      mockApi.shouldThrowFailure = true;

      final result = await service.registerDeviceToken('device_token_network_err');

      expect(result, isFalse);
    });

    test('registerDeviceToken catches unexpected Exceptions gracefully and returns false', () async {
      mockApi.shouldThrowException = true;

      final result = await service.registerDeviceToken('device_token_unexpected');

      expect(result, isFalse);
    });
  });
}
