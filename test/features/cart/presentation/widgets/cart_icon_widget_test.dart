import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/cart/domain/entities/cart_item_entity.dart';
import 'package:stronger_muscles/features/cart/presentation/controllers/cart_controller.dart';
import 'package:stronger_muscles/features/cart/presentation/widgets/cart_icon.dart';
import 'package:stronger_muscles/features/product/domain/entities/localized_string_entity.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';

class FakeCartController extends CartController {
  final List<CartItemEntity> _mockItems;

  FakeCartController(this._mockItems);

  @override
  FutureOr<List<CartItemEntity>> build() {
    return _mockItems;
  }
}

void main() {
  Widget buildTestApp(List<CartItemEntity> items) {
    return ProviderScope(
      overrides: [
        cartControllerProvider.overrideWith(() => FakeCartController(items)),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: CartIcon(),
        ),
      ),
    );
  }

  group('CartIcon Widget Tests', () {
    testWidgets('renders shopping cart icon always', (tester) async {
      await tester.pumpWidget(buildTestApp([]));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
    });

    testWidgets('hides badge label when cart is empty', (tester) async {
      await tester.pumpWidget(buildTestApp([]));
      await tester.pumpAndSettle();

      final badge = tester.widget<Badge>(find.byType(Badge));
      expect(badge.isLabelVisible, isFalse);
    });

    testWidgets('shows badge with item count when cart contains items', (tester) async {
      const sampleProduct = ProductEntity(
        id: 'p1',
        name: LocalizedStringEntity(en: 'Whey'),
        price: 100.0,
      );

      final items = [
        const CartItemEntity(
          id: 'c1',
          userId: 'u1',
          product: sampleProduct,
          quantity: 2,
        ),
        const CartItemEntity(
          id: 'c2',
          userId: 'u1',
          product: sampleProduct,
          quantity: 1,
        ),
      ];

      await tester.pumpWidget(buildTestApp(items));
      await tester.pumpAndSettle();

      final badge = tester.widget<Badge>(find.byType(Badge));
      expect(badge.isLabelVisible, isTrue);
      expect(find.text('2'), findsOneWidget);
    });
  });
}
