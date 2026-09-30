import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/cart/domain/entities/cart_item_entity.dart';
import 'package:stronger_muscles/features/cart/domain/repositories/cart_repository.dart';
import 'package:stronger_muscles/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:stronger_muscles/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:stronger_muscles/features/cart/domain/usecases/get_cart_items_usecase.dart';
import 'package:stronger_muscles/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:stronger_muscles/features/cart/domain/usecases/update_cart_quantity_usecase.dart';
import 'package:stronger_muscles/features/product/domain/entities/localized_string_entity.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_size_entity.dart';

class MockCartRepository implements CartRepository {
  List<CartItemEntity> items = [];

  @override
  Future<List<CartItemEntity>> getCartItems() async => items;

  @override
  Future<void> addToCart(
    ProductEntity product, {
    String? selectedFlavor,
    String? selectedSize,
    int quantity = 1,
  }) async {
    final index = items.indexWhere(
      (i) =>
          i.product.id == product.id &&
          i.selectedFlavor == selectedFlavor &&
          i.selectedSize == selectedSize,
    );
    if (index != -1) {
      items[index] = items[index].copyWith(
        quantity: items[index].quantity + quantity,
      );
    } else {
      items.add(
        CartItemEntity(
          id: 'item-${items.length + 1}',
          userId: 'user-1',
          product: product,
          quantity: quantity,
          selectedFlavor: selectedFlavor,
          selectedSize: selectedSize,
        ),
      );
    }
  }

  @override
  Future<void> removeFromCart(String itemId) async {
    items.removeWhere((i) => i.id == itemId);
  }

  @override
  Future<void> updateQuantity(String itemId, int quantity) async {
    if (quantity <= 0) {
      items.removeWhere((i) => i.id == itemId);
    } else {
      final index = items.indexWhere((i) => i.id == itemId);
      if (index != -1) {
        items[index] = items[index].copyWith(quantity: quantity);
      }
    }
  }

  @override
  Future<void> clearCart() async {
    items.clear();
  }
}

void main() {
  group('Cart Clean Architecture Domain & UseCase Tests', () {
    late MockCartRepository repository;
    late GetCartItemsUseCase getCartItemsUseCase;
    late AddToCartUseCase addToCartUseCase;
    late RemoveFromCartUseCase removeFromCartUseCase;
    late UpdateCartQuantityUseCase updateCartQuantityUseCase;
    late ClearCartUseCase clearCartUseCase;

    const sampleProduct = ProductEntity(
      id: 'p1',
      name: LocalizedStringEntity(en: 'Iso Whey', ar: 'ايزو واي'),
      price: 1500.0,
      discountPrice: 1300.0,
      stockQuantity: 10,
      productSizes: [
        ProductSizeEntity(size: '1kg', price: 1500.0, discountPrice: 1300.0),
        ProductSizeEntity(size: '2kg', price: 2600.0),
      ],
    );

    setUp(() {
      repository = MockCartRepository();
      getCartItemsUseCase = GetCartItemsUseCase(repository);
      addToCartUseCase = AddToCartUseCase(repository);
      removeFromCartUseCase = RemoveFromCartUseCase(repository);
      updateCartQuantityUseCase = UpdateCartQuantityUseCase(repository);
      clearCartUseCase = ClearCartUseCase(repository);
    });

    test('AddToCartUseCase adds new item and GetCartItemsUseCase retrieves it', () async {
      await addToCartUseCase(sampleProduct, selectedFlavor: 'Vanilla', quantity: 2);

      final items = await getCartItemsUseCase();
      expect(items.length, 1);
      expect(items.first.product.id, 'p1');
      expect(items.first.selectedFlavor, 'Vanilla');
      expect(items.first.quantity, 2);
      expect(items.first.subtotal, 2600.0);
    });

    test('AddToCartUseCase increments existing item quantity', () async {
      await addToCartUseCase(sampleProduct, selectedSize: '1kg', quantity: 1);
      await addToCartUseCase(sampleProduct, selectedSize: '1kg', quantity: 2);

      final items = await getCartItemsUseCase();
      expect(items.length, 1);
      expect(items.first.quantity, 3);
    });

    test('UpdateCartQuantityUseCase updates quantity correctly', () async {
      await addToCartUseCase(sampleProduct, quantity: 1);
      final itemsBefore = await getCartItemsUseCase();
      final itemId = itemsBefore.first.id;

      await updateCartQuantityUseCase(itemId, 5);
      final itemsAfter = await getCartItemsUseCase();
      expect(itemsAfter.first.quantity, 5);
      expect(itemsAfter.first.subtotal, 6500.0);
    });

    test('UpdateCartQuantityUseCase with zero quantity removes the item', () async {
      await addToCartUseCase(sampleProduct, quantity: 1);
      final itemId = (await getCartItemsUseCase()).first.id;

      await updateCartQuantityUseCase(itemId, 0);
      final itemsAfter = await getCartItemsUseCase();
      expect(itemsAfter.isEmpty, isTrue);
    });

    test('RemoveFromCartUseCase removes specified item', () async {
      await addToCartUseCase(sampleProduct, selectedFlavor: 'Chocolate');
      final itemId = (await getCartItemsUseCase()).first.id;

      await removeFromCartUseCase(itemId);
      final itemsAfter = await getCartItemsUseCase();
      expect(itemsAfter.isEmpty, isTrue);
    });

    test('ClearCartUseCase clears all items in cart', () async {
      await addToCartUseCase(sampleProduct, selectedFlavor: 'Vanilla');
      await addToCartUseCase(sampleProduct, selectedFlavor: 'Strawberry');
      expect((await getCartItemsUseCase()).length, 2);

      await clearCartUseCase();
      expect((await getCartItemsUseCase()).isEmpty, isTrue);
    });

    test('CartItemEntity subtotal and primaryImageUrl work correctly', () {
      const item = CartItemEntity(
        id: 'c1',
        userId: 'u1',
        product: sampleProduct,
        quantity: 3,
        selectedSize: '2kg',
      );

      expect(item.subtotal, 7800.0); // 2600 * 3
      expect(item.primaryImageUrl, isNull);
    });
  });
}
