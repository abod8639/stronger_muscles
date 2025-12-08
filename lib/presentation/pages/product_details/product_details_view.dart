import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/presentation/bindings/product_details_controller.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/bottom_icons_row.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/buildDescriptionSection.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/buildProductName.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/buildProductPrice.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/image_list_view.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/main_image.dart';

class ProductDetailsView extends StatefulWidget {
  // Constants for consistent sizing and spacing
  // static const double _mainImageHeight = 400.0;
  // static const double _mainImageBorderRadius = 16.0;
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
    final theme = Theme.of(context);

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
                  buildProductName(widget.product, theme),
                  const SizedBox(height: ProductDetailsView._smallSpacing),

                  // Product Price
                  buildProductPrice(widget.product, theme),
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
                  buildDescriptionSection(widget.product, theme),
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
      // barrierColor:  Colors.black, // Theme.of(context).colorScheme.onPrimary,
      closeButtonColor: Theme.of(context).colorScheme.onSurface,
    );
  }
}

/// A beautiful expandable description card with animations
class ExpandableDescriptionCard extends StatefulWidget {
  final String description;
  final ThemeData theme;

  const ExpandableDescriptionCard({
    required this.description,
    required this.theme,
  });

  @override
  State<ExpandableDescriptionCard> createState() =>
      ExpandableDescriptionCardState();
}

class ExpandableDescriptionCardState extends State<ExpandableDescriptionCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _iconRotation;

  static const int _collapsedMaxLines = 4;
  static const Duration _animationDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );
    _iconRotation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  widget.theme.colorScheme.surface,
                  widget.theme.colorScheme.surface.withOpacity(0.8),
                ]
              : [
                  widget.theme.colorScheme.surface,
                  widget.theme.colorScheme.primaryContainer.withOpacity(0.1),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and title
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    AppColors.primary.withOpacity(0.05),
                  ],
                ),
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.primary.withOpacity(0.15),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.description_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Product Description',
                    style: widget.theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: widget.theme.colorScheme.onSurface,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),

            // Description content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedCrossFade(
                    firstChild: Text(
                      widget.description,
                      maxLines: _collapsedMaxLines,
                      overflow: TextOverflow.ellipsis,
                      style: widget.theme.textTheme.bodyLarge?.copyWith(
                        color: widget.theme.colorScheme.onSurfaceVariant,
                        height: 1.6,
                        letterSpacing: 0.2,
                      ),
                    ),
                    secondChild: Text(
                      widget.description,
                      style: widget.theme.textTheme.bodyLarge?.copyWith(
                        color: widget.theme.colorScheme.onSurfaceVariant,
                        height: 1.6,
                        letterSpacing: 0.2,
                      ),
                    ),
                    crossFadeState: _isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: _animationDuration,
                  ),

                  // Show "Read more/less" only if text is long enough
                  if (_shouldShowExpandButton())
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: InkWell(
                        onTap: _toggleExpanded,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _isExpanded ? 'Read less' : 'Read more',
                                style: widget.theme.textTheme.bodyMedium
                                    ?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(width: 4),
                              RotationTransition(
                                turns: _iconRotation,
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _shouldShowExpandButton() {
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.description,
        style: widget.theme.textTheme.bodyLarge?.copyWith(
          height: 1.6,
          letterSpacing: 0.2,
        ),
      ),
      maxLines: _collapsedMaxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 64);

    return textPainter.didExceedMaxLines;
  }
}
