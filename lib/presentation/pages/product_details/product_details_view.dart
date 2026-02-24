import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/functions/cache_manager.dart';
import 'package:stronger_muscles/presentation/controllers/product_details_controller.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/bottom_icons_row.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/build_product_price.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/image_list_view.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/product_flavor_selector.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/build_description_section.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/build_product_name.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/build_show_reviews_list_section.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/main_image.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/build_product_badges.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/build_product_info.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/build_ingredients_section.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/build_usage_and_warnings.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/product_size_selector.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  static const double _contentPadding = 16.0;
  static const double _sectionSpacing = 24.0;
  static const double _smallSpacing = 8.0;
  static const double _mediumSpacing = 16.0;
  static const double _bottomPadding = 32.0;

  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final product = Get.find<ProductDetailsController>().product;
    final locale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(product.getLocalizedName(locale: locale)), elevation: 0),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // Main Product Image with Hero Animation
          SliverToBoxAdapter(
            child: MainImage(
              product: product,
              onImageTap: (index) => _showImageViewer(context, index),
            ),
          ),

          // Product Details Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(_contentPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  // Product Name
                  buildProductName(product),
                  const SizedBox(height: _smallSpacing),
                  
                  Obx(() => buildProductPrice(
                    product, 
                    alternateEffectivePrice: controller.displayEffectivePrice,
                    alternateOriginalPrice: controller.displayPrice,
                    alternateHasDiscount: controller.displayHasDiscount,
                  )),
                  const SizedBox(height: _smallSpacing),

                  // Product Badges (Featured, New, Best Seller, Discount)
                  buildProductBadges(product, context),
                  const SizedBox(height: _mediumSpacing),

                  ImageListView(product: product),
                  const SizedBox(height: _mediumSpacing),

                  // Product Flavors
                  if (product.flavors.isNotEmpty) ...[
                    Obx(
                      () => ProductFlavorSelector(
                        product: product,
                        selectedFlavor: controller.selectedFlavor.value,
                        onFlavorSelected: (selectedFlavor) {
                          controller.selectedFlavor.value = selectedFlavor;
                        },
                      ),
                    ),
                    const SizedBox(height: _mediumSpacing),
                  ],

                  // Size Selector
                  if (product.productSizes.isNotEmpty) ...[
                    Obx(
                      () => ProductSizeSelector(
                        product: product,
                        initialSize: controller.selectedSizeObject.value?.size,
                        onSizeSelected: (selectedSize) {
                          controller.updateSize(selectedSize);
                        },
                      ),
                    ),
                    const SizedBox(height: _mediumSpacing),
                  ],

                  if (product.imageUrls.length > 1)
                    const SizedBox(height: _sectionSpacing),

                  // Description Section
                  buildDescriptionSection(product),
                  const SizedBox(height: _sectionSpacing),

                  // Product Info (Brand, SKU, Weight, etc.)
                  buildProductInfo(product, isDark, context),
                  const SizedBox(height: _sectionSpacing),

                  // Ingredients
                  buildIngredientsSection(product, isDark),
                  const SizedBox(height: _sectionSpacing),

                  // Usage Instructions & Warnings
                  buildUsageAndWarnings(product, isDark),
                  const SizedBox(height: _sectionSpacing),

                  // Reviews Section
                  buildShowReviewsListSection(product),
                  const SizedBox(height: _bottomPadding),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomIconsRow(product: product),
    );
  }

  void _showImageViewer(BuildContext context, int initialIndex) {
    if (controller.product.imageUrls.isEmpty) return;

    MultiImageProvider multiImageProvider = MultiImageProvider(
      controller.product.imageUrls
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
