import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/services/crash_reporting_service.dart';

void main() {
  group('CrashReportingService Tests', () {
    test('initializes error handlers safely without throw', () {
      expect(() => CrashReportingService.init(), returnsNormally);
    });

    test('recordError executes without throw', () {
      expect(
        () => CrashReportingService.recordError(
          Exception('Test error'),
          StackTrace.current,
          reason: 'Unit test execution',
        ),
        returnsNormally,
      );
    });

    test('log records debug message without throw', () {
      expect(() => CrashReportingService.log('Test debug message'), returnsNormally);
    });
  });
}
