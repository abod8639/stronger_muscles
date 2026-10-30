import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// Animated shimmer for loading skeletons. Wrap a skeleton layout once and use
/// [AppSkeletonBox] (or [AppShimmer.colorOf]) for every placeholder inside it,
/// so a whole skeleton shares a single animation controller.
class AppShimmer extends StatefulWidget {
  final Widget child;

  const AppShimmer({super.key, required this.child});

  /// Current shimmer color for placeholders under the nearest [AppShimmer].
  static Color colorOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ShimmerScope>()?.color ??
      _baseColor(context);

  static Color _baseColor(BuildContext context) =>
      context.isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0);

  static Color _highlightColor(BuildContext context) =>
      context.isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF5F5F5);

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (context, child) => _ShimmerScope(
        color: Color.lerp(
          AppShimmer._baseColor(context),
          AppShimmer._highlightColor(context),
          _animation.value,
        )!,
        child: child!,
      ),
    );
  }
}

class _ShimmerScope extends InheritedWidget {
  final Color color;

  const _ShimmerScope({required this.color, required super.child});

  @override
  bool updateShouldNotify(_ShimmerScope oldWidget) => color != oldWidget.color;
}

/// A rounded (or circular) placeholder block that takes the shimmer color.
class AppSkeletonBox extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final bool circle;
  final EdgeInsetsGeometry? margin;
  final Widget? child;

  const AppSkeletonBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.circle = false,
    this.margin,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: AppShimmer.colorOf(context),
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circle ? null : (borderRadius ?? AppRadius.allSm),
      ),
      child: child,
    );
  }
}
