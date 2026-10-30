import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/app_product_grid.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// A shimmer-style skeleton grid shown while products are loading.
/// Uses a pure Flutter animation — no external dependency needed.
class ProductGridSkeleton extends StatefulWidget {
  final int itemCount;

  const ProductGridSkeleton({super.key, this.itemCount = 6});

  @override
  State<ProductGridSkeleton> createState() => _ProductGridSkeletonState();
}

class _ProductGridSkeletonState extends State<ProductGridSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: AppProductGridLayout.padding,
      sliver: SliverGrid(
        gridDelegate: AppProductGridLayout.delegate(context),
        delegate: SliverChildBuilderDelegate(
          (context, index) => AnimatedBuilder(
            animation: _animation,
            builder: (context, _) => _SkeletonCard(shimmer: _animation.value),
          ),
          childCount: widget.itemCount,
          addAutomaticKeepAlives: false,
        ),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  final double shimmer;

  const _SkeletonCard({required this.shimmer});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final baseColor =
        isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0);
    final highlightColor =
        isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF5F5F5);

    final color = Color.lerp(baseColor, highlightColor, shimmer)!;

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppRadius.allLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: AppRadius.top(AppRadius.lg),
              ),
            ),
          ),
          // Text placeholders
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _bar(color, width: double.infinity, height: 10),
                  _bar(color, width: 100, height: 8),
                  _bar(color, width: 60, height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bar(Color color, {required double width, required double height}) {
    final barColor = Color.lerp(color, Colors.white.withValues(alpha: 0.3), shimmer * 0.4)!;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: barColor,
        borderRadius: AppRadius.allXs,
      ),
    );
  }
}

