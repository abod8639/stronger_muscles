import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/checkout/domain/entities/checkout_params.dart';
import 'package:stronger_muscles/features/checkout/domain/entities/checkout_result_entity.dart';
import 'package:stronger_muscles/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:stronger_muscles/features/checkout/domain/usecases/place_order_usecase.dart';

class MockCheckoutRepository implements CheckoutRepository {
  CheckoutParams? lastParams;
  bool shouldSucceed = true;

  @override
  Future<Either<Failure, CheckoutResultEntity>> placeOrder(
    CheckoutParams params, {
    CancelToken? cancelToken,
  }) async {
    lastParams = params;
    if (!shouldSucceed) {
      return const Left(ServerFailure(message: 'Payment failed'));
    }
    return const Right(
      CheckoutResultEntity(
        orderId: 'order_123',
        status: 'success',
        rawData: {'status': 'success', 'data': {'id': 'order_123'}},
      ),
    );
  }
}

void main() {
  late MockCheckoutRepository mockRepository;
  late PlaceOrderUseCase useCase;

  setUp(() {
    mockRepository = MockCheckoutRepository();
    useCase = PlaceOrderUseCase(mockRepository);
  });

  group('Checkout Clean Architecture Tests', () {
    test('PlaceOrderUseCase executes successfully with cash payment', () async {
      const params = CheckoutParams(
        addressId: 'addr_1',
        paymentMethod: 'cash',
        notes: 'Handle with care',
        customerName: 'Dexter Developer',
        items: [
          CheckoutItemEntity(
            productId: 'prod_1',
            quantity: 2,
            selectedFlavor: 'Chocolate',
            selectedSize: '2kg',
            unitPrice: 50.0,
            productName: 'Whey Protein',
          ),
        ],
      );

      final result = await useCase(params);

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected Right, got Left: $failure'),
        (data) {
          expect(data.status, 'success');
          expect(data.orderId, 'order_123');
        },
      );
      expect(mockRepository.lastParams, equals(params));
      expect(mockRepository.lastParams!.isOnlinePayment, isFalse);
    });

    test('PlaceOrderUseCase returns Failure when repository fails', () async {
      mockRepository.shouldSucceed = false;

      const params = CheckoutParams(
        addressId: 'addr_1',
        paymentMethod: 'card',
        items: [],
      );

      final result = await useCase(params);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.toMessage(), 'Payment failed');
        },
        (_) => fail('Expected Left, got Right'),
      );
    });

    test('CheckoutParams identifies online payment gateways correctly', () {
      const cardParams = CheckoutParams(
        addressId: 'a1',
        paymentMethod: 'card',
        items: [],
      );
      expect(cardParams.isOnlinePayment, isTrue);
      expect(cardParams.gateway, 'paymob');

      const stripeParams = CheckoutParams(
        addressId: 'a1',
        paymentMethod: 'stripe',
        items: [],
      );
      expect(stripeParams.isOnlinePayment, isTrue);
      expect(stripeParams.gateway, 'stripe');

      const cashParams = CheckoutParams(
        addressId: 'a1',
        paymentMethod: 'cash',
        items: [],
      );
      expect(cashParams.isOnlinePayment, isFalse);
    });

    test('CheckoutParams formats payload map properly', () {
      const params = CheckoutParams(
        addressId: 'addr_abc',
        paymentMethod: 'cash',
        notes: 'Door code 1234',
        items: [
          CheckoutItemEntity(
            productId: 'p_10',
            quantity: 3,
            selectedFlavor: 'Vanilla',
            selectedSize: '1kg',
          ),
        ],
      );

      final payload = params.toPayload();

      expect(payload['address_id'], 'addr_abc');
      expect(payload['payment_method'], 'cash');
      expect(payload['notes'], 'Door code 1234');
      expect(payload['items'], isA<List>());
      expect((payload['items'] as List).first['product_id'], 'p_10');
      expect((payload['items'] as List).first['quantity'], 3);
    });

    test('CheckoutResultEntity parses json safely with fallback defaults', () {
      final emptyResult = CheckoutResultEntity.fromJson(const {});
      expect(emptyResult.orderId, '');
      expect(emptyResult.status, 'success');
      expect(emptyResult.paymentUrl, isNull);

      final nestedResult = CheckoutResultEntity.fromJson(const {
        'status': 'ok',
        'data': {'id': 9999},
      });
      expect(nestedResult.orderId, '9999');
      expect(nestedResult.status, 'ok');
    });
  });
}
