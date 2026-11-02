import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/components/app_flavor_image.dart';
import 'package:stronger_muscles/features/cart/domain/entities/cart_item_entity.dart';
import 'package:stronger_muscles/features/cart/presentation/widgets/cart_item_details.dart';
import 'package:stronger_muscles/features/product/domain/entities/localized_string_entity.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('CartItemDetails renders flavor without throwing when selectedFlavorImage is null', (tester) async {
    const product = ProductEntity(
      id: 'p1',
      name: LocalizedStringEntity(ar: 'واي بروتين', en: 'Whey Protein'),
      brand: 'Optimum',
      price: 50.0,
      flavors: ['Chocolate', 'Vanilla'],
    );

    const item = CartItemEntity(
      id: 'c1',
      userId: 'u1',
      product: product,
      selectedFlavor: 'Chocolate',
      selectedSize: '2kg',
      selectedFlavorImage: null, // intentionally null
    );

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [Locale('en'), Locale('ar')],
        home: Scaffold(
          body: CartItemDetails(item: item),
        ),
      ),
    );

    await tester.pump();

    // Verify product name and brand rendered
    expect(find.text('OPTIMUM'), findsOneWidget);
    expect(find.text('Whey Protein'), findsOneWidget);
    expect(find.byType(FlavorImage), findsOneWidget);
    expect(find.text('CHOCOLATE'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

