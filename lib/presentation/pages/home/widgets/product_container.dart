import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/image_indicators.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/image_section.dart';
import 'package:stronger_muscles/presentation/pages/home/widgets/title_and_description.dart';

class ProductContainer extends StatefulWidget {
  const ProductContainer({
    super.key,
    required this.product,
    this.showName,
    this.selectedImageIndex,
    this.onPageChanged,
    this.onTap,
  });

  final void Function()? onTap;
  final ProductModel product;
  final bool? showName;
  final RxInt? selectedImageIndex;
  final ValueChanged<int>? onPageChanged;
  @override
  State<ProductContainer> createState() => _ProductContainerState();
}

class _ProductContainerState extends State<ProductContainer> {
  late final RxInt _selectedImageIndex;
  late final PageController _pageController;
  StreamSubscription<int>? _subscription;

  @override
  void initState() {
    super.initState();
    _selectedImageIndex = widget.selectedImageIndex ?? 0.obs;
    _pageController = PageController(initialPage: _selectedImageIndex.value);

    if (widget.selectedImageIndex != null) {
      _subscription = widget.selectedImageIndex!.listen((index) {
        if (_pageController.hasClients &&
            _pageController.page?.round() != index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
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
                  widget: widget,
                  theme: theme,
                  pageController: _pageController, 
                  selectedImageIndex: _selectedImageIndex
                  ),
                // Indicators
                if (widget.showName != null && widget.showName == true)
                  if (widget.product.imageUrls.length > 1)
                    ImageIndicators(
                      product: widget.product, 
                      selectedImageIndex: _selectedImageIndex
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
                    TitleAndDescription(product: widget.product),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                 Wrap(
          spacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              'LE ${widget.product.effectivePrice.toStringAsFixed(2)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (widget.product.hasDiscount)
              Text(
                'LE ${widget.product.price.toStringAsFixed(2)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
          ],
        ),
                        if (widget.product.reviewCount > 0)
                          Row(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 16.0,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                widget.product.averageRating.toStringAsFixed(1),
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                ' (${widget.product.reviewCount})',
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
