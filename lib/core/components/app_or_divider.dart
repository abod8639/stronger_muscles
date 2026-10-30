import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// A reusable horizontal divider with a centered label (e.g. "أو" / "OR").
class AppOrDivider extends StatelessWidget {
  final String label;
  final EdgeInsetsGeometry margin;

  const AppOrDivider({
    super.key,
    this.label = 'أو',
    this.margin = const EdgeInsets.symmetric(vertical: 20.0),
  });

  @override
  Widget build(BuildContext context) {
    final dividerColor = context.colorScheme.outlineVariant;
    final textColor = context.colorScheme.onSurfaceVariant;

    return Padding(
      padding: margin,
      child: Row(
        children: [
          Expanded(child: Divider(color: dividerColor, thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
          Expanded(child: Divider(color: dividerColor, thickness: 1)),
        ],
      ),
    );
  }
}
