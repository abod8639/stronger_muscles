import 'package:flutter/material.dart';

/// A reusable text widget that highlights matching portions of [text]
/// based on the provided [query].
///
/// Adapts the highlight color to the active theme's primary color or a custom color.
class AppHighlightText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle? style;
  final TextStyle? highlightStyle;
  final Color? highlightColor;
  final int maxLines;
  final TextOverflow overflow;

  const AppHighlightText({
    super.key,
    required this.text,
    required this.query,
    this.style,
    this.highlightStyle,
    this.highlightColor,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    final theme = Theme.of(context);
    final effectiveHighlightColor = highlightColor ?? theme.colorScheme.primary;
    final defaultHighlightStyle = TextStyle(
      color: effectiveHighlightColor,
      fontWeight: FontWeight.bold,
    );

    final String lowerText = text.toLowerCase();
    final String lowerQuery = query.toLowerCase();

    final List<TextSpan> spans = [];
    int start = 0;
    int indexOfMatch;

    while ((indexOfMatch = lowerText.indexOf(lowerQuery, start)) != -1) {
      if (indexOfMatch > start) {
        spans.add(TextSpan(text: text.substring(start, indexOfMatch)));
      }
      spans.add(TextSpan(
        text: text.substring(indexOfMatch, indexOfMatch + query.length),
        style: highlightStyle ?? defaultHighlightStyle,
      ));
      start = indexOfMatch + query.length;
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return RichText(
      text: TextSpan(
        style: style ?? DefaultTextStyle.of(context).style,
        children: spans,
      ),
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Backward compatibility alias
typedef HighlightText = AppHighlightText;
