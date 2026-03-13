import 'package:flutter/material.dart';

class EmptyCartView extends StatelessWidget {
  final VoidCallback onGoShopping;

  const EmptyCartView({super.key, required this.onGoShopping});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: theme.colorScheme.outline.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text('سلتك فارغة', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'ابدأ بالتسوق الآن وأضف بعض المنتجات',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onGoShopping,
            child: const Text('اذهب للتسوق'),
          ),
        ],
      ),
    );
  }
}
