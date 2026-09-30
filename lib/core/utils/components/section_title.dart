import 'package:flutter/material.dart';

/// A reusable section title widget with an optional action button.
///
/// Used across features (home, search, etc.) to display section headers
/// with a "See All" or similar action.
class SectionTitle extends StatelessWidget {
  static const double _horizontalPadding = 16.0;
  static const double _verticalPadding = 8.0;

  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;

  const SectionTitle({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(
        left: _horizontalPadding,
        right: _horizontalPadding,
        bottom: _verticalPadding,
        top: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          if (actionText != null)
            TextButton(
              onPressed: onActionTap,
              child: Text(actionText!),
            ),
        ],
      ),
    );
  }
}
