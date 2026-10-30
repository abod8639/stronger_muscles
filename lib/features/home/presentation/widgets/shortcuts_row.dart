import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/categories_sections_controller.dart';
import 'package:stronger_muscles/features/home/presentation/widgets/shortcut_item.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Horizontal row of category shortcuts at the top of the home page.
class CategoriesShortcutsRow extends ConsumerWidget {
  static const double _rowHeight = 92.0;
  static const double _spacing = AppDimens.spacingXs;
  static const EdgeInsets _padding = EdgeInsets.symmetric(
    horizontal: AppDimens.spacingMd,
    vertical: AppDimens.spacingSm,
  );

  const CategoriesShortcutsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sectionsState = ref.watch(categoriesSectionsControllerProvider);
    final l10n = AppLocalizations.of(context);

    return sectionsState.when(
      data: (selections) => selections.isEmpty
          ? const SizedBox.shrink()
          : Padding(
              padding: _padding,
              child: SizedBox(
                height: _rowHeight,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: selections.length,
                  separatorBuilder: (_, _) => const SizedBox(width: _spacing),
                  itemBuilder: (_, index) => ShortcutItem(index: index),
                ),
              ),
            ),
      loading: () => Padding(
        padding: _padding,
        child: SizedBox(
          height: _rowHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            separatorBuilder: (_, _) => const SizedBox(width: _spacing + 16.0),
            itemBuilder: (_, _) => Align(
              alignment: Alignment.topCenter,
              child: CircleAvatar(
                radius: 28.0,
                backgroundColor: context.colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
        ),
      ),
      error: (error, _) => AppAlertCard(
        color: AppColors.error,
        icon: AppErrorCard.iconFor(error),
        message: AppErrorCard.messageFor(error, l10n),
        margin: _padding,
        actionLabel: l10n?.retry ?? 'إعادة المحاولة',
        onAction: () => ref.read(categoriesSectionsControllerProvider.notifier).fetchCategories(),
      ),
    );
  }
}
