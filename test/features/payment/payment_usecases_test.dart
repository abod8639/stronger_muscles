import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/payment/data/models/payment_init_result.dart';
import 'package:stronger_muscles/features/payment/data/repositories/payment_repository.dart';
import 'package:stronger_muscles/features/payment/domain/entities/payment_result_entity.dart';
import 'package:stronger_muscles/features/payment/domain/usecases/initiate_payment_usecase.dart';
import 'package:stronger_muscles/features/payment/presentation/controllers/payment_controller.dart';

class MockPaymentRepository implements PaymentRepository {
  PaymentResultEntity? mockResult;
  bool shouldThrow = false;

  @override
  Future<PaymentResultEntity> initiatePayment({
    required dynamic orderId,
    String gateway = 'paymob',
    String? firstName,
    String? lastName,
  }) async {
    if (shouldThrow) {
      throw Exception('Payment initiation error');
    }
    return mockResult ??
        const PaymentResultEntity(
          success: true,
          paymentUrl: 'https://paymob.com/iframe/123',
          transactionId: 'txn_123',
          reference: 'ref_123',
        );
  }
}

void main() {
  group('Payment Clean Architecture Tests', () {
    late MockPaymentRepository mockRepository;
    late InitiatePaymentUseCase initiatePaymentUseCase;

    setUp(() {
      mockRepository = MockPaymentRepository();
      initiatePaymentUseCase = InitiatePaymentUseCase(mockRepository);
    });

    test('InitiatePaymentUseCase returns PaymentResultEntity on success', () async {
      final result = await initiatePaymentUseCase(orderId: 101, gateway: 'stripe');

      expect(result.success, true);
      expect(result.paymentUrl, 'https://paymob.com/iframe/123');
      expect(result.hasPaymentUrl, true);
      expect(result.transactionId, 'txn_123');
      expect(result.reference, 'ref_123');
    });

    test('PaymentResultEntity equality and copyWith work properly', () {
      const entity1 = PaymentResultEntity(
        success: true,
        paymentUrl: 'url',
        transactionId: '1',
        reference: 'ref',
      );
      const entity2 = PaymentResultEntity(
        success: true,
        paymentUrl: 'url',
        transactionId: '1',
        reference: 'ref',
      );
      expect(entity1, equals(entity2));

      final entity3 = entity1.copyWith(paymentUrl: 'new_url');
      expect(entity3.paymentUrl, 'new_url');
      expect(entity3.transactionId, '1');
    });

    test('PaymentInitResult model maps to and from PaymentResultEntity', () {
      final model = PaymentInitResult(
        success: true,
        paymentUrl: 'https://example.com/pay',
        transactionId: 'tx_55',
        reference: 'ref_55',
        clientSecret: 'secret',
      );

      final entity = model.toEntity();
      expect(entity.success, true);
      expect(entity.paymentUrl, 'https://example.com/pay');
      expect(entity.transactionId, 'tx_55');
      expect(entity.clientSecret, 'secret');

      final reconstructedModel = PaymentInitResult.fromEntity(entity);
      expect(reconstructedModel.success, true);
      expect(reconstructedModel.paymentUrl, 'https://example.com/pay');
      expect(reconstructedModel.transactionId, 'tx_55');
      expect(reconstructedModel.clientSecret, 'secret');
    });

    test('PaymentController manages AsyncValue state transitions', () async {
      final container = ProviderContainer(
        overrides: [
          paymentRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(paymentControllerProvider.notifier);
      expect(container.read(paymentControllerProvider).value, isNull);

      final result = await controller.initiatePayment(orderId: 50);
      expect(result?.success, isTrue);
      expect(container.read(paymentControllerProvider).value?.transactionId, 'txn_123');

      controller.reset();
      expect(container.read(paymentControllerProvider).value, isNull);
    });
  });
}
