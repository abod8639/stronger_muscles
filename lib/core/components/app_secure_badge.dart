import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// Reusable trust & security indicator badge for checkout, payment,
/// and authentication screens.
class AppSecureBadge extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final IconData icon;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry? borderRadius;

  const AppSecureBadge({
    super.key,
    this.title,
    this.subtitle,
    this.icon = Icons.verified_user_outlined,
    this.padding = const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = context.isDark;
    final isAr = context.isArabic;

    final effectiveTitle = title ??
        (isAr
            ? 'مدفوعات آمنة ومشفرة بنسبة 100%'
            : '100% Secure & Encrypted Payments');

    final effectiveSubtitle = subtitle ??
        (isAr
            ? 'بياناتك المالية محمية بتقنية التشفير البنكي المعتمد (256-bit SSL)'
            : 'Your financial data is protected with 256-bit SSL encryption');

    final effectiveRadius = borderRadius ?? AppRadius.allMd;

    final bg = isDark
        ? AppColors.success.withValues(alpha: 0.1)
        : AppColors.success.withValues(alpha: 0.06);

    final border = isDark
        ? AppColors.success.withValues(alpha: 0.25)
        : AppColors.success.withValues(alpha: 0.2);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: effectiveRadius,
        border: Border.all(color: border, width: 1.0),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20.0,
              color: AppColors.success,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  effectiveTitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  effectiveSubtitle,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
