import 'package:flutter/material.dart';

/// A reusable section title header widget with an optional action button or custom action widget.
///
/// Used across features (home, search, profile, catalog, help/support, etc.) to display
/// section headers with a "See All" or custom action.
class AppSectionTitle extends StatelessWidget {
  static const double _horizontalPadding = 16.0;
  static const double _verticalPadding = 8.0;

  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;
  final Widget? actionWidget;
  final Widget? leading;
  final EdgeInsetsGeometry padding;

  const AppSectionTitle({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
    this.actionWidget,
    this.leading,
    this.padding = const EdgeInsets.only(
      left: _horizontalPadding,
      right: _horizontalPadding,
      bottom: _verticalPadding,
    ),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: padding,
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

/// Backward compatibility alias
typedef SectionTitle = AppSectionTitle;
