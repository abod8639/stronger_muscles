import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/utils/components/dots_indicator.dart';

void main() {
  group('DotsIndicator Component Tests', () {
    testWidgets('renders correct number of animated containers when itemCount > 1', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DotsIndicator(
              itemCount: 4,
              currentIndex: 1,
            ),
          ),
        ),
      );

      final animatedContainers = find.byType(AnimatedContainer);
      expect(animatedContainers, findsNWidgets(4));
    });

    testWidgets('renders SizedBox.shrink when itemCount is 1 or less', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DotsIndicator(
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
