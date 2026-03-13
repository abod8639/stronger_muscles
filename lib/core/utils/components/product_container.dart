import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/home/presentation/widgets/image_section.dart';
import 'package:stronger_muscles/features/home/presentation/widgets/title_and_description.dart';

class ProductContainer extends StatefulWidget {
  const ProductContainer({
    super.key,
    required this.product,
    this.showName,
    this.onPageChanged,
    this.onTap,
    required this.isBackgroundWhite,
  });

  final void Function()? onTap;
  final ProductModel product;
  final bool? showName;
  final bool isBackgroundWhite;
  final ValueChanged<int>? onPageChanged;

  @override
  State<ProductContainer> createState() => _ProductContainerState();
}

class _ProductContainerState extends State<ProductContainer>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
            child: ImageSection(
              widget: widget,
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
                              'LE ${widget.product.baseEffectivePrice}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (widget.product.baseHasDiscount)
                              Text(
                                'LE ${widget.product.formattedPrice}',
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
