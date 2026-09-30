import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/utils/components/rating_stars.dart';

void main() {
  group('RatingStars Widget Tests', () {
    testWidgets('renders correct number of full, half, and empty star icons', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RatingStars(rating: 3.5),
          ),
        ),
      );

      // Rating 3.5: 3 full stars, 1 half star, 1 empty star
      expect(find.byIcon(Icons.star_rounded), findsNWidgets(3));
      expect(find.byIcon(Icons.star_half_rounded), findsOneWidget);
      expect(find.byIcon(Icons.star_outline_rounded), findsOneWidget);
    });

    testWidgets('displays rating value and suffix text when requested', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RatingStars(
              rating: 4.8,
              showValue: true,
              suffixText: '(20 reviews)',
            ),
          ),
        ),
      );

      expect(find.text('4.8 (20 reviews)'), findsOneWidget);
    });

    testWidgets('clamps rating between 0.0 and 5.0 gracefully', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RatingStars(rating: 6.0),
          ),
        ),
      );

      expect(find.byIcon(Icons.star_rounded), findsNWidgets(5));
      expect(find.byIcon(Icons.star_half_rounded), findsNothing);
      expect(find.byIcon(Icons.star_outline_rounded), findsNothing);
    });
  });
}
