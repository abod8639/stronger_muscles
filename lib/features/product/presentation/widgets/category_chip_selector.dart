import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/features/product/presentation/controllers/category_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Horizontal category filter for the product catalog ("All" + each category).
/// An empty id means "All".
class CategoryChipSelector extends ConsumerWidget {
  final String selectedCategoryId;
  final ValueChanged<String> onCategorySelected;
  final EdgeInsetsGeometry padding;

  const CategoryChipSelector({
    super.key,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    this.padding = const EdgeInsets.symmetric(horizontal: AppDimens.spacingLg),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryControllerProvider);
    final l10n = AppLocalizations.of(context);
    final locale = l10n?.localeName ?? 'en';

    return categoriesAsync.maybeWhen(
      data: (categories) {
        if (categories.isEmpty) return const SizedBox.shrink();

        final names = {
          '': l10n?.allCategories ?? 'All',
          for (final category in categories) category.id: category.getLocalizedName(locale: locale),
        };

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimens.spacingSm),
          child: AppChoiceChips<String>(
            items: names.keys.toList(),
            selected: selectedCategoryId,
            labelOf: (id) => names[id] ?? id,
            onSelected: onCategorySelected,
            padding: padding,
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
