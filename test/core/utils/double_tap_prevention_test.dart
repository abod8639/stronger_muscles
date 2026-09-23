import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/utils/functions/double_tap_prevention.dart';

void main() {
  group('DoubleTapPrevention Tests', () {
    test('prevents rapid consecutive executions within debounce window', () {
      int executionCount = 0;

      // First tap executes
      doubleTapPrevention(() {
        executionCount++;
      });
      expect(executionCount, 1);

      // Immediate second tap is blocked
      doubleTapPrevention(() {
        executionCount++;
      });
      expect(executionCount, 1);

      // Immediate third tap is blocked
      doubleTapPrevention(() {
        executionCount++;
      });
      expect(executionCount, 1);
    });

    test('allows tap after debounce duration passes', () async {
      int count = 0;

      doubleTapPrevention(() {
        count++;
      });

      // Wait longer than 500ms debounce
      await Future.delayed(const Duration(milliseconds: 550));

      doubleTapPrevention(() {
        count++;
      });

      expect(count, 2);
    });
  });
}
