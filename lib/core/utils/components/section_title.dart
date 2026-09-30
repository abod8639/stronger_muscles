import 'package:flutter/material.dart';

/// A reusable section title widget with an optional action button or custom action widget.
///
/// Used across features (home, search, profile, etc.) to display section headers
/// with a "See All" or custom action.
class SectionTitle extends StatelessWidget {
  static const double _horizontalPadding = 16.0;
  static const double _verticalPadding = 8.0;

  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;
  final Widget? actionWidget;
  final Widget? leading;

  const SectionTitle({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
    this.actionWidget,
    this.leading,
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: 8.0),
                ],
                Flexible(
                  child: Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          if (actionWidget != null)
            actionWidget!
          else if (actionText != null)
            TextButton(
              onPressed: onActionTap,
              child: Text(actionText!),
            ),
        ],
      ),
    );
  }
}
