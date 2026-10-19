import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/app_radius.dart';
import 'package:stronger_muscles/features/product/presentation/controllers/category_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Horizontal category chip selector allowing users to filter products.
/// Styled using unified [AppRadius.allPill] and theme-adaptive colors.
class CategoryChipSelector extends ConsumerWidget {
  final String selectedCategoryId;
  final ValueChanged<String> onCategorySelected;
  final EdgeInsetsGeometry padding;

  const CategoryChipSelector({
    super.key,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryControllerProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final locale = l10n?.localeName ?? 'en';
    final allLabel = l10n?.allCategories ?? 'All';

    return categoriesAsync.when(
      data: (categories) {
        if (categories.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          height: 44.0,
          child: ListView.separated(
            padding: padding,
            scrollDirection: Axis.horizontal,
            itemCount: categories.length + 1,
            separatorBuilder: (_, _) => const SizedBox(width: 8.0),
            itemBuilder: (context, index) {
              final isAll = index == 0;
              final isSelected = isAll
                  ? selectedCategoryId.isEmpty
                  : selectedCategoryId == categories[index - 1].id;

              final title = isAll
                  ? allLabel
                  : categories[index - 1].getLocalizedName(locale: locale);
              final categoryId = isAll ? '' : categories[index - 1].id;

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onCategorySelected(categoryId),
                  borderRadius: AppRadius.allPill,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.5),
                      borderRadius: AppRadius.allPill,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : theme.colorScheme.outlineVariant
                                .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        title,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: isSelected
                              ? Colors.white
                              : theme.colorScheme.onSurface,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => const SizedBox(
        height: 44.0,
        child: Center(
          child: SizedBox(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(strokeWidth: 2.0),
          ),
        ),
      ),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
