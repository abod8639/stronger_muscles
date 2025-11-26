import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/presentation/bindings/product_details_controller.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/bottom_icons_row.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/image_list_view.dart';

class ProductDetailsView extends StatefulWidget {
  // Constants for consistent sizing and spacing
  static const double _mainImageHeight = 400.0;
  static const double _mainImageBorderRadius = 16.0;
  static const double _contentPadding = 16.0;
  static const double _sectionSpacing = 24.0;
  static const double _smallSpacing = 8.0;
  static const double _mediumSpacing = 16.0;
  static const double _bottomPadding = 32.0;

  final ProductModel product;

  const ProductDetailsView({super.key, required this.product});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  late final ScrollController _imageScrollController;
  late final ProductDetailsController _controller;

  @override
  void initState() {
    super.initState();
    _imageScrollController = ScrollController();
    _controller = Get.put(ProductDetailsController(widget.product));
  }

  @override
  void dispose() {
    _imageScrollController.dispose();
    Get.delete<ProductDetailsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Product Image with Hero Animation
            _buildMainImage(context),

            // Product Details Content
            Padding(
              padding: const EdgeInsets.all(ProductDetailsView._contentPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  _buildProductName(theme),
                  const SizedBox(height: ProductDetailsView._smallSpacing),

                  // Product Price
                  _buildProductPrice(theme),
                  const SizedBox(height: ProductDetailsView._mediumSpacing),

                  // Image Thumbnails
                  if (widget.product.imageUrl.length > 1)
                    ImageListView(
                      scrollController: _imageScrollController,
                      product: widget.product,
                    ),
                  if (widget.product.imageUrl.length > 1)
                    const SizedBox(height: ProductDetailsView._sectionSpacing),

                  // Description Section
                  _buildDescriptionSection(theme),
                  const SizedBox(height: ProductDetailsView._bottomPadding),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomIconsRow(product: widget.product),
    );
  }

  /// Builds the main product image with hero animation and zoom capability
  Widget _buildMainImage(BuildContext context) {
    return Obx(() {
      final selectedIndex = _controller.selectedImageIndex.value;
      final imageUrl = widget.product.imageUrl.isNotEmpty
          ? widget.product.imageUrl[selectedIndex]
          : '';

      return Hero(
        tag: 'product_${widget.product.id}',
        child: GestureDetector(
          onTap: () => _showImageViewer(context, selectedIndex),
          child: Container(
            height: ProductDetailsView._mainImageHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(ProductDetailsView._mainImageBorderRadius),
                bottomRight: Radius.circular(ProductDetailsView._mainImageBorderRadius),
              ),
            ),
            child: imageUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(ProductDetailsView._mainImageBorderRadius),
                      bottomRight: Radius.circular(ProductDetailsView._mainImageBorderRadius),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 64.0,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  )
                : const Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 64.0,
                      color: AppColors.primary,
                    ),
                  ),
          ),
        ),
      );
    });
  }

  /// Builds the product name text
  Widget _buildProductName(ThemeData theme) {
    return Text(
      widget.product.name,
      style: theme.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  /// Builds the product price text
  Widget _buildProductPrice(ThemeData theme) {
    return Text(
      '\$${widget.product.price.toStringAsFixed(2)}',
      style: theme.textTheme.headlineSmall?.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// Builds the description section
  Widget _buildDescriptionSection(ThemeData theme) {
    if (widget.product.description.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: ProductDetailsView._smallSpacing),
        Text(
          widget.product.description,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  /// Shows the image viewer with zoom capability
  void _showImageViewer(BuildContext context, int initialIndex) {
    if (widget.product.imageUrl.isEmpty) return;

    showImageViewer(
      context,
      Image.network(widget.product.imageUrl[initialIndex]).image,
      useSafeArea: true,
      swipeDismissible: true,
      doubleTapZoomable: true,
      immersive: false,
    );
  }
}
