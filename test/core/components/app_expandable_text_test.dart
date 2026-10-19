import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/components/app_expandable_text.dart';

void main() {
  group('AppExpandableText Tests', () {
    testWidgets('renders short text correctly without toggle button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppExpandableText(
              text: 'Short description',
              maxLines: 4,
            ),
          ),
        ),
      );

      expect(find.text('Short description'), findsWidgets);
      expect(find.text('Read more'), findsNothing);
      expect(find.text('Read less'), findsNothing);
    });

    testWidgets('shows toggle button for long text and toggles expansion', (tester) async {
      final longText = 'This is a very long text designed to exceed the maximum character and line count ' * 5;
      bool? toggledState;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              child: AppExpandableText(
                text: longText,
                maxLines: 2,
                expandText: 'Show more',
                collapseText: 'Show less',
                onToggle: (expanded) => toggledState = expanded,
              ),
            ),
          ),
        ),
      );

      // Verify toggle button is visible
      expect(find.text('Show more'), findsOneWidget);

      // Tap to expand
      await tester.tap(find.text('Show more'));
      await tester.pumpAndSettle();

      expect(toggledState, isTrue);
      expect(find.text('Show less'), findsOneWidget);

      // Tap to collapse
      await tester.tap(find.text('Show less'));
      await tester.pumpAndSettle();

      expect(toggledState, isFalse);
      expect(find.text('Show more'), findsOneWidget);
    });

    testWidgets('respects initiallyExpanded property', (tester) async {
      final longText = 'A long description text that spans multiple lines ' * 8;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              child: AppExpandableText(
                text: longText,
                maxLines: 2,
                initiallyExpanded: true,
                expandText: 'Show more',
                collapseText: 'Show less',
              ),
            ),
          ),
        ),
      );

      expect(find.text('Show less'), findsOneWidget);
    });
  });
}
