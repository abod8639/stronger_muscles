import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/utils/responsive_helper.dart';

void main() {
  Widget buildTestWidget({
    required Size size,
    required Widget Function(BuildContext) builder,
  }) {
    return MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: size),
        child: Builder(builder: builder),
      ),
    );
  }

  group('ResponsiveHelper Tests', () {
    testWidgets('identifies mobile screens correctly', (tester) async {
      late BuildContext testContext;

      await tester.pumpWidget(
        buildTestWidget(
          size: const Size(400, 800),
          builder: (context) {
            testContext = context;
            return const Placeholder();
          },
        ),
      );

      expect(ResponsiveHelper.isMobile(testContext), isTrue);
      expect(ResponsiveHelper.isTablet(testContext), isFalse);
      expect(ResponsiveHelper.isDesktop(testContext), isFalse);
      expect(ResponsiveHelper.getGridCrossAxisCount(testContext), 2);
      expect(ResponsiveHelper.getGridChildAspectRatio(testContext), 0.65);
    });

    testWidgets('identifies tablet screens correctly', (tester) async {
      late BuildContext testContext;

      await tester.pumpWidget(
        buildTestWidget(
          size: const Size(800, 1024),
          builder: (context) {
            testContext = context;
            return const Placeholder();
          },
        ),
      );

      expect(ResponsiveHelper.isMobile(testContext), isFalse);
      expect(ResponsiveHelper.isTablet(testContext), isTrue);
      expect(ResponsiveHelper.isDesktop(testContext), isFalse);
      expect(ResponsiveHelper.getGridCrossAxisCount(testContext), 3);
      expect(ResponsiveHelper.getGridChildAspectRatio(testContext), 0.7);
    });

    testWidgets('identifies desktop screens correctly', (tester) async {
      late BuildContext testContext;

      await tester.pumpWidget(
        buildTestWidget(
          size: const Size(1400, 900),
          builder: (context) {
            testContext = context;
            return const Placeholder();
          },
        ),
      );

      expect(ResponsiveHelper.isMobile(testContext), isFalse);
      expect(ResponsiveHelper.isTablet(testContext), isFalse);
      expect(ResponsiveHelper.isDesktop(testContext), isTrue);
      expect(ResponsiveHelper.getGridCrossAxisCount(testContext), 4);
      expect(ResponsiveHelper.getGridChildAspectRatio(testContext), 0.75);
    });
  });
}
