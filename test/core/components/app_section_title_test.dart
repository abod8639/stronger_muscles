import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/components/app_section_title.dart';

void main() {
  group('AppSectionTitle Widget Tests', () {
    testWidgets('renders title text and leading widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppSectionTitle(
              title: 'Featured Products',
              leading: Icon(Icons.star),
            ),
          ),
        ),
      );

      expect(find.text('Featured Products'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('renders action text and triggers callback', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppSectionTitle(
              title: 'Categories',
              actionText: 'See All',
              onActionTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('See All'), findsOneWidget);
      await tester.tap(find.text('See All'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('renders custom action widget when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppSectionTitle(
              title: 'Deals',
              actionWidget: Chip(label: Text('Hot')),
            ),
          ),
        ),
      );

      expect(find.text('Deals'), findsOneWidget);
      expect(find.text('Hot'), findsOneWidget);
    });
  });
}
