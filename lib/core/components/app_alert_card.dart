import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// A reusable tinted status card (error, success, warning, info) with a
/// circular icon, optional title, message, dismiss button and inline action.
class AppAlertCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String message;
  final String? title;
  final VoidCallback? onDismiss;
  final String? actionLabel;
  final IconData actionIcon;
  final VoidCallback? onAction;
  final bool isActionLoading;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final double iconSize;

  const AppAlertCard({
    super.key,
    required this.color,
    required this.icon,
    required this.message,
    this.title,
    this.onDismiss,
    this.actionLabel,
    this.actionIcon = Icons.refresh_rounded,
    this.onAction,
    this.isActionLoading = false,
    this.padding = const EdgeInsets.all(14.0),
    this.margin,
    this.borderRadius,
    this.iconSize = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textTheme = context.textTheme;
    final hasTitle = title != null;

    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.12 : 0.07),
        borderRadius: borderRadius ?? AppRadius.allMd,
        border: Border.all(color: color.withValues(alpha: isDark ? 0.3 : 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment:
                hasTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: iconSize, color: color),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasTitle) ...[
                      Text(
                        title!,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                          fontSize: 12.5,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                    ],
                    Text(
                      message,
                      style: hasTitle
                          ? textTheme.labelSmall?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                              fontSize: 10.5,
                            )
                          : textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: context.colorScheme.onSurface,
                              height: 1.4,
                            ),
                    ),
                  ],
                ),
              ),
              if (onDismiss != null)
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18.0),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: context.colorScheme.onSurfaceVariant,
                  onPressed: onDismiss,
                ),
            ],
          ),
          if (onAction != null && actionLabel != null) ...[
            const SizedBox(height: 8.0),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton.icon(
                onPressed: isActionLoading ? null : onAction,
                style: TextButton.styleFrom(
                  foregroundColor: color,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: isActionLoading
                    ? SizedBox.square(
                        dimension: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(color),
                        ),
                      )
                    : Icon(actionIcon, size: 16.0),
                label: Text(
                  actionLabel!,
                  style: textTheme.labelLarge?.copyWith(
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
