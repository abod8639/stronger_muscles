import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// A reusable, theme-adaptive selectable option card.
///
/// Ideal for radio choices, address selectors, payment methods, shipping methods,
/// and filter options with unified shadows and border radii.
class AppSelectableCard<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String title;
  final String? subtitle;
  final Widget? leading;
  final IconData? leadingIcon;
  final Widget? trailing;
  final bool enabled;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const AppSelectableCard({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.leading,
    this.leadingIcon,
    this.trailing,
    this.enabled = true,
    this.borderRadius,
    this.margin,
    this.padding,
  });

  bool get isSelected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveRadius = borderRadius ?? AppRadius.allMd;

    final selectedBg = AppColors.primary.withValues(alpha: context.isDark ? 0.15 : 0.06);

    final unselectedBg = theme.colorScheme.surface;

    final selectedBorderColor = AppColors.primary;
    final unselectedBorderColor = theme.colorScheme.outlineVariant;

    final effectiveTextColor = enabled
        ? theme.colorScheme.onSurface
        : theme.colorScheme.onSurface.withValues(alpha: 0.4);

    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: isSelected ? selectedBg : unselectedBg,
        borderRadius: effectiveRadius,
        border: Border.all(
          color: isSelected ? selectedBorderColor : unselectedBorderColor,
          width: isSelected ? 1.5 : 1.0,
        ),
        boxShadow: isSelected ? AppShadows.ofSubtle(context) : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: effectiveRadius is BorderRadius
              ? effectiveRadius
              : AppRadius.allMd,
          onTap: enabled && onChanged != null ? () => onChanged!(value) : null,
          child: Padding(
            padding: padding ??
                const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: 12.0),
                ] else if (leadingIcon != null) ...[
                  Icon(
                    leadingIcon,
                    color: enabled
                        ? (isSelected ? AppColors.primary : theme.colorScheme.onSurfaceVariant)
                        : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    size: 24.0,
                  ),
                  const SizedBox(width: 12.0),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          color: effectiveTextColor,
                        ),
                      ),
                      if (subtitle != null && subtitle!.isNotEmpty) ...[
                        const SizedBox(height: 3.0),
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: enabled
                                ? theme.colorScheme.onSurfaceVariant
                                : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                trailing ??
                    Radio<T>(
                      value: value,
                      groupValue: groupValue,
                      onChanged: enabled ? onChanged : null,
                      activeColor: AppColors.primary,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
