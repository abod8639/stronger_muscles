import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/components/app_step_progress.dart';

void main() {
  group('AppStepProgress Tests', () {
    testWidgets('renders all steps and highlights active step', (tester) async {
      final steps = ['تم الطلب', 'قيد التجهيز', 'تم الشحن', 'تم التوصيل'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppStepProgress(
              steps: steps,
              activeIndex: 1,
            ),
          ),
        ),
      );

      for (final step in steps) {
        expect(find.text(step), findsOneWidget);
      }
      // Completed step (index 0) has a checkmark icon
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('renders cancelled state properly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppStepProgress(
              steps: ['Step 1', 'Step 2'],
              activeIndex: 0,
              isCancelled: true,
              cancelledLabel: 'الطلب ملغي',
            ),
          ),
        ),
      );

      expect(find.text('الطلب ملغي'), findsOneWidget);
      expect(find.byIcon(Icons.cancel), findsOneWidget);
    });
  });
}
