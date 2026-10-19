import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/components/app_bottom_sheet_handle.dart';
import 'package:stronger_muscles/core/theme/app_radius.dart';

void main() {
  group('AppBottomSheetHandle Widget Tests', () {
    testWidgets('renders handle with default dimensions and AppRadius.allPill', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppBottomSheetHandle(),
          ),
        ),
      );

      final containerFinder = find.byType(Container);
      expect(containerFinder, findsOneWidget);

      final container = tester.widget<Container>(containerFinder);
      expect(container.constraints?.maxWidth ?? 40.0, equals(40.0));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, equals(AppRadius.allPill));
    });

    testWidgets('respects custom width, height, and color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppBottomSheetHandle(
              width: 60.0,
              height: 6.0,
              color: Colors.red,
            ),
          ),
        ),
      );

      final containerFinder = find.byType(Container);
      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.color, equals(Colors.red));
      expect(decoration.borderRadius, equals(AppRadius.allPill));
    });
  });
}
