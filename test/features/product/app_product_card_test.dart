import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/product/presentation/widgets/app_product_card.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/profile/data/models/localized_string_model.dart';

void main() {
  group('AppProductCard Widget Tests', () {
    const testProduct = ProductModel(
      id: 'prod-1',
      name: LocalizedString(en: 'Whey Isolate', ar: 'واي ايزوليت'),
      description: LocalizedString(en: 'Pure protein powder', ar: 'مسحوق بروتين نقي'),
      price: 250.0,
      discountPrice: 200.0,
      stockQuantity: 10,
      averageRating: 4.5,
      reviewCount: 12,
    );

    testWidgets('renders product name, price, discount and rating', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SizedBox(
                height: 350,
                width: 200,
                child: AppProductCard(
                  product: testProduct,
                  showName: true,
                ),
              ),
            ),
          ),
        ),
      );

      // Verify name and pricing
      expect(find.text('Whey Isolate'), findsOneWidget);
      expect(find.text('LE 200.00'), findsOneWidget);
      expect(find.text('LE 250.00'), findsOneWidget);
      expect(find.text('4.5'), findsOneWidget);
      expect(find.text(' (12)'), findsOneWidget);
    });

    testWidgets('instantiates from entity via factory constructor', (tester) async {
      final entity = testProduct.toEntity();

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SizedBox(
                height: 350,
                width: 200,
                child: AppProductCard.fromEntity(
                  entity: entity,
                  showName: true,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Whey Isolate'), findsOneWidget);
      expect(find.text('LE 200.00'), findsOneWidget);
    });

    testWidgets('whole card is tappable, including the details area', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SizedBox(
                height: 350,
                width: 200,
                child: AppProductCard(product: testProduct, onTap: () => taps++),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Whey Isolate'));
      expect(taps, 1);
    });

    testWidgets('out-of-stock product shows the badge and no struck price', (tester) async {
      const outOfStock = ProductModel(
        id: 'prod-2',
        name: LocalizedString(en: 'Creatine', ar: 'كرياتين'),
        price: 250.0,
        discountPrice: 200.0,
      );

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SizedBox(
                height: 350,
                width: 200,
                child: AppProductCard(product: outOfStock),
              ),
            ),
          ),
        ),
      );

      // Overlay pill on the image + badge in the details row.
      expect(find.text('نفدت الكمية'), findsNWidgets(2));
      expect(find.text('LE 250.00'), findsNothing);
    });
  });
}
