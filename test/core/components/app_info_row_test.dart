import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/components/app_info_row.dart';

void main() {
  group('AppInfoRow and AppPriceRow Tests', () {
    testWidgets('AppInfoRow renders label and value with optional icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppInfoRow(
              icon: Icons.receipt,
              label: 'رقم الطلب',
              value: '#12345',
            ),
          ),
        ),
      );

      expect(find.text('رقم الطلب'), findsOneWidget);
      expect(find.text('#12345'), findsOneWidget);
      expect(find.byIcon(Icons.receipt), findsOneWidget);
    });

    testWidgets('AppPriceRow renders amount, label, and formatted currency', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppPriceRow(
              label: 'الإجمالي',
              amount: 250.0,
              currency: 'EGP',
              isTotal: true,
            ),
          ),
        ),
      );

      expect(find.text('الإجمالي'), findsOneWidget);
      expect(find.text('250.00 EGP'), findsOneWidget);
    });

    testWidgets('AppPriceRow renders discount with prefix minus', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppPriceRow(
              label: 'الخصم',
              amount: 50.0,
              currency: 'EGP',
              isDiscount: true,
            ),
          ),
        ),
      );

      expect(find.text('الخصم'), findsOneWidget);
      expect(find.text('- 50.00 EGP'), findsOneWidget);
    });
  });
}
