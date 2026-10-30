import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/app_field_label.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// A reusable modern text form field with theme support, unified borders,
/// and optional built-in password visibility toggle.
class AppTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final int minLines;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool readOnly;
  final bool autofocus;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? focusNode;
  final Iterable<String>? autofillHints;

  const AppTextFormField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.minLines = 1,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.readOnly = false,
    this.autofocus = false,
    this.isPassword = false,
    this.obscureText = false,
    this.onTap,
    this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
    this.autofillHints,
  });

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.isPassword || widget.obscureText;
  }

  @override
  void didUpdateWidget(covariant AppTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.obscureText != widget.obscureText ||
        oldWidget.isPassword != widget.isPassword) {
      _obscured = widget.isPassword || widget.obscureText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mutedColor = context.colorScheme.onSurfaceVariant;

    Widget? effectiveSuffix = widget.suffixIcon;
    if (widget.isPassword && effectiveSuffix == null) {
      effectiveSuffix = IconButton(
        icon: Icon(
          _obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: mutedColor,
          size: 20.0,
        ),
        splashRadius: 20.0,
        onPressed: () => setState(() => _obscured = !_obscured),
      );
    }

    // Borders, fill and hint style come from the app's InputDecorationTheme.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) AppFieldLabel(widget.label!),
        TextFormField(
          controller: widget.controller,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          minLines: widget.minLines,
          obscureText: _obscured,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          focusNode: widget.focusNode,
          autofillHints: widget.autofillHints,
          style: context.textTheme.bodyMedium?.copyWith(fontSize: 14.5),
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon,
            prefixIconColor: mutedColor,
            suffixIcon: effectiveSuffix,
          ),
        ),
      ],
    );
  }
}
