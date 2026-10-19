import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/checkout/domain/entities/checkout_params.dart';
import 'package:stronger_muscles/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:stronger_muscles/features/checkout/domain/usecases/place_order_usecase.dart';

class MockCheckoutRepository implements CheckoutRepository {
  CheckoutParams? lastParams;
  bool shouldSucceed = true;

  @override
  Future<Map<String, dynamic>> placeOrder(CheckoutParams params) async {
    lastParams = params;
    if (!shouldSucceed) {
      throw Exception('Payment failed');
    }
    return {
      'status': 'success',
      'data': {'id': 'order_123'},
    };
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

      expect(result['status'], 'success');
      expect(result['data']['id'], 'order_123');
      expect(mockRepository.lastParams, equals(params));
      expect(mockRepository.lastParams!.isOnlinePayment, isFalse);
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
  });
}
