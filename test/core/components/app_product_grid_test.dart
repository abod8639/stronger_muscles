import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/components/app_product_grid.dart';
import 'package:stronger_muscles/features/product/domain/entities/localized_string_entity.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';

List<ProductEntity> _products(int count) => [
      for (var i = 0; i < count; i++)
        ProductEntity(
          id: 'p$i',
          name: LocalizedStringEntity(en: 'Product $i'),
          price: 100.0 + i,
          stockQuantity: 5,
        ),
    ];

Widget _wrap(Widget sliver) => MaterialApp(
      home: Scaffold(body: CustomScrollView(slivers: [sliver])),
    );

void main() {
  testWidgets('renders cards and reports taps', (tester) async {
    ProductEntity? tapped;
    await tester.pumpWidget(
      _wrap(AppProductGrid(products: _products(2), onProductTap: (p) => tapped = p)),
    );

    expect(find.text('Product 0'), findsOneWidget);
    await tester.tap(find.text('Product 1'));
    expect(tapped?.id, 'p1');
  });

  testWidgets('calls onNearEnd once when the trigger card is built', (tester) async {
    var calls = 0;
    await tester.pumpWidget(
      _wrap(
        AppProductGrid(
          products: _products(3),
          onProductTap: (_) {},
          onNearEnd: () => calls++,
        ),
      ),
    );
    await tester.pump();

    expect(calls, 1);
  });

  testWidgets('shows a spinner footer while loading more', (tester) async {
    await tester.pumpWidget(
      _wrap(AppProductGrid(products: _products(1), onProductTap: (_) {}, isLoadingMore: true)),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
