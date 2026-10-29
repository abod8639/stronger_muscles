import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/checkout/data/mappers/checkout_mapper.dart';
import 'package:stronger_muscles/features/checkout/data/models/checkout_quote_model.dart';
import 'package:stronger_muscles/features/checkout/data/models/checkout_result_model.dart';
import 'package:stronger_muscles/features/checkout/domain/entities/checkout_params.dart';
import 'package:stronger_muscles/features/checkout/domain/entities/checkout_quote.dart';
import 'package:stronger_muscles/features/checkout/domain/entities/checkout_result_entity.dart';
import 'package:stronger_muscles/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:stronger_muscles/features/checkout/domain/usecases/get_checkout_quote_usecase.dart';
import 'package:stronger_muscles/features/checkout/domain/usecases/place_order_usecase.dart';
import 'package:stronger_muscles/features/checkout/presentation/controllers/checkout_controller.dart';
import 'package:stronger_muscles/features/profile/domain/entities/address_entity.dart';

class MockCheckoutRepository implements CheckoutRepository {
  CheckoutParams? lastParams;
  List<CheckoutItemEntity>? lastQuotedItems;
  bool shouldSucceed = true;

  @override
  Future<Either<Failure, CheckoutQuote>> getQuote(
    List<CheckoutItemEntity> items,
  ) async {
    lastQuotedItems = items;
    if (!shouldSucceed) {
      return const Left(ServerFailure(message: 'Pricing failed'));
    }
    return const Right(
      CheckoutQuote(
        subtotal: 200,
        shippingCost: 50,
        taxAmount: 28,
        totalAmount: 278,
        taxRate: 14,
      ),
    );
  }

  @override
  Future<Either<Failure, CheckoutResultEntity>> placeOrder(
    CheckoutParams params,
  ) async {
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

  group('Checkout Clean Architecture & Domain Tests', () {
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

    test('CheckoutParams formats payload map properly via extension mapper', () {
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

    test('CheckoutResultModel parses json safely with fallback defaults and converts to entity', () {
      final emptyResult = CheckoutResultModel.fromJson(const {}).toEntity();
      expect(emptyResult.orderId, '');
      expect(emptyResult.status, 'success');
      expect(emptyResult.paymentUrl, isNull);

      final nestedResult = CheckoutResultModel.fromJson(const {
        'status': 'ok',
        'data': {'id': 9999, 'payment_url': 'https://pay.example.com'},
      }).toEntity();
      expect(nestedResult.orderId, '9999');
      expect(nestedResult.status, 'ok');
      expect(nestedResult.paymentUrl, 'https://pay.example.com');
    });

    test('CheckoutController guards against submission with no selected address', () async {
      final controller = CheckoutController.test(
        placeOrderUseCase: useCase,
        initialAddress: null,
      );

      await controller.placeOrder();

      expect(controller.state.hasError, isTrue);
      expect(controller.state.failure, isA<ValidationFailure>());
      expect(mockRepository.lastParams, isNull);
    });

    test('CheckoutController guards against submission with empty cart', () async {
      const address = AddressEntity(
        id: 1,
        street: 'Main St',
        city: 'Cairo',
      );

      final controller = CheckoutController.test(
        placeOrderUseCase: useCase,
        initialAddress: address,
        testCartItems: const [],
      );

      await controller.placeOrder();

      expect(controller.state.hasError, isTrue);
      expect(controller.state.failure, isA<ValidationFailure>());
      expect(mockRepository.lastParams, isNull);
    });
  });

  group('Checkout quote (delivery fee & tax)', () {
    test('GetCheckoutQuoteUseCase returns the server price for the items', () async {
      final quoteUseCase = GetCheckoutQuoteUseCase(mockRepository);
      const items = [CheckoutItemEntity(productId: 'prod_1', quantity: 2)];

      final result = await quoteUseCase(items);

      expect(mockRepository.lastQuotedItems, items);
      final quote = result.getOrElse((_) => throw StateError('expected a quote'));
      expect(quote.shippingCost, 50);
      expect(quote.taxAmount, 28);
      expect(quote.totalAmount, 278);
      expect(quote.hasFreeDelivery, isFalse);
    });

    test('GetCheckoutQuoteUseCase propagates failures', () async {
      mockRepository.shouldSucceed = false;

      final result = await GetCheckoutQuoteUseCase(mockRepository)(const []);

      expect(result.isLeft(), isTrue);
    });

    test('CheckoutQuoteModel parses the API response and maps to the entity', () {
      final model = CheckoutQuoteModel.fromJson({
        'status': 'success',
        'data': {
          'subtotal': 230,
          'shipping_cost': 0,
          'tax_amount': 32.2,
          'discount': 0,
          'total_amount': 262.2,
          'tax_rate': 14,
          'free_delivery_threshold': 200,
          'currency': 'EGP',
          'is_accepting_orders': false,
        },
      });

      final quote = model.toEntity();
      expect(quote.subtotal, 230.0);
      expect(quote.shippingCost, 0.0);
      expect(quote.hasFreeDelivery, isTrue);
      expect(quote.taxAmount, 32.2);
      expect(quote.totalAmount, 262.2);
      expect(quote.taxRate, 14.0);
      expect(quote.freeDeliveryThreshold, 200.0);
      expect(quote.isAcceptingOrders, isFalse);
    });

    test('CheckoutQuoteModel tolerates missing optional fields', () {
      final quote = CheckoutQuoteModel.fromJson({
        'subtotal': '100',
        'shipping_cost': 50,
        'total_amount': 150,
      }).toEntity();

      expect(quote.subtotal, 100.0);
      expect(quote.taxAmount, 0.0);
      expect(quote.isAcceptingOrders, isTrue);
      expect(quote.currency, 'EGP');
    });
  });
}
