import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class EmptyCartView extends StatelessWidget {
  final VoidCallback onGoShopping;

  const EmptyCartView({super.key, required this.onGoShopping});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: AppDimens.iconXl,
              color: theme.colorScheme.outline.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppDimens.spacingLg),
            Text(
              l10n.yourCartIsEmpty,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.spacingSm),
            Text(
              l10n.addProductsToGetStarted,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.spacingXl),
            ElevatedButton(
              onPressed: onGoShopping,
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: AppDimens.borderRadiusMd,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spacingXl,
                  vertical: AppDimens.spacingMd,
                ),
              ),
              child: Text(l10n.startShopping),
            ),
          ],
        ),
      ),
    );
  }
}
