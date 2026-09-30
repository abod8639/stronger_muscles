import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/utils/components/app_badge.dart';

void main() {
  group('AppBadge Widget Tests', () {
    testWidgets('renders badge with label and color correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppBadge(
              label: 'Sale',
              color: Colors.red,
            ),
          ),
        ),
      );

      expect(find.text('Sale'), findsOneWidget);
      expect(find.byType(AppBadge), findsOneWidget);
    });

    testWidgets('renders badge with icon when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppBadge(
              label: 'Verified',
              icon: Icons.check,
              color: Colors.green,
            ),
          ),
        ),
      );

      expect(find.text('Verified'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });
}
