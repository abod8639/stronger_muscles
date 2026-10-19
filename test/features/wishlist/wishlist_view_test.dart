import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/components/app_card.dart';
import 'package:stronger_muscles/core/components/app_empty_state.dart';
import 'package:stronger_muscles/features/product/domain/entities/localized_string_entity.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';
import 'package:stronger_muscles/features/wishlist/presentation/controllers/wishlist_controller.dart';
import 'package:stronger_muscles/features/wishlist/presentation/pages/wishlist_view.dart';
import 'package:stronger_muscles/features/wishlist/presentation/widgets/wishlist_item_card.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class _FakeWishlistController extends WishlistController {
  final List<ProductEntity> initialItems;

  _FakeWishlistController(this.initialItems);

  @override
  List<ProductEntity> build() => initialItems;
}

void main() {
  group('WishlistView Widget Tests', () {
    const testProduct = ProductEntity(
      id: 'prod-w1',
      name: LocalizedStringEntity(en: 'Whey Isolate', ar: 'واي بروتين'),
      price: 1500.0,
      stockQuantity: 5,
    );

    testWidgets('displays AppEmptyState when wishlist is empty', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            wishlistControllerProvider.overrideWith(
              () => _FakeWishlistController([]),
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: WishlistView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AppEmptyState), findsOneWidget);
      expect(find.byType(WishlistItemCard), findsNothing);
      expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
    });

    testWidgets('displays WishlistItemCard and AppCard when items exist',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            wishlistControllerProvider.overrideWith(
              () => _FakeWishlistController([testProduct]),
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: WishlistView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AppEmptyState), findsNothing);
      expect(find.byType(WishlistItemCard), findsOneWidget);
      expect(find.byType(AppCard), findsOneWidget);
      expect(find.text('Whey Isolate'), findsOneWidget);
    });
  });
}
