import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/product/data/models/product_size_model.dart';
import 'package:stronger_muscles/features/product/domain/entities/localized_string_entity.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';
import 'package:stronger_muscles/features/product_details/presentation/pages/product_details_view.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/build_ingredients_section.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/build_usage_and_warnings.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/header_with_icon_and_title.dart';
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
    testWidgets('HeaderWithIconandTitle renders correctly with theme styling', (tester) async {
      await tester.pumpWidget(createTestWidget(const HeaderWithIconandTitle()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.description_outlined), findsOneWidget);
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

    testWidgets('buildUsageAndWarnings renders usage instructions and warnings', (tester) async {
      const product = ProductModel(
        id: 'test-2',
        price: 50,
        usageInstructions: 'Take 1 scoop with water daily.',
        warnings: ['Keep out of reach of children.', 'Do not exceed dose.'],
      );

      await tester.pumpWidget(
        createTestWidget(
          Builder(builder: (context) => buildUsageAndWarnings(product, false)),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Take 1 scoop with water daily.'), findsOneWidget);
      expect(find.text('Keep out of reach of children.'), findsOneWidget);
      expect(find.text('Do not exceed dose.'), findsOneWidget);
    });

    testWidgets('buildIngredientsSection renders ingredients chips', (tester) async {
      const product = ProductModel(
        id: 'test-3',
        price: 80,
        ingredients: ['Whey Protein Isolate', 'Cocoa Powder', 'Stevia'],
      );

      await tester.pumpWidget(
        createTestWidget(
          Builder(builder: (context) => buildIngredientsSection(product, false)),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Whey Protein Isolate'), findsOneWidget);
      expect(find.text('Cocoa Powder'), findsOneWidget);
      expect(find.text('Stevia'), findsOneWidget);
    });

    testWidgets('ProductDetailsView.fromEntity initializes from pure ProductEntity', (tester) async {
      const entity = ProductEntity(
        id: 'entity-1',
        name: LocalizedStringEntity(en: 'Pure Whey', ar: 'واي نقي'),
        price: 150.0,
      );

      const view = ProductDetailsView.fromEntity(productEntity: entity);
      expect(view.productEntity, entity);
      expect(view.product, isNull);
    });
  });
}
