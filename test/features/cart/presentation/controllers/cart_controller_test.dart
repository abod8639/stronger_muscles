import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/cart/domain/entities/cart_item_entity.dart';
import 'package:stronger_muscles/features/cart/domain/repositories/cart_repository.dart';
import 'package:stronger_muscles/features/cart/presentation/controllers/cart_controller.dart';
import 'package:stronger_muscles/features/cart/presentation/controllers/cart_di.dart';
import 'package:stronger_muscles/features/product/domain/entities/localized_string_entity.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';

class FakeCartRepository implements CartRepository {
  List<CartItemEntity> items = [];
  Completer<void>? delayCompleter;

  @override
  Future<Either<Failure, List<CartItemEntity>>> getCartItems() async {
    return Right(items);
  }

  @override
  Future<Either<Failure, Unit>> addToCart(
    ProductEntity product, {
    String? selectedFlavor,
    String? selectedSize,
    int quantity = 1,
  }) async {
    if (delayCompleter != null) {
      await delayCompleter!.future;
    }
    items.add(
      CartItemEntity(
        id: '1',
        userId: 'u1',
        product: product,
        quantity: quantity,
        selectedFlavor: selectedFlavor,
        selectedSize: selectedSize,
      ),
    );
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> removeFromCart(String itemId) async {
    items.removeWhere((i) => i.id == itemId);
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> updateQuantity(String itemId, int quantity) async {
    final idx = items.indexWhere((i) => i.id == itemId);
    if (idx != -1) {
      if (quantity <= 0) {
        items.removeAt(idx);
      } else {
        items[idx] = items[idx].copyWith(quantity: quantity);
      }
    }
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> clearCart() async {
    items.clear();
    return const Right(unit);
  }
}

void main() {
  group('CartController Optimistic UI Tests', () {
    late FakeCartRepository fakeRepo;
    late CartController controller;

    const sampleProduct = ProductEntity(
      id: 'prod-1',
      name: LocalizedStringEntity(en: 'Test Product', ar: 'منتج تجريبي'),
      price: 100.0,
      stockQuantity: 10,
    );

    late ProviderContainer container;

    setUp(() async {
      fakeRepo = FakeCartRepository();
      container = ProviderContainer(
        overrides: [
          cartRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      );
      controller = container.read(cartControllerProvider.notifier);
      await container.read(cartControllerProvider.future);
    });

    tearDown(() {
      container.dispose();
    });

    test('addToCart updates state INSTANTLY before async operation finishes', () async {
      fakeRepo.delayCompleter = Completer<void>();

      // Call addToCart without awaiting completion
      final future = controller.addToCart(sampleProduct, quantity: 1);

      // Verify that state is updated IMMEDIATELY synchronously
      expect(controller.state.hasValue, isTrue);
      expect(controller.cartCount, 1);
      expect(controller.cartItems.first.product.id, 'prod-1');
      expect(controller.isInCart('prod-1'), isTrue);

      // Complete the background operation
      fakeRepo.delayCompleter!.complete();
      await future;

      // State is still present and valid
      expect(controller.cartCount, 1);
    });

    test('increaseQuantity updates quantity instantly', () async {
      final initialItem = CartItemEntity(
        id: 'cart-1',
        userId: 'u1',
        product: sampleProduct,
        quantity: 1,
      );
      controller.state = AsyncData([initialItem]);

      await controller.increaseQuantity(initialItem);

      expect(controller.cartItems.first.quantity, 2);
    });

    test('decreaseQuantity updates quantity instantly and removes when reaches 0', () async {
      final initialItem = CartItemEntity(
        id: 'cart-1',
        userId: 'u1',
        product: sampleProduct,
        quantity: 1,
      );
      controller.state = AsyncData([initialItem]);

      await controller.decreaseQuantity(initialItem);

      expect(controller.cartCount, 0);
    });

    test('removeFromCart removes item instantly', () async {
      final initialItem = CartItemEntity(
        id: 'cart-1',
        userId: 'u1',
        product: sampleProduct,
        quantity: 2,
      );
      controller.state = AsyncData([initialItem]);

      await controller.removeFromCart('cart-1');

      expect(controller.cartCount, 0);
    });
  });
}
