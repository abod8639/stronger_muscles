import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/payment/data/models/payment_init_result.dart';
import 'package:stronger_muscles/features/payment/data/models/payment_method_model.dart';
import 'package:stronger_muscles/features/payment/data/repositories/payment_repository.dart';
import 'package:stronger_muscles/features/payment/domain/entities/payment_method_entity.dart';
import 'package:stronger_muscles/features/payment/domain/entities/payment_result_entity.dart';
import 'package:stronger_muscles/features/payment/domain/usecases/get_payment_methods_usecase.dart';
import 'package:stronger_muscles/features/payment/domain/usecases/initiate_payment_usecase.dart';
import 'package:stronger_muscles/features/payment/presentation/controllers/payment_controller.dart';

class MockPaymentRepository implements PaymentRepository {
  PaymentResultEntity? mockResult;
  List<PaymentMethodEntity> mockMethods = [];
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

  @override
  Future<List<PaymentMethodEntity>> getAvailablePaymentMethods({
    String lang = 'ar',
  }) async {
    if (shouldThrow) {
      throw Exception('Failed to load payment methods');
    }
    if (mockMethods.isNotEmpty) return mockMethods;
    return const [
      PaymentMethodEntity(
        id: 'cash',
        title: 'الدفع عند الاستلام',
        icon: Icons.payments_outlined,
      ),
      PaymentMethodEntity(
        id: 'card',
        title: 'بطاقة ائتمان',
        icon: Icons.credit_card,
      ),
    ];
  }
}

void main() {
  group('Payment Clean Architecture Tests', () {
    late MockPaymentRepository mockRepository;
    late InitiatePaymentUseCase initiatePaymentUseCase;
    late GetPaymentMethodsUseCase getPaymentMethodsUseCase;

    setUp(() {
      mockRepository = MockPaymentRepository();
      initiatePaymentUseCase = InitiatePaymentUseCase(mockRepository);
      getPaymentMethodsUseCase = GetPaymentMethodsUseCase(mockRepository);
    });

    test('InitiatePaymentUseCase returns PaymentResultEntity on success', () async {
      final result = await initiatePaymentUseCase(orderId: 101, gateway: 'stripe');

      expect(result.success, true);
      expect(result.paymentUrl, 'https://paymob.com/iframe/123');
      expect(result.hasPaymentUrl, true);
      expect(result.transactionId, 'txn_123');
      expect(result.reference, 'ref_123');
    });

    test('GetPaymentMethodsUseCase returns list of PaymentMethodEntity', () async {
      final methods = await getPaymentMethodsUseCase(lang: 'ar');

      expect(methods.length, 2);
      expect(methods.first.id, 'cash');
      expect(methods.first.title, 'الدفع عند الاستلام');
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

    test('PaymentMethodEntity copyWith and equality work properly', () {
      const method1 = PaymentMethodEntity(
        id: 'card',
        title: 'بطاقة بنكية',
        icon: Icons.credit_card,
      );
      const method2 = PaymentMethodEntity(
        id: 'card',
        title: 'بطاقة بنكية',
        icon: Icons.credit_card,
      );
      expect(method1, equals(method2));

      final updated = method1.copyWith(title: 'بطاقة مدى');
      expect(updated.title, 'بطاقة مدى');
      expect(updated.id, 'card');
    });

    test('PaymentMethodModel fromJson and toJson maintain data consistency', () {
      final json = {
        'id': 'card',
        'title': 'بطاقة بنكية',
        'subtitle': 'الدفع بالفيزا',
        'gateway': 'paymob',
        'is_enabled': true,
      };

      final model = PaymentMethodModel.fromJson(json);
      expect(model.id, 'card');
      expect(model.title, 'بطاقة بنكية');
      expect(model.subtitle, 'الدفع بالفيزا');
      expect(model.icon, Icons.credit_card);
      expect(model.isEnabled, true);

      final serialized = model.toJson();
      expect(serialized['id'], 'card');
      expect(serialized['title'], 'بطاقة بنكية');
      expect(serialized['is_enabled'], true);
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
