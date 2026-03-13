import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/features/cart/data/models/cart_item_model.dart';
import 'package:stronger_muscles/features/cart/presentation/controllers/cart_controller.dart';
import 'package:stronger_muscles/core/utils/functions/cache_manager.dart';
import 'package:stronger_muscles/core/utils/components/build_quantity_controls.dart';

class CartItemCard extends ConsumerWidget {
  final CartItemModel item;

  const CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cartNotifier = ref.watch(cartControllerProvider.notifier);

    return InkWell(
      onTap: () => cartNotifier,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  cacheManager: CustomCacheManager.instance,
                  imageUrl: item.product.imageUrls.isNotEmpty
                      ? item.product.imageUrls.first.thumbnail
                      : '',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => const Icon(Icons.image, size: 40),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.getLocalizedName(locale: 'en'),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (item.selectedFlavor != null || item.selectedSize != null)
                      Text(
                        '${item.selectedFlavor ?? ""} ${item.selectedSize ?? ""}',
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      'LE ${item.product.baseEffectivePrice}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              QuantityControls(product: item.product),
            ],
          ),
        ),
      ),
    );
  }

}
