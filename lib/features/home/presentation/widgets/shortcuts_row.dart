import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/categories_sections_controller.dart';
import 'package:stronger_muscles/features/home/presentation/widgets/shortcut_item.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class CategoriesShortcutsRow extends ConsumerWidget {
  static const double _horizontalPadding = 12.0;
  static const double _verticalPadding = 8.0;
  static const double _rowHeight = 90.0;
  static const double _spacing = 5.0;

  const CategoriesShortcutsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sectionsState = ref.watch(categoriesSectionsControllerProvider);
    final l10n = AppLocalizations.of(context);

    return sectionsState.when(
      data: (selections) {
        if (selections.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: _horizontalPadding,
            vertical: _verticalPadding,
          ),
          child: SizedBox(
            height: _rowHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: selections.length,
              separatorBuilder: (_, index) => const SizedBox(width: _spacing),
              itemBuilder: (context, index) => ShortcutItem(index: index),
              addRepaintBoundaries: true,
            ),
          ),
        );
      },
      loading: () => const SizedBox(height: _rowHeight),
      error: (error, _) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
          vertical: _verticalPadding,
        ),
        child: SizedBox(
          height: 48.0,
          child: Center(
            child: TextButton.icon(
              onPressed: () => ref
                  .read(categoriesSectionsControllerProvider.notifier)
                  .fetchCategories(),
              icon: const Icon(Icons.refresh_rounded, size: 18.0),
              label: Text(
                error is Failure
                    ? error.toMessage()
                    : (l10n?.retry ?? 'إعادة تحميل الأقسام'),
                style: const TextStyle(fontSize: 12.0),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
