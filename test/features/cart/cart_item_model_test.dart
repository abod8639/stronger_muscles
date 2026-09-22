import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/cart/data/models/cart_item_model.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/product/data/models/product_size_model.dart';
import 'package:stronger_muscles/features/profile/data/models/localized_string_model.dart';

void main() {
  group('CartItemModel Tests', () {
    const sampleProduct = ProductModel(
      id: 'prod-1',
      name: LocalizedString(en: 'Whey Protein', ar: 'واي بروتين'),
      price: 1200.0,
      discountPrice: 1000.0,
      productSizes: [
        ProductSize(size: '2kg', price: 1000.0, discountPrice: 900.0),
        ProductSize(size: '5kg', price: 2200.0),
      ],
    );

    test('calculates subtotal using base effective price when no size selected', () {
      final cartItem = CartItemModel(
        id: 'cart-1',
        userId: 'user-1',
        product: sampleProduct,
        quantity: 2,
      );

      // sampleProduct base effective price is 1000.0 (discountPrice)
      expect(cartItem.subtotal, 2000.0);
    });

    test('calculates subtotal using size variant price when size selected', () {
      final cartItemWithSize = CartItemModel(
        id: 'cart-2',
        userId: 'user-1',
        product: sampleProduct,
        quantity: 3,
        selectedSize: '2kg',
      );

      // 2kg size has discount price 900.0 * 3 = 2700.0
      expect(cartItemWithSize.subtotal, 2700.0);
    });

    test('updates quantity with copyWith correctly', () {
      final item = CartItemModel(
        id: 'cart-1',
        userId: 'user-1',
        product: sampleProduct,
        quantity: 1,
      );

      final updated = item.copyWith(quantity: item.quantity + 2);
      expect(updated.quantity, 3);
      expect(updated.subtotal, 3000.0);
    });
  });
}
