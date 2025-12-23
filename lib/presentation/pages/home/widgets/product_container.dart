import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/product_model.dart';

class ProductContainer extends StatefulWidget {
  const ProductContainer({
    super.key,
    required this.product,
    this.showName,
  });

  final ProductModel product;
  final bool? showName;

  @override
  State<ProductContainer> createState() => _ProductContainerState();
}

class _ProductContainerState extends State<ProductContainer> {
  
  late final PageController _pageController;
  final _selectedImageIndex = 0.obs;
  StreamSubscription<int>? _subscription;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);


  }

  @override
  void dispose() {
    _subscription?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.08),
            blurRadius: 15.0,
            offset: const Offset(0, 4),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                ImageSection(
                  product: widget.product,
                  pageController: _pageController, 
                  ),
                // Indicators
                if (widget.showName != null && widget.showName == true)
                  if (widget.product.imageUrl.length > 1)
                    Positioned(
                      bottom: 10.0,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.product.imageUrl.length,
                          (index) => Obx(() {
                            final isActive = _selectedImageIndex.value == index;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 2.0,
                              ),
                              height: 4.0,
                              width: isActive ? 16.0 : 4.0,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.surface.withAlpha(100),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
              ],
            ),
          ),

          // Details Section
          if (widget.showName != null && widget.showName == true)
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.product.name,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          widget.product.description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.5),
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'LE ${widget.product.price.toStringAsFixed(2)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (widget.product.reviews.isNotEmpty)
                          Row(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 16.0,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                (widget.product.reviews
                                            .map((e) => e.rating)
                                            .fold(0.0, (a, b) => a + b) /
                                        widget.product.reviews.length)
                                    .toStringAsFixed(1),
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                ' (${widget.product.reviews.length})',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ImageSection extends StatelessWidget {
  const ImageSection({
    super.key,
    required this.product,
    required PageController pageController,
  }) : _pageController = pageController;

  final ProductModel product;

  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
        final theme = Theme.of(context);
    return GestureDetector(
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
        child: Container(
          width: double.maxFinite,
          color: theme
              .colorScheme
              .surfaceContainerLowest, // Slight background for image
          child: PageView.builder(
            controller: _pageController,
            itemCount: product.imageUrl.length,

            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(
                  8.0,
                ), // Padding for the image inside
                child: CachedNetworkImage(
                  imageUrl: product.imageUrl[index],
                  fit: BoxFit.contain,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.broken_image_outlined,
                    color: theme.colorScheme.error,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
