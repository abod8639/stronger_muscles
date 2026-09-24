import 'dart:ui';
import 'package:flutter/foundation.dart';

class CrashReportingService {
  static void init() {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      recordError(
        details.exception,
        details.stack,
        reason: details.context?.toString(),
      );
    };

    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      recordError(error, stack, fatal: true);
      return true;
    };
  }

  static void recordError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) {
    if (kDebugMode) {
      debugPrint('[CrashReporting] Error: $error');
      if (reason != null) debugPrint('[CrashReporting] Reason: $reason');
      if (stackTrace != null) debugPrint(stackTrace.toString());
    }
  }

  static void log(String message) {
    if (kDebugMode) {
      debugPrint('[CrashReporting] $message');
    }
  }
}
