import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/features/product/domain/entities/localized_string_entity.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';
import 'package:stronger_muscles/features/search/presentation/controllers/product_search_controller.dart';
import 'package:stronger_muscles/features/search/presentation/pages/search_page.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

void main() {
  group('SearchPage Widget Tests', () {
    const sampleProduct = ProductEntity(
      id: 'p1',
      name: LocalizedStringEntity(en: 'Optimum Gold Whey'),
      price: 1200.0,
      brand: 'Optimum Nutrition',
    );

    testWidgets('renders search grid with AppProductCard when products available',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            productSearchControllerProvider.overrideWith(
              () => _FakeProductSearchController([sampleProduct]),
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: SearchPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(SearchPage), findsOneWidget);
      expect(find.byType(AppProductCard), findsOneWidget);
      expect(find.byType(AppEmptyState), findsNothing);
    });
  });
}

class _FakeProductSearchController extends ProductSearchController {
  final List<ProductEntity> initialProducts;

  _FakeProductSearchController(this.initialProducts);

  @override
  Future<List<ProductEntity>> build() async {
    return initialProducts;
  }
}
