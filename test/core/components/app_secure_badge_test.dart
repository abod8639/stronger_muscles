import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/components/app_secure_badge.dart';

void main() {
  group('AppSecureBadge Tests', () {
    testWidgets('renders security title and subtitle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppSecureBadge(
              title: 'دفع مشفر 100%',
              subtitle: 'معتمد دولياً',
            ),
          ),
        ),
      );

      expect(find.text('دفع مشفر 100%'), findsOneWidget);
      expect(find.text('معتمد دولياً'), findsOneWidget);
      expect(find.byIcon(Icons.verified_user_outlined), findsOneWidget);
    });

    testWidgets('renders default localized text when title and subtitle are omitted', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          locale: Locale('ar'),
          home: Scaffold(
            body: AppSecureBadge(),
          ),
        ),
      );

      expect(find.text('مدفوعات آمنة ومشفرة بنسبة 100%'), findsOneWidget);
    });
  });
}
