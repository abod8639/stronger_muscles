import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/presentation/bindings/product_details_controller.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/bottom_icons_row.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/buildDescriptionSection.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/buildProductName.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/buildProductPrice.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/buildShowReviewsListSection.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/image_list_view.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/main_image.dart';

class ProductDetailsView extends StatefulWidget {
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

  @override
  void initState() {
    super.initState();
    // Initialize the ProductDetailsController with the product
    Get.put(ProductDetailsController(widget.product));
    _imageScrollController = ScrollController();
  }

  @override
  void dispose() {
    _imageScrollController.dispose();
    Get.delete<ProductDetailsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text(widget.product.name), elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Product Image with Hero Animation
            MainImage(
              product: widget.product,
              onImageTap: (index) => _showImageViewer(context, index),
            ),

            // Product Details Content
            Padding(
              padding: const EdgeInsets.all(ProductDetailsView._contentPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  buildProductName(widget.product),
                  const SizedBox(height: ProductDetailsView._smallSpacing),

                  // Product Price
                  buildProductPrice(widget.product),
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
                  buildDescriptionSection(widget.product),
                  const SizedBox(height: ProductDetailsView._bottomPadding),

                  // Reviews Section
                  buildShowReviewsListSection(widget.product),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomIconsRow(product: widget.product),
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      closeButtonColor: Theme.of(context).colorScheme.onSurface,
    );
  }
  
}
