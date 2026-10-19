import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/app_radius.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// A reusable expandable text block with smooth animation and theme styling.
/// Truncates text exceeding [maxLines] with an interactive "Read More / Read Less" toggle.
class AppExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextStyle? style;
  final String? expandText;
  final String? collapseText;
  final Duration animationDuration;
  final bool initiallyExpanded;
  final ValueChanged<bool>? onToggle;

  const AppExpandableText({
    super.key,
    required this.text,
    this.maxLines = 4,
    this.style,
    this.expandText,
    this.collapseText,
    this.animationDuration = const Duration(milliseconds: 250),
    this.initiallyExpanded = false,
    this.onToggle,
  });

  @override
  State<AppExpandableText> createState() => _AppExpandableTextState();
}

class _AppExpandableTextState extends State<AppExpandableText> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    widget.onToggle?.call(_isExpanded);
  }

  bool _shouldShowToggle(BuildContext context, TextStyle effectiveStyle) {
    final textSpan = TextSpan(text: widget.text, style: effectiveStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: Directionality.of(context),
      maxLines: widget.maxLines,
    );

    // Layout with infinite width to determine if it overflows given constraints
    textPainter.layout(maxWidth: MediaQuery.sizeOf(context).width);
    final didExceed = textPainter.didExceedMaxLines || widget.text.length > 200;
    return didExceed;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    final effectiveStyle = widget.style ??
        theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          height: 1.5,
          letterSpacing: 0.2,
        ) ??
        const TextStyle();

    final readMoreLabel = widget.expandText ?? l10n?.readMore ?? 'Read more';
    final readLessLabel = widget.collapseText ?? l10n?.readLess ?? 'Read less';
    final hasOverflow = _shouldShowToggle(context, effectiveStyle);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedCrossFade(
          firstChild: Text(
            widget.text,
            maxLines: widget.maxLines,
            overflow: TextOverflow.ellipsis,
            style: effectiveStyle,
          ),
          secondChild: Text(
            widget.text,
            style: effectiveStyle,
          ),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: widget.animationDuration,
        ),
        if (hasOverflow)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: InkWell(
              onTap: _toggle,
              borderRadius: AppRadius.allSm,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isExpanded ? readLessLabel : readMoreLabel,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 18.0,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
