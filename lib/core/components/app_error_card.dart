import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/app_alert_card.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Inline error card that renders any error (preferably a [Failure]) with a
/// type-aware icon, an optional retry action, and an optional dismiss button.
class AppErrorCard extends StatelessWidget {
  final Object? error;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;
  final bool isRetrying;
  final EdgeInsetsGeometry? margin;

  const AppErrorCard({
    super.key,
    required this.error,
    this.onRetry,
    this.onDismiss,
    this.isRetrying = false,
    this.margin,
  });

  static IconData iconFor(Object? error) {
    if (error is! Failure) return Icons.error_outline_rounded;
    return switch (error.type) {
      FailureType.network || FailureType.timeout => Icons.wifi_off_rounded,
      FailureType.auth => Icons.lock_outline_rounded,
      FailureType.validation => Icons.rule_rounded,
      FailureType.server => Icons.cloud_off_rounded,
      FailureType.cancel => Icons.cancel_outlined,
      _ => Icons.error_outline_rounded,
    };
  }

  static String messageFor(Object? error, AppLocalizations? l10n) {
    if (error is Failure) return error.toMessage();
    return error?.toString() ?? l10n?.error ?? 'Error';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppAlertCard(
      color: AppColors.error,
      icon: iconFor(error),
      message: messageFor(error, l10n),
      margin: margin,
      onDismiss: onDismiss,
      onAction: onRetry,
      actionLabel: l10n?.retry ?? 'Retry',
      isActionLoading: isRetrying,
    );
  }
}
