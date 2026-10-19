import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Reusable two-column key-value row for displaying metadata, orders,
/// address attributes, and specifications.
class AppInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? valueWidget;
  final IconData? icon;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final EdgeInsetsGeometry padding;

  const AppInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.valueWidget,
    this.icon,
    this.labelStyle,
    this.valueStyle,
    this.padding = const EdgeInsets.symmetric(vertical: 4.0),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16.0, color: Colors.grey),
                const SizedBox(width: 8.0),
              ],
              Text(
                label,
                style: labelStyle ??
                    theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: valueWidget ??
                Text(
                  value,
                  textAlign: TextAlign.end,
                  style: valueStyle ??
                      theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
          ),
        ],
      ),
    );
  }
}

/// Reusable price breakdown row (Subtotal, Shipping, Discount, Total)
/// with currency localization and styling states.
class AppPriceRow extends StatelessWidget {
  final String label;
  final double amount;
  final String? currency;
  final bool isTotal;
  final bool isDiscount;
  final EdgeInsetsGeometry padding;

  const AppPriceRow({
    super.key,
    required this.label,
    required this.amount,
    this.currency,
    this.isTotal = false,
    this.isDiscount = false,
    this.padding = const EdgeInsets.symmetric(vertical: 4.0),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final effectiveCurrency = currency ??
        AppLocalizations.of(context)?.currency ??
        (isAr ? 'ج.م' : 'EGP');

    final effectiveLabelStyle = theme.textTheme.bodyMedium?.copyWith(
      color: isTotal ? null : Colors.grey,
      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
      fontSize: isTotal ? 16.0 : 14.0,
    );

    final effectivePriceStyle = theme.textTheme.bodyMedium?.copyWith(
      color: isDiscount
          ? AppColors.success
          : (isTotal ? AppColors.primary : null),
      fontWeight: isTotal ? FontWeight.w900 : FontWeight.w600,
      fontSize: isTotal ? 18.0 : 14.0,
    );

    final prefix = isDiscount ? '- ' : '';

    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: effectiveLabelStyle),
          Text(
            '$prefix${amount.toStringAsFixed(2)} $effectiveCurrency',
            style: effectivePriceStyle,
          ),
        ],
      ),
    );
  }
}
