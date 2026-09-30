import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';

/// A reusable drag handle for bottom sheets.
///
/// Displays a small rounded bar at the top of modal bottom sheets
/// to indicate the sheet can be dragged.
class BottomSheetHandle extends StatelessWidget {
  const BottomSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(AppDimens.radiusSm / 4),
      ),
    );
  }
}
