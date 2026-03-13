import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/categories_sections_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class ShortcutItem extends ConsumerWidget {
  final int index;

  const ShortcutItem({super.key, required this.index});

  static const double _iconSize = 56.0;
  static const double _iconInnerSize = 28.0;
  static const double _labelWidth = 70.0;
  static const double _labelFontSize = 12.0;
  static const double _labelSpacing = 6.0;
  static const Duration _animationDuration = Duration(milliseconds: 180);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sectionsState = ref.watch(categoriesSectionsControllerProvider);
    final selectedIndex = ref
        .watch(categoriesSectionsControllerProvider.notifier)
        .selectedIndex;
    final isSelected = selectedIndex == index;

    return sectionsState.when(
      data: (selections) {
        final item = selections[index];
        final theme = Theme.of(context);

        return Semantics(
          label: '${getLocalizedLabel(context, item.label)} category',
          selected: isSelected,
          button: true,
          child: GestureDetector(
            onTap: () => ref
                .read(categoriesSectionsControllerProvider.notifier)
                .updateIndex(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: _animationDuration,
                  curve: Curves.easeInOut,
                  width: _iconSize,
                  height: _iconSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.surfaceContainerHighest,
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? theme.colorScheme.primary.withValues(alpha: .3)
                            : theme.colorScheme.primary.withValues(alpha: .1),
                        blurRadius: isSelected ? 6 : 3,
                        offset: const Offset(2, 3),
                        blurStyle: BlurStyle.outer,
                      ),
                    ],
                  ),
                  child: Icon(
                    item.icon,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                    size: _iconInnerSize,
                    shadows: [
                      BoxShadow(
                        color: isSelected
                            ? theme.scaffoldBackgroundColor
                            : theme.colorScheme.primary.withValues(alpha: .1),
                        blurRadius: isSelected ? 6 : 3,
                        offset: const Offset(2, 3),
                        blurStyle: BlurStyle.outer,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: _labelSpacing),
                SizedBox(
                  width: _labelWidth,
                  child: Text(
                    getLocalizedLabel(context, item.label),
                    style: TextStyle(
                      fontSize: _labelFontSize,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  String getLocalizedLabel(BuildContext context, String key) {
    final localizations = AppLocalizations.of(context)!;
    switch (key) {
      case 'categoryHome':
        return localizations.categoryHome;
      case 'categoryProtein':
        return localizations.categoryProtein;
      case 'categoryAmino':
        return localizations.categoryAmino;
      case 'categoryVitamins':
        return localizations.categoryVitamins;
      case 'categoryPreWorkout':
        return localizations.categoryPreWorkout;
      case 'categoryRecovery':
        return localizations.categoryRecovery;
      case 'categoryFatBurner':
        return localizations.categoryFatBurner;
      case 'categoryHealth':
        return localizations.categoryHealth;
      case 'categoryCarb':
        return localizations.categoryCarb;
      case 'categoryCreatine':
        return localizations.categoryCreatine;
      default:
        return key;
    }
  }
}
