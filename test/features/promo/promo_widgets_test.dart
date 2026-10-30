import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/promo/domain/entities/promo_entity.dart';
import 'package:stronger_muscles/features/promo/presentation/controllers/promo_controller.dart';
import 'package:stronger_muscles/features/promo/presentation/widgets/promo_banner.dart';
import 'package:stronger_muscles/features/promo/presentation/widgets/promo_card.dart';

void main() {
  group('PromoCard Widget Tests', () {
    const testPromo = PromoEntity(
      id: 1,
      title: 'خصم خاص',
      subtitle: 'احصل على خصم 20% الآن',
      imageUrl: 'https://example.com/banner.jpg',
      buttonText: 'تسوق الآن',
      hexBackgroundColor: '#FF0000',
      targetType: 'product',
      targetId: 'prod_123',
    );

    testWidgets('renders title, subtitle, and AppBadge button',
        (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PromoCard(
              promo: testPromo,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('خصم خاص'), findsOneWidget);
      expect(find.text('احصل على خصم 20% الآن'), findsOneWidget);
      expect(find.text('تسوق الآن'), findsOneWidget);
      expect(find.byType(AppBadge), findsOneWidget);

      await tester.tap(find.byType(PromoCard));
      expect(tapped, isTrue);
    });

    testWidgets('does not render button when targetId is null', (tester) async {
      const promoNoTarget = PromoEntity(
        id: 2,
        title: 'عرض بدون هدف',
        imageUrl: 'https://example.com/banner.jpg',
        targetId: null,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PromoCard(
              promo: promoNoTarget,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(AppBadge), findsNothing);
    });

    testWidgets('uses AppRadius.allLg and AppShadows for container styling',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: PromoCard(
              promo: testPromo,
              onTap: () {},
            ),
          ),
        ),
      );

      final containerFinder = find.descendant(
        of: find.byType(PromoCard),
        matching: find.byType(Container),
      );
      final container = tester.widget<Container>(containerFinder.first);
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.borderRadius, equals(AppRadius.allLg));
      expect(decoration.boxShadow, isNotNull);
    });
  });

  group('PromoBanner Widget Tests', () {
    testWidgets('renders empty shrink box when promos list is empty',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            promosProvider.overrideWith((ref) => Future.value([])),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: PromoBanner(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(PageView), findsNothing);
      expect(find.byType(AppDotsIndicator), findsNothing);
    });

    testWidgets('renders PageView and AppDotsIndicator when promos exist',
        (tester) async {
      final samplePromos = [
        const PromoEntity(
          id: 1,
          title: 'العرض الأول',
          imageUrl: 'https://example.com/1.jpg',
        ),
        const PromoEntity(
          id: 2,
          title: 'العرض الثاني',
          imageUrl: 'https://example.com/2.jpg',
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            promosProvider.overrideWith((ref) => Future.value(samplePromos)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: PromoBanner(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(PageView), findsOneWidget);
      expect(find.byType(AppDotsIndicator), findsOneWidget);
      expect(find.byType(PromoCard), findsWidgets);
    });

    testWidgets('renders shimmer placeholder when promos are loading',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            promosProvider.overrideWith(
                (ref) => Completer<List<PromoEntity>>().future),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: PromoBanner(),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(AppShimmer), findsOneWidget);
      expect(find.byType(PageView), findsNothing);
    });
  });
}
