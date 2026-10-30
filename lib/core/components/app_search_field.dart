import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/app_radius.dart';
import 'package:stronger_muscles/core/theme/app_shadows.dart';

/// A reusable search text field component with theme-aware styling,
/// unified shadows, clear button, and prefix icon.
class AppSearchField extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final VoidCallback? onTap;
  final String hintText;
  final bool readOnly;
  final bool autofocus;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? margin;
  final Widget? trailing;

  const AppSearchField({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.onTap,
    this.hintText = 'بحث...',
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
    this.margin,
    this.trailing,
  });

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late final TextEditingController _controller;
  bool _showClear = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_handleTextChanged);
    _showClear = _controller.text.isNotEmpty;
  }

  void _handleTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _showClear && mounted) {
      setState(() => _showClear = hasText);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? AppColors.surfaceDark : AppColors.white;

    return Container(
      margin: widget.margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.allLg,
        boxShadow: isDark ? AppShadows.ofSubtle(context) : AppShadows.subtle(),
        border: Border.all(
          color: isDark ? Colors.white10 : AppColors.greyMedium.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _controller,
        focusNode: widget.focusNode,
        readOnly: widget.readOnly,
        autofocus: widget.autofocus,
        onTap: widget.onTap,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        textInputAction: TextInputAction.search,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          fontSize: 15,
          color: isDark ? AppColors.white : AppColors.black,
        ),
        decoration: InputDecoration(
          isDense: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.grey : AppColors.greyDark,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.primary,
            size: 22,
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_showClear && !widget.readOnly)
                IconButton(
                  splashRadius: 18,
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: AppColors.greyDark,
                  ),
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged?.call('');
                    widget.onClear?.call();
                  },
                ),
              if (widget.trailing != null) widget.trailing!,
            ],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
