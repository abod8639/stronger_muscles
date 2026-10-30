import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
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
    final isDark = context.isDark;
    final fillColor = isDark ? AppColors.surfaceDark : AppColors.greyLight.withValues(alpha: 0.6);

    Widget? effectiveSuffix = widget.suffixIcon;
    if (widget.isPassword && effectiveSuffix == null) {
      effectiveSuffix = IconButton(
        icon: Icon(
          _obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: isDark ? AppColors.grey : AppColors.greyDark,
          size: 20.0,
        ),
        splashRadius: 20.0,
        onPressed: () => setState(() => _obscured = !_obscured),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.greyLight : AppColors.greyDark,
            ),
          ),
          const SizedBox(height: 6.0),
        ],
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
          style: TextStyle(
            fontSize: 14.5,
            color: isDark ? AppColors.white : AppColors.black,
          ),
          decoration: InputDecoration(
            isDense: true,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontSize: 13.5,
              color: isDark ? AppColors.grey : AppColors.greyDark,
            ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: effectiveSuffix,
            filled: true,
            fillColor: fillColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 13.0),
            border: OutlineInputBorder(
              borderRadius: AppRadius.allMd,
              borderSide: BorderSide(
                color: isDark ? Colors.white12 : AppColors.greyMedium,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.allMd,
              borderSide: BorderSide(
                color: isDark ? Colors.white12 : AppColors.greyMedium.withValues(alpha: 0.8),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.allMd,
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppRadius.allMd,
              borderSide: const BorderSide(
                color: AppColors.error,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppRadius.allMd,
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
