import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';

/// A reusable expandable accordion tile with smooth rotation,
/// unified shadows, and border radius.
class AppAccordionTile extends StatefulWidget {
  final Widget? leading;
  final String title;
  final Widget content;
  final Widget? trailing;
  final Widget? badge;
  final bool initiallyExpanded;
  final ValueChanged<bool>? onExpansionChanged;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const AppAccordionTile({
    super.key,
    this.leading,
    required this.title,
    required this.content,
    this.trailing,
    this.badge,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
    this.margin,
    this.padding,
  });

  @override
  State<AppAccordionTile> createState() => _AppAccordionTileState();
}

class _AppAccordionTileState extends State<AppAccordionTile>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late final AnimationController _controller;
  late final Animation<double> _iconTurns;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
      value: _isExpanded ? 1.0 : 0.0,
    );
    _iconTurns = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      widget.onExpansionChanged?.call(_isExpanded);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final borderColor = _isExpanded
        ? AppColors.primary.withValues(alpha: 0.35)
        : colorScheme.outlineVariant;

    return Container(
      margin: widget.margin ?? const EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppRadius.allLg,
        boxShadow: context.subtleShadow,
        border: Border.all(color: borderColor, width: 1.2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _handleTap,
              borderRadius: AppRadius.allLg,
              child: Padding(
                padding: widget.padding ??
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                child: Row(
                  children: [
                    if (widget.leading != null) ...[
                      widget.leading!,
                      const SizedBox(width: 12.0),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.badge != null) ...[
                            widget.badge!,
                            const SizedBox(height: 6.0),
                          ],
                          Text(
                            widget.title,
                            style: context.textTheme.titleSmall?.copyWith(
                              fontSize: 15.0,
                              fontWeight: _isExpanded ? FontWeight.bold : FontWeight.w600,
                              color: colorScheme.onSurface,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    if (widget.trailing != null)
                      widget.trailing!
                    else
                      RotationTransition(
                        turns: _iconTurns,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: _isExpanded
                                ? AppColors.primary.withValues(alpha: 0.1)
                                : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: _isExpanded
                                ? AppColors.primary
                                : colorScheme.onSurfaceVariant,
                            size: 22.0,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  height: 1,
                  thickness: 1,
                  color: colorScheme.outlineVariant,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                  child: widget.content,
                ),
              ],
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}
