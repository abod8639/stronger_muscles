import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/components/app_selectable_card.dart';

void main() {
  group('AppSelectableCard Component Tests', () {
    testWidgets('renders title, subtitle, and radio', (tester) async {
      String? selectedVal = 'opt1';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AppSelectableCard<String>(
                  value: 'opt1',
                  groupValue: selectedVal,
                  onChanged: (val) => setState(() => selectedVal = val),
                  title: 'Option 1',
                  subtitle: 'First option description',
                  leadingIcon: Icons.payment,
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('First option description'), findsOneWidget);
      expect(find.byIcon(Icons.payment), findsOneWidget);
      expect(find.byType(Radio<String>), findsOneWidget);
    });

    testWidgets('triggers onChanged when tapped', (tester) async {
      String? selectedVal = 'opt1';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AppSelectableCard<String>(
                  value: 'opt2',
                  groupValue: selectedVal,
                  onChanged: (val) => setState(() => selectedVal = val),
                  title: 'Option 2',
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Option 2'));
      await tester.pumpAndSettle();

      expect(selectedVal, 'opt2');
    });
  });
}
