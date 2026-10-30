import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/app_alert_card.dart';
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
    final isAr = context.isArabic;

    return AppAlertCard(
      color: AppColors.success,
      icon: icon,
      padding: padding,
      borderRadius: borderRadius,
      title: title ??
          (isAr
              ? 'مدفوعات آمنة ومشفرة بنسبة 100%'
              : '100% Secure & Encrypted Payments'),
      message: subtitle ??
          (isAr
              ? 'بياناتك المالية محمية بتقنية التشفير البنكي المعتمد (256-bit SSL)'
              : 'Your financial data is protected with 256-bit SSL encryption'),
    );
  }
}
