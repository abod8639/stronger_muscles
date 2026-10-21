import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/home_controller.dart';
import 'package:stronger_muscles/features/product/domain/entities/localized_string_entity.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';
import 'package:stronger_muscles/features/search/presentation/controllers/product_search_controller.dart';
import 'package:stronger_muscles/features/search/presentation/controllers/search_history_controller.dart';
import 'package:stronger_muscles/features/search/presentation/pages/search_page.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class _FakeProductSearchController extends ProductSearchController {
  final List<ProductEntity> initialProducts;
  final bool initialHasSearched;

  _FakeProductSearchController(
    this.initialProducts, {
    this.initialHasSearched = false,
  });

  @override
  bool get hasSearched => initialHasSearched;

  @override
  Future<List<ProductEntity>> build() async {
    return initialProducts;
  }
}

class _FakeSearchHistory extends SearchHistory {
  @override
  List<String> build() => [];
}

class _FakeHomeController extends HomeController {
  @override
  Future<List<ProductEntity>> build() async => [];
}

void main() {
  group('SearchPage Widget Tests', () {
    const sampleProduct = ProductEntity(
      id: 'p1',
      name: LocalizedStringEntity(en: 'Optimum Gold Whey'),
      price: 1200.0,
      brand: 'Optimum Nutrition',
    );

    testWidgets(
        'renders search grid with AppProductCard when products available',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            productSearchControllerProvider.overrideWith(
              () => _FakeProductSearchController([sampleProduct]),
            ),
            searchHistoryProvider.overrideWith(
              () => _FakeSearchHistory(),
            ),
            homeControllerProvider.overrideWith(
              () => _FakeHomeController(),
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

    testWidgets('renders AppEmptyState when search has no results',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            productSearchControllerProvider.overrideWith(
              () => _FakeProductSearchController([], initialHasSearched: true),
            ),
            searchHistoryProvider.overrideWith(
              () => _FakeSearchHistory(),
            ),
            homeControllerProvider.overrideWith(
              () => _FakeHomeController(),
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

      expect(find.byType(AppEmptyState), findsOneWidget);
    });
  });
}
