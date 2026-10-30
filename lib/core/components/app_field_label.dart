import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// Small muted label shown above a form control or option group
/// (matches the label style of [AppTextFormField]).
class AppFieldLabel extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry padding;

  const AppFieldLabel(
    this.text, {
    super.key,
    this.padding = const EdgeInsets.only(bottom: 6.0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        text,
        style: context.textTheme.bodyMedium?.copyWith(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: context.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
