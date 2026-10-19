import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/components/app_dots_indicator.dart';

void main() {
  group('AppDotsIndicator Component Tests', () {
    testWidgets('renders correct number of indicators when itemCount > 1', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppDotsIndicator(
              itemCount: 4,
              currentIndex: 1,
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedContainer), findsNWidgets(4));
    });

    testWidgets('renders SizedBox.shrink when itemCount is 1 or less', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppDotsIndicator(
              itemCount: 1,
              currentIndex: 0,
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedContainer), findsNothing);
    });
  });
}
