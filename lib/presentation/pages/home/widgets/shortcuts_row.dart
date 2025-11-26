import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/bindings/sections_controller.dart';

/// Model for category shortcuts
class Selections {
  final String label;
  final IconData icon;

  Selections({required this.label, required this.icon});
}

/// Horizontal scrollable row of category shortcuts
class ShortcutsRow extends StatelessWidget {
  // Constants for styling
  static const double _horizontalPadding = 12.0;
  static const double _verticalPadding = 8.0;
  static const double _rowHeight = 90.0;
  static const double _iconSize = 56.0;
  static const double _iconInnerSize = 28.0;
  static const double _labelWidth = 70.0;
  static const double _labelFontSize = 12.0;
  static const double _spacing = 5.0;
  static const double _labelSpacing = 6.0;
  static const Duration _animationDuration = Duration(milliseconds: 180);

  const ShortcutsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sectionsController = Get.find<SectionsController>();

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
          itemCount: sectionsController.selections.length,
          separatorBuilder: (_, index) => const SizedBox(width: _spacing),
          itemBuilder: (context, index) => _buildShortcutItem(
            context,
            theme,
            sectionsController,
            index,
          ),
        ),
      ),
    );
  }

  /// Builds a single shortcut item
  Widget _buildShortcutItem(
    BuildContext context,
    ThemeData theme,
    SectionsController controller,
    int index,
  ) {
    final item = controller.selections[index];

    return Obx(() {
      final isSelected = controller.selectedIndex.value == index;

      return Semantics(
        label: '${item.label} category',
        selected: isSelected,
        button: true,
        child: GestureDetector(
          onTap: () => controller.updateIndex(index),
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
                  item.label,
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
    });
  }
}

/// Legacy class name for backward compatibility.
/// 
/// **Deprecated**: Use [ShortcutsRow] instead.
@Deprecated('Use ShortcutsRow instead')
class SelectionsRow extends ShortcutsRow {
  const SelectionsRow({super.key});
}
