import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/categories_sections_controller.dart';
import 'package:stronger_muscles/features/home/presentation/helpers/selection_ui_mapper.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// One category shortcut (circular icon + label) in the home shortcuts row.
class ShortcutItem extends ConsumerWidget {
  static const double _labelWidth = 72.0;

  final int index;

  const ShortcutItem({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Selective state listening prevents rebuilding unaffected items
    final isSelected = ref.watch(
      selectedCategoryIndexProvider.select((idx) => idx == index),
    );
    final item = ref.watch(
      categoriesSectionsControllerProvider.select((s) {
        final list = s.valueOrNull;
        return list != null && index >= 0 && index < list.length ? list[index] : null;
      }),
    );

    if (item == null) return const SizedBox.shrink();

    final label = item.localizedLabel(AppLocalizations.of(context));
    final activeColor = isSelected ? AppColors.primary : context.colorScheme.onSurfaceVariant;

    return Semantics(
      label: label,
      selected: isSelected,
      button: true,
      child: InkWell(
        borderRadius: AppRadius.allMd,
        onTap: () => ref.read(categoriesSectionsControllerProvider.notifier).updateIndex(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIconTile(
              icon: item.icon,
              circular: true,
              iconSize: 26.0,
              padding: 15.0,
              color: activeColor,
              backgroundColor: isSelected
                  ? AppColors.primary.withValues(alpha: 0.12)
                  : context.colorScheme.surfaceContainerHighest,
              boxShadow: isSelected ? AppShadows.soft(AppColors.primary) : null,
            ),
            const SizedBox(height: 6.0),
            SizedBox(
              width: _labelWidth,
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.labelMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: activeColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
