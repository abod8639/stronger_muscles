import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/components/app_highlight_text.dart';

void main() {
  group('AppHighlightText Widget Tests', () {
    testWidgets('renders plain text when query is empty', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppHighlightText(
              text: 'Gold Standard Whey',
              query: '',
            ),
          ),
        ),
      );

      expect(find.text('Gold Standard Whey'), findsOneWidget);
    });

    testWidgets('renders highlighted match correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppHighlightText(
              text: 'Gold Standard Whey',
              query: 'Standard',
            ),
          ),
        ),
      );

      final richTextFinder = find.byType(RichText);
      expect(richTextFinder, findsOneWidget);

      final richText = tester.widget<RichText>(richTextFinder);
      final textSpan = richText.text as TextSpan;
      expect(textSpan.children, isNotNull);
      expect(textSpan.children!.length, 3); // 'Gold ', 'Standard', ' Whey'

      final matchSpan = textSpan.children![1] as TextSpan;
      expect(matchSpan.text, 'Standard');
    });
  });
}
