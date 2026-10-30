import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/product/data/models/product_size_model.dart';
import 'package:stronger_muscles/features/product/domain/entities/localized_string_entity.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';
import 'package:stronger_muscles/features/product/domain/entities/review_entity.dart';
import 'package:stronger_muscles/features/product_details/presentation/pages/product_details_view.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/product_detail_sections.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/product_price.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/review_card.dart';
import 'package:stronger_muscles/features/profile/data/models/localized_string_model.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/product_size_selector.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(body: child),
    );
  }

  group('Product Details Widgets Tests', () {
    testWidgets('ProductDescriptionSection renders the titled description card', (tester) async {
      const product = ProductModel(
        id: 'test-0',
        price: 10,
        description: LocalizedString(en: 'Fast absorbing protein.', ar: 'بروتين سريع الامتصاص.'),
      );

      await tester.pumpWidget(createTestWidget(const ProductDescriptionSection(product: product)));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.description_outlined), findsOneWidget);
      expect(find.text('Fast absorbing protein.'), findsWidgets);
    });

    testWidgets('ProductSizeSelector renders sizes and invokes callback on selection', (tester) async {
      String? selected;
      const product = ProductModel(
        id: 'test-1',
        price: 100,
        productSizes: [
          ProductSize(size: '1 kg', price: 100),
          ProductSize(size: '2 kg', price: 190),
        ],
      );

      await tester.pumpWidget(
        createTestWidget(
          ProductSizeSelector(
            product: product,
            initialSize: '1 kg',
            onSizeSelected: (size) => selected = size,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('1 kg'), findsOneWidget);
      expect(find.text('2 kg'), findsOneWidget);

      await tester.tap(find.text('2 kg'));
      await tester.pumpAndSettle();

      expect(selected, '2 kg');
    });

    testWidgets('ProductUsageSection renders usage instructions and warnings', (tester) async {
      const product = ProductModel(
        id: 'test-2',
        price: 50,
        usageInstructions: 'Take 1 scoop with water daily.',
        warnings: ['Keep out of reach of children.', 'Do not exceed dose.'],
      );

      await tester.pumpWidget(
        createTestWidget(
          const ProductUsageSection(product: product),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Take 1 scoop with water daily.'), findsOneWidget);
      expect(find.text('Keep out of reach of children.'), findsOneWidget);
      expect(find.text('Do not exceed dose.'), findsOneWidget);
    });

    testWidgets('ProductIngredientsSection renders ingredient tags', (tester) async {
      const product = ProductModel(
        id: 'test-3',
        price: 80,
        ingredients: ['Whey Protein Isolate', 'Cocoa Powder', 'Stevia'],
      );

      await tester.pumpWidget(
        createTestWidget(
          const ProductIngredientsSection(product: product),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Whey Protein Isolate'), findsOneWidget);
      expect(find.text('Cocoa Powder'), findsOneWidget);
      expect(find.text('Stevia'), findsOneWidget);
    });

    testWidgets('ProductDetailsView accepts ProductEntity directly and fromModel factory', (tester) async {
      const entity = ProductEntity(
        id: 'entity-1',
        name: LocalizedStringEntity(en: 'Pure Whey', ar: 'واي نقي'),
        price: 150.0,
      );

      const viewDirect = ProductDetailsView(product: entity);
      expect(viewDirect.product, entity);

      const model = ProductModel(
        id: 'model-1',
        price: 150.0,
      );
      final viewModel = ProductDetailsView.fromModel(model: model);
      expect(viewModel.product?.id, 'model-1');
    });

    testWidgets('ProductPrice shows discount or price on request', (tester) async {
      await tester.pumpWidget(createTestWidget(const ProductPrice(price: 90, originalPrice: 120)));
      expect(find.text('LE 90.00'), findsOneWidget);
      expect(find.text('LE 120.00'), findsOneWidget);

      await tester.pumpWidget(createTestWidget(const ProductPrice(price: 0)));
      await tester.pumpAndSettle();
      expect(find.text('LE 0.00'), findsNothing);
    });

    testWidgets('ReviewCard shows name initial, rating and comment', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          ReviewCard(
            review: ReviewEntity(
              id: 'r1',
              productId: 'p1',
              userId: 'u1',
              userName: 'sara',
              comment: 'Great taste',
              rating: 4,
              createdAt: DateTime(2026, 10, 1),
            ),
          ),
        ),
      );

      expect(find.text('S'), findsOneWidget);
      expect(find.text('4.0'), findsOneWidget);
      expect(find.text('Great taste'), findsOneWidget);
    });

    testWidgets('ProductInfoSection lists specs with a brand link', (tester) async {
      const product = ProductModel(id: 'test-4', price: 10, brand: 'Optimum', sku: 'SKU-1');

      await tester.pumpWidget(
        ProviderScope(child: createTestWidget(const ProductInfoSection(product: product))),
      );

      expect(find.widgetWithText(TextButton, 'Optimum'), findsOneWidget);
      expect(find.text('SKU-1'), findsOneWidget);
    });
  });
}
