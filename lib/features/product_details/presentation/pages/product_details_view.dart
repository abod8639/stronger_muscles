import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/core/utils/functions/cache_manager.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/product_details/presentation/controllers/product_details_controller.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/bottom_icons_row.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/image_list_view.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/main_image.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/product_detail_sections.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/product_flavor_selector.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/product_price.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/product_reviews_section.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/product_size_selector.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class ProductDetailsView extends ConsumerWidget {

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
    final l10n = AppLocalizations.of(context)!;

    if (product == null) {
      return Scaffold(
        appBar: AppBar(),
        body: AppEmptyState(icon: Icons.inventory_2_outlined, title: l10n.productNotFound),
      );
    }

    final effectiveProd = ProductModel.fromEntity(product!);
    final locale = Localizations.localeOf(context).languageCode;
    final provider = productDetailsControllerProvider(
      effectiveProd,
      initialFlavor: initialFlavor,
      initialSize: initialSize,
    );
    final detailsState = ref.watch(provider);
    final detailsNotifier = ref.read(provider.notifier);
    final name = effectiveProd.getLocalizedName(locale: locale);
    const smallGap = SizedBox(height: AppDimens.spacingSm);
    const gap = SizedBox(height: AppDimens.spacingLg);

    return Scaffold(
      appBar: baseAppBar(context, name),
      bottomNavigationBar: BottomIconsRow(
        product: effectiveProd,
        initialFlavor: initialFlavor,
        initialSize: initialSize,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverToBoxAdapter(
            child: MainImage(
              product: effectiveProd,
              onImageTap: (index) => _showImageViewer(context, effectiveProd, index),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppDimens.spacingLg),
            sliver: SliverList.list(
              children: [
                Text(
                  name,
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.onSurface,
                  ),
                ),
                smallGap,
                ProductPrice(
                  price: detailsState.displayEffectivePrice,
                  originalPrice: detailsState.displayHasDiscount ? detailsState.displayPrice : null,
                ),
                smallGap,
                buildProductBadges(effectiveProd, context, 0.1),
                gap,
                ImageListView(product: effectiveProd),
                if (effectiveProd.flavors.isNotEmpty) ...[
                  gap,
                  ProductFlavorSelector(
                    product: effectiveProd,
                    flavors: detailsNotifier.getCurrentFlavors(effectiveProd),
                    selectedFlavor: detailsState.selectedFlavor,
                    onFlavorSelected: detailsNotifier.updateFlavor,
                  ),
                ],
                if (effectiveProd.productSizes.isNotEmpty) ...[
                  gap,
                  ProductSizeSelector(
                    product: effectiveProd,
                    initialSize: detailsState.selectedSizeObject?.size,
                    onSizeSelected: (size) => detailsNotifier.updateSize(effectiveProd, size),
                  ),
                ],
                gap,
                ProductDescriptionSection(product: effectiveProd),
                gap,
                ProductInfoSection(
                  product: effectiveProd,
                  selectedSize: detailsState.selectedSizeObject,
                ),
                gap,
                ProductIngredientsSection(product: effectiveProd),
                gap,
                ProductUsageSection(product: effectiveProd),
                gap,
                ProductReviewsSection(productId: effectiveProd.id),
                const SizedBox(height: AppDimens.spacingXl),
              ],
            ),
          ),
        ],
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
      backgroundColor: context.colorScheme.surface,
      closeButtonColor: AppColors.primary,
    );
  }
}
