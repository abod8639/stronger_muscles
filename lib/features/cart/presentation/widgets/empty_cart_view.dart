import 'package:flutter/material.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

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
          Text(AppLocalizations.of(context)!.yourCartIsEmpty, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text( 
           AppLocalizations.of(context)!.addProductsToGetStarted,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onGoShopping,
            child:  Text(
              AppLocalizations.of(context)!.startShopping ),
          ),
        ],
      ),
    );
  }
}
