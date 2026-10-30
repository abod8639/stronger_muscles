import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// Single-select pill chips (filters, categories, priorities).
///
/// Lays out as a horizontal scroll row when [scrollable] is true,
/// otherwise wraps onto multiple lines.
class AppChoiceChips<T> extends StatelessWidget {
  final List<T> items;
  final T selected;
  final ValueChanged<T> onSelected;
  final String Function(T item) labelOf;
  final IconData? Function(T item)? iconOf;
  final Color Function(T item)? colorOf;
  final bool scrollable;
  final EdgeInsetsGeometry padding;

  const AppChoiceChips({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelected,
    required this.labelOf,
    this.iconOf,
    this.colorOf,
    this.scrollable = true,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final chips = [
      for (final item in items)
        _ChoiceChip(
          label: labelOf(item),
          icon: iconOf?.call(item),
          color: colorOf?.call(item) ?? AppColors.primary,
          isSelected: item == selected,
          onTap: () => onSelected(item),
        ),
    ];

    if (!scrollable) {
      return Padding(
        padding: padding,
        child: Wrap(
          spacing: AppDimens.spacingSm,
          runSpacing: AppDimens.spacingSm,
          children: chips,
        ),
      );
    }

    return SizedBox(
      height: 42.0,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: chips.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppDimens.spacingSm),
        itemBuilder: (_, index) => chips[index],
      ),
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChoiceChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = isSelected ? AppColors.white : context.colorScheme.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.allPill,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: isSelected ? color : context.colorScheme.surface,
            borderRadius: AppRadius.allPill,
            border: Border.all(
              color: isSelected
                  ? color
                  : context.colorScheme.outlineVariant,
            ),
            boxShadow: isSelected
                ? AppShadows.colored(color, alpha: 0.28, blur: 8.0)
                : context.subtleShadow,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16.0,
                  color: isSelected ? AppColors.white : context.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6.0),
              ],
              Text(
                label,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontSize: 13.0,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: foreground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
