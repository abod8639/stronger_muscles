import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/core/services/push_notification_service.dart';
import 'package:stronger_muscles/features/payment/data/models/payment_init_result.dart';
import 'package:stronger_muscles/features/payment/data/repositories/payment_repository.dart';

class FakeApiService implements ApiService {
  String? lastPostPath;
  dynamic lastPostData;
  dynamic mockPostResponse;
  bool shouldThrow = false;

  @override
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    lastPostPath = path;
    lastPostData = data;

    if (shouldThrow) {
      throw Failure(message: 'Network request failed', type: FailureType.network);
    }

    return Response(
      requestOptions: RequestOptions(path: path),
      data: mockPostResponse,
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
  group('PaymentInitResult Model Tests', () {
    test('fromJson parses all fields correctly', () {
      final json = {
        'success': true,
        'payment_url': 'https://accept.paymob.com/test_iframe',
        'transaction_id': 'tx_998877',
        'reference': '123',
        'client_secret': 'sec_abc',
      };

      final result = PaymentInitResult.fromJson(json);

      expect(result.success, true);
      expect(result.paymentUrl, 'https://accept.paymob.com/test_iframe');
      expect(result.transactionId, 'tx_998877');
      expect(result.reference, '123');
      expect(result.clientSecret, 'sec_abc');
    });

    test('fromJson handles null / missing values gracefully', () {
      final json = <String, dynamic>{};

      final result = PaymentInitResult.fromJson(json);

      expect(result.success, false);
      expect(result.paymentUrl, '');
      expect(result.transactionId, '');
      expect(result.reference, '');
      expect(result.clientSecret, isNull);
    });
  });

  group('PaymentRepository Tests', () {
    late FakeApiService fakeApi;
    late PaymentRepository repo;

    setUp(() {
      fakeApi = FakeApiService();
      repo = PaymentRepository(fakeApi);
    });

    test('initiatePayment posts correct path and payload', () async {
      fakeApi.mockPostResponse = {
        'status': 'success',
        'data': {
          'success': true,
          'payment_url': 'https://checkout.stripe.com/pay/pi_123',
          'transaction_id': 'pi_123',
          'reference': '45',
        },
      };

      final result = await repo.initiatePayment(
        orderId: 45,
        gateway: 'stripe',
        firstName: 'Dexter',
        lastName: 'Morgan',
      );

      expect(fakeApi.lastPostPath, '/customer/orders/45/pay');
      expect(fakeApi.lastPostData, {
        'gateway': 'stripe',
        'first_name': 'Dexter',
        'last_name': 'Morgan',
      });
      expect(result.success, true);
      expect(result.paymentUrl, 'https://checkout.stripe.com/pay/pi_123');
      expect(result.transactionId, 'pi_123');
      expect(result.reference, '45');
    });

    test('initiatePayment throws Failure on invalid server response', () async {
      fakeApi.mockPostResponse = {'status': 'error', 'data': null};

      expect(
        () => repo.initiatePayment(orderId: 10),
        throwsA(isA<Failure>()),
      );
    });

    test('initiatePayment propagates Failure on network error', () async {
      fakeApi.shouldThrow = true;

      expect(
        () => repo.initiatePayment(orderId: 10),
        throwsA(isA<Failure>()),
      );
    });
  });

  group('PushNotificationService Tests', () {
    late FakeApiService fakeApi;
    late PushNotificationService service;

    setUp(() {
      fakeApi = FakeApiService();
      service = PushNotificationService(fakeApi);
    });

    test('registerDeviceToken successfully registers valid token', () async {
      fakeApi.mockPostResponse = {
        'status': 'success',
        'message': 'FCM token updated successfully',
      };

      final result = await service.registerDeviceToken('fcm_token_sample_123');

      expect(result, true);
      expect(fakeApi.lastPostPath, '/customer/fcm-token');
      expect(fakeApi.lastPostData, {'fcm_token': 'fcm_token_sample_123'});
    });

    test('registerDeviceToken skips call and returns false on empty token', () async {
      final result = await service.registerDeviceToken('   ');

      expect(result, false);
      expect(fakeApi.lastPostPath, isNull);
    });

    test('registerDeviceToken returns false safely on network failure', () async {
      fakeApi.shouldThrow = true;

      final result = await service.registerDeviceToken('token_abc');

      expect(result, false);
    });
  });
}
