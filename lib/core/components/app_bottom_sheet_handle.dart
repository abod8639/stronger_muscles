import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/theme/app_radius.dart';

/// A reusable drag handle indicator for modal bottom sheets.
///
/// Displays a small rounded bar using unified [AppRadius.allPill]
/// to indicate that the sheet can be dragged or dismissed.
class AppBottomSheetHandle extends StatelessWidget {
  final double width;
  final double height;
  final Color? color;

  const AppBottomSheetHandle({
    super.key,
    this.width = 40.0,
    this.height = 4.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.outlineVariant,
        borderRadius: AppRadius.allPill,
      ),
    );
  }
}

/// Backward compatibility alias
typedef BottomSheetHandle = AppBottomSheetHandle;
