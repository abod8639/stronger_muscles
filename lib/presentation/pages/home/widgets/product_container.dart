
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles/data/models/product_model.dart';

class ProductContainer extends StatelessWidget {
  const ProductContainer({
    super.key,
    required this.product,
    required this.theme,
  });

  final ProductModel product;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6.0)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: product.id,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12.0),
              ),
              child: CachedNetworkImage(
                imageUrl: product.imageUrl.first,
                height: 170,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name.length > 30
                      ? '${product.name.substring(0,21)}...'
                      : product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5.0),
                Text(
                  'LE ${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
