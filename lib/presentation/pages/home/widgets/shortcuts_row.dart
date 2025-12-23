import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/bindings/sections_controller.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/buildShortcutItem.dart';

/// Horizontal scrollable row of category shortcuts
class ShortcutsRow extends StatelessWidget {
  // Constants for styling
  static const double _horizontalPadding = 12.0;
  static const double _verticalPadding = 8.0;
  static const double _rowHeight = 90.0;
  static const double _spacing = 5.0;
  const ShortcutsRow({super.key});

  @override
  Widget build(BuildContext context) {
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
          itemBuilder: (context, index) => buildShortcutItem(index),
        ),
      ),
    );
  }
}

/// Legacy class name for backward compatibility.
///
/// **Deprecated**: Use [ShortcutsRow] instead.
@Deprecated('Use ShortcutsRow instead')
class SelectionsRow extends ShortcutsRow {
  const SelectionsRow({super.key});
}
