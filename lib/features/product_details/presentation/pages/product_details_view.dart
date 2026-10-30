import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/utils/functions/cache_manager.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/product_details/presentation/controllers/product_details_controller.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/bottom_icons_row.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/build_description_section.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/build_ingredients_section.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/build_product_badges.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/build_product_info.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/build_product_name.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/build_product_price.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/build_show_reviews_list_section.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/build_usage_and_warnings.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/image_list_view.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/main_image.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/product_flavor_selector.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/product_size_selector.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class ProductDetailsView extends ConsumerWidget {
  static const double _contentPadding = 16.0;
  static const double _sectionSpacing = 24.0;
  static const double _smallSpacing = 8.0;
  static const double _mediumSpacing = 16.0;
  static const double _bottomPadding = 32.0;

  final ProductEntity? product;
  final String? initialFlavor;
  final String? initialSize;

  const ProductDetailsView({
    super.key,
    this.product,
    this.initialFlavor,
    this.initialSize,
  });

  /// Convenience constructor allowing callers with [ProductModel] to initialize cleanly.
  factory ProductDetailsView.fromModel({
    Key? key,
    required ProductModel model,
    String? initialFlavor,
    String? initialSize,
  }) {
    return ProductDetailsView(
      key: key,
      product: model.toEntity(),
      initialFlavor: initialFlavor,
      initialSize: initialSize,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (product == null) {
      return Scaffold(
        body: Center(
          child: Text(
            AppLocalizations.of(context)?.productNotFound ??
                "Product not found",
          ),
        ),
      );
    }

    final effectiveProd = ProductModel.fromEntity(product!);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = Localizations.localeOf(context).languageCode;

    final detailsState = ref.watch(
      productDetailsControllerProvider(
        effectiveProd,
        initialFlavor: initialFlavor,
        initialSize: initialSize,
      ),
    );
    final detailsNotifier = ref.watch(
      productDetailsControllerProvider(
        effectiveProd,
        initialFlavor: initialFlavor,
        initialSize: initialSize,
      ).notifier,
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(effectiveProd.getLocalizedName(locale: locale)),
        elevation: 0,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: MainImage(
              product: effectiveProd,
              onImageTap: (index) =>
                  _showImageViewer(context, effectiveProd, index),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(_contentPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildProductName(effectiveProd),
                  const SizedBox(height: _smallSpacing),
                  buildProductPrice(
                    effectiveProd,
                    alternateEffectivePrice: detailsState.displayEffectivePrice,
                    alternateOriginalPrice: detailsState.displayPrice,
                    alternateHasDiscount: detailsState.displayHasDiscount,
                  ),
                  const SizedBox(height: _smallSpacing),
                  buildProductBadges(effectiveProd, context, .1),
                  const SizedBox(height: _mediumSpacing),
                  ImageListView(product: effectiveProd),
                  const SizedBox(height: _mediumSpacing),
                  if (effectiveProd.flavors.isNotEmpty) ...[
                    ProductFlavorSelector(
                      product: effectiveProd,
                      selectedFlavor: detailsState.selectedFlavor,
                      onFlavorSelected: (selectedFlavor) {
                        detailsNotifier.updateFlavor(selectedFlavor);
                      },
                    ),
                    const SizedBox(height: _mediumSpacing),
                  ],
                  if (effectiveProd.productSizes.isNotEmpty) ...[
                    ProductSizeSelector(
                      product: effectiveProd,
                      initialSize: detailsState.selectedSizeObject?.size,
                      onSizeSelected: (selectedSize) {
                        detailsNotifier.updateSize(effectiveProd, selectedSize);
                      },
                    ),
                    const SizedBox(height: _mediumSpacing),
                  ],
                  if (effectiveProd.imageUrls.length > 1)
                    const SizedBox(height: _sectionSpacing),
                  buildDescriptionSection(effectiveProd),
                  const SizedBox(height: _sectionSpacing),
                  buildProductInfo(effectiveProd, isDark, context, ref),
                  const SizedBox(height: _sectionSpacing),
                  buildIngredientsSection(effectiveProd, isDark),
                  const SizedBox(height: _sectionSpacing),
                  buildUsageAndWarnings(effectiveProd, isDark),
                  const SizedBox(height: _sectionSpacing),
                  buildShowReviewsListSection(effectiveProd),
                  const SizedBox(height: _bottomPadding),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomIconsRow(
        product: effectiveProd,
        initialFlavor: initialFlavor,
        initialSize: initialSize,
      ),
    );
  }

  void _showImageViewer(
    BuildContext context,
    ProductModel currentProduct,
    int initialIndex,
  ) {
    if (currentProduct.imageUrls.isEmpty) return;

    final multiImageProvider = MultiImageProvider(
      currentProduct.imageUrls
          .map(
            (url) => CachedNetworkImageProvider(
              url.original,
              cacheManager: CustomCacheManager.instance,
            ),
          )
          .toList(),
      initialIndex: initialIndex,
    );

    showImageViewerPager(
      context,
      multiImageProvider,
      useSafeArea: true,
      swipeDismissible: true,
      doubleTapZoomable: true,
      immersive: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      closeButtonColor: Theme.of(context).primaryColor,
    );
  }
}
