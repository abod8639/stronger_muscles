
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/bindings/sections_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';


   const double _iconSize = 56.0;
   const double _iconInnerSize = 28.0;
   const double _labelWidth = 70.0;
   const double _labelFontSize = 12.0;
   const double _labelSpacing = 6.0;
   const Duration _animationDuration = Duration(milliseconds: 180);

/// Builds a single shortcut item
  Widget buildShortcutItem( int index ) {
    final sectionsController = Get.find<SectionsController>();
    final item = sectionsController.selections[index];

    return Obx(() {
      final isSelected = sectionsController.selectedIndex.value == index;

      return Builder(
        builder: (context) {
          final theme = Theme.of(context);

          return Semantics(
            label: '${getLocalizedLabel(context, item.label)} category',
            selected: isSelected,
            button: true,
            child: GestureDetector(
              onTap: () => sectionsController.updateIndex(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon container with animation
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
                              ? theme.colorScheme.primary.withOpacity(0.3)
                              : theme.colorScheme.primary.withOpacity(0.1),
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
                    ),
                  ),
          
                  const SizedBox(height: _labelSpacing),
          
                  // Label
                  SizedBox(
                    width: _labelWidth,
                    child: Text(
                      getLocalizedLabel(context, item.label),
                      style: TextStyle(
                        fontSize: _labelFontSize,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
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
        }
      );
    });

    
  }

  String getLocalizedLabel(BuildContext context, String key) {
    final localizations = AppLocalizations.of(context)!;
    switch (key) {
      case 'categoryHome':
        return localizations.categoryHome;
      case 'categoryProtein':
        return localizations.categoryProtein;
      case 'categoryCreatine':
        return localizations.categoryCreatine;
      case 'categoryAmino':
        return localizations.categoryAmino;
      case 'categoryBCAA':
        return localizations.categoryBCAA;
      case 'categoryPreWorkout':
        return localizations.categoryPreWorkout;
      case 'categoryMassGainer':
        return localizations.categoryMassGainer;
      default:
        return key;
    }
  }