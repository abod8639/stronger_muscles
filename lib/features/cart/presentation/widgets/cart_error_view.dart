import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// An elegant fallback error widget for the shopping cart view
/// that displays [Failure.toMessage()] with contextual icons and a retry action.
class CartErrorView extends StatelessWidget {
  final dynamic error;
  final VoidCallback onRetry;
  final VoidCallback? onGoShopping;

  const CartErrorView({
    super.key,
    required this.error,
    required this.onRetry,
    this.onGoShopping,
  });

  String get _errorMessage {
    if (error is Failure) {
      return (error as Failure).toMessage();
    }
    return error?.toString() ?? 'حدث خطأ غير متوقع أثناء تحميل السلة';
  }

  IconData get _errorIcon {
    if (error is Failure) {
      final Failure failure = error as Failure;
      switch (failure.type) {
        case FailureType.network:
        case FailureType.timeout:
          return Icons.wifi_off_rounded;
        case FailureType.server:
          return Icons.cloud_off_rounded;
        case FailureType.validation:
          return Icons.remove_shopping_cart_rounded;
        default:
          return Icons.error_outline_rounded;
      }
    }
    return Icons.error_outline_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spacingXl,
          vertical: AppDimens.spacingLg,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _errorIcon,
                size: 42.0,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 24.0),
            Text(
              'تعذر عرض السلة',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.5,
                color: isDark ? AppColors.grey : AppColors.greyDark,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 12.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.allMd,
                    ),
                  ),
                  icon: const Icon(Icons.refresh_rounded, size: 18.0),
                  label: const Text(
                    'إعادة المحاولة',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                if (onGoShopping != null) ...[
                  const SizedBox(width: 12.0),
                  OutlinedButton(
                    onPressed: onGoShopping,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark ? AppColors.white : AppColors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      side: BorderSide(
                        color: isDark ? Colors.white24 : AppColors.greyMedium,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.allMd,
                      ),
                    ),
                    child: const Text('متابعة التسوق'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
