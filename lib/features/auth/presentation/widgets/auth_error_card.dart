import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// An elegant, theme-aware error card component for authentication screens
/// that displays [Failure.toMessage()] with contextual icons and a retry action.
class AuthErrorCard extends StatelessWidget {
  final dynamic error;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;
  final bool isRetrying;

  const AuthErrorCard({
    super.key,
    required this.error,
    this.onRetry,
    this.onDismiss,
    this.isRetrying = false,
  });

  String get _errorMessage {
    if (error is Failure) {
      return (error as Failure).toMessage();
    }
    return error?.toString() ?? 'حدث خطأ غير متوقع';
  }

  IconData get _errorIcon {
    if (error is Failure) {
      final Failure failure = error as Failure;
      switch (failure.type) {
        case FailureType.network:
        case FailureType.timeout:
          return Icons.wifi_off_rounded;
        case FailureType.auth:
          return Icons.lock_outline_rounded;
        case FailureType.validation:
          return Icons.rule_rounded;
        case FailureType.server:
          return Icons.cloud_off_rounded;
        case FailureType.cancel:
          return Icons.cancel_outlined;
        default:
          return Icons.error_outline_rounded;
      }
    }
    return Icons.error_outline_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.error.withValues(alpha: 0.15)
            : AppColors.error.withValues(alpha: 0.08),
        borderRadius: AppRadius.allMd,
        border: Border.all(
          color: AppColors.error.withValues(alpha: isDark ? 0.35 : 0.25),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _errorIcon,
                  color: AppColors.error,
                  size: 20.0,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _errorMessage,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.white : AppColors.black,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              if (onDismiss != null)
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18.0),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: isDark ? AppColors.grey : AppColors.greyDark,
                  onPressed: onDismiss,
                ),
            ],
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 10.0),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton.icon(
                onPressed: isRetrying ? null : onRetry,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.error,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: isRetrying
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(AppColors.error),
                        ),
                      )
                    : const Icon(Icons.refresh_rounded, size: 16.0),
                label: const Text(
                  'إعادة المحاولة',
                  style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
