import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/app_product_grid.dart';
import 'package:stronger_muscles/core/components/app_shimmer.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// A shimmer-style skeleton grid shown while products are loading,
/// laid out exactly like [AppProductGrid].
class ProductGridSkeleton extends StatelessWidget {
  final int itemCount;

  const ProductGridSkeleton({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: AppProductGridLayout.padding,
      sliver: SliverGrid(
        gridDelegate: AppProductGridLayout.delegate(context),
        delegate: SliverChildBuilderDelegate(
          (context, index) => const AppShimmer(child: _SkeletonCard()),
          childCount: itemCount,
          addAutomaticKeepAlives: false,
        ),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadius.allLg,
        border: Border.all(color: AppShimmer.colorOf(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: AppSkeletonBox(borderRadius: AppRadius.top(AppRadius.lg)),
          ),
          const Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AppSkeletonBox(width: double.infinity, height: 10),
                  AppSkeletonBox(width: 100, height: 8),
                  AppSkeletonBox(width: 60, height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
