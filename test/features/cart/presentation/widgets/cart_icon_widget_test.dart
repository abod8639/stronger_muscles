import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/cart/data/models/cart_item_model.dart';
import 'package:stronger_muscles/features/cart/presentation/controllers/cart_controller.dart';
import 'package:stronger_muscles/features/cart/presentation/widgets/cart_icon.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/profile/data/models/localized_string_model.dart';

class FakeCartController extends CartController {
  final List<CartItemModel> _mockItems;

  FakeCartController(this._mockItems);

  @override
  FutureOr<List<CartItemModel>> build() {
    return _mockItems;
  }
}

void main() {
  Widget buildTestApp(List<CartItemModel> items) {
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
      const sampleProduct = ProductModel(
        id: 'p1',
        name: LocalizedString(en: 'Whey'),
        price: 100.0,
      );

      final items = [
        CartItemModel(
          id: 'c1',
          userId: 'u1',
          product: sampleProduct,
          quantity: 2,
        ),
        CartItemModel(
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
