import 'package:flutter/material.dart';
import 'package:stronger_muscles/features/product/presentation/widgets/app_product_card.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/utils/responsive_helper.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';

/// Shared grid metrics for product grids and their loading skeleton.
class AppProductGridLayout {
  const AppProductGridLayout._();

  static const EdgeInsets padding = EdgeInsets.symmetric(
    horizontal: AppDimens.spacingSm,
    vertical: AppDimens.spacingSm,
  );

  static SliverGridDelegate delegate(BuildContext context) =>
      SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(context),
        childAspectRatio: ResponsiveHelper.getGridChildAspectRatio(context),
        crossAxisSpacing: AppDimens.spacingSm,
        mainAxisSpacing: AppDimens.spacingMd,
      );
}

/// Sliver grid of [AppProductCard]s with optional infinite scroll.
///
/// [onNearEnd] fires (after the frame) when one of the last [loadMoreThreshold]
/// cards is built; the caller is responsible for ignoring duplicate calls.
/// A small spinner is appended while [isLoadingMore] is true.
class AppProductGrid extends StatelessWidget {
  final List<ProductEntity> products;
  final ValueChanged<ProductEntity> onProductTap;
  final String? query;
  final bool isLoadingMore;
  final VoidCallback? onNearEnd;
  final int loadMoreThreshold;
  final EdgeInsetsGeometry padding;

  const AppProductGrid({
    super.key,
    required this.products,
    required this.onProductTap,
    this.query,
    this.isLoadingMore = false,
    this.onNearEnd,
    this.loadMoreThreshold = 4,
    this.padding = AppProductGridLayout.padding,
  });

  @override
  Widget build(BuildContext context) {
    final triggerIndex = (products.length - loadMoreThreshold).clamp(0, products.length);

    return SliverMainAxisGroup(
      slivers: [
        SliverPadding(
          padding: padding,
          sliver: SliverGrid(
            gridDelegate: AppProductGridLayout.delegate(context),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == triggerIndex && onNearEnd != null && !isLoadingMore) {
                  WidgetsBinding.instance.addPostFrameCallback((_) => onNearEnd!());
                }
                final product = products[index];
                return AppProductCard.fromEntity(
                  entity: product,
                  query: query,
                  onTap: () => onProductTap(product),
                );
              },
              childCount: products.length,
              addAutomaticKeepAlives: false,
            ),
          ),
        ),
        if (isLoadingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppDimens.spacingLg),
              child: Center(
                child: SizedBox.square(
                  dimension: 24.0,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
