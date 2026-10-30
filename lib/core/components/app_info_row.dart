import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/app_price_text.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';

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
                Icon(icon, size: 16.0, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 8.0),
              ],
              Text(
                label,
                style: labelStyle ??
                    theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
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
                        color: theme.colorScheme.onSurface,
                      ),
                ),
          ),
        ],
      ),
    );
  }
}

/// Reusable price breakdown row (Subtotal, Shipping, Discount, Total).
///
/// Amounts use the app-wide [AppPriceText.format] unless [currency] is given.
/// [valueText] replaces the amount entirely (e.g. "Free delivery").
class AppPriceRow extends StatelessWidget {
  final String label;
  final double amount;
  final String? currency;
  final String? valueText;
  final Color? valueColor;
  final bool isTotal;
  final bool isDiscount;
  final EdgeInsetsGeometry padding;

  const AppPriceRow({
    super.key,
    required this.label,
    this.amount = 0,
    this.currency,
    this.valueText,
    this.valueColor,
    this.isTotal = false,
    this.isDiscount = false,
    this.padding = const EdgeInsets.symmetric(vertical: 4.0),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final effectiveLabelStyle = theme.textTheme.bodyMedium?.copyWith(
      color: isTotal ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant,
      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
      fontSize: isTotal ? 16.0 : 14.0,
    );

    final effectivePriceStyle = theme.textTheme.bodyMedium?.copyWith(
      color: valueColor ??
          (isDiscount
              ? AppColors.success
              : (isTotal ? AppColors.primary : theme.colorScheme.onSurface)),
      fontWeight: isTotal ? FontWeight.w900 : FontWeight.w600,
      fontSize: isTotal ? 18.0 : 14.0,
    );

    final formatted = currency != null
        ? '${amount.toStringAsFixed(2)} $currency'
        : AppPriceText.format(amount);

    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(label, style: effectiveLabelStyle)),
          const SizedBox(width: 12.0),
          Text(
            valueText ?? '${isDiscount ? '- ' : ''}$formatted',
            style: effectivePriceStyle,
          ),
        ],
      ),
    );
  }
}
