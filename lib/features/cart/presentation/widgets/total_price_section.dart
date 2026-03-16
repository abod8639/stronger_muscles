import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/features/cart/presentation/controllers/cart_controller.dart';

const double _totalLabelFontSize = 14.0;
const double _totalPriceFontSize = 24.0;
const double _itemCountFontSize = 12.0;
const double _smallSpacing = 4.0;

class TotalPriceSection extends ConsumerWidget {
  const TotalPriceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartControllerProvider);
    final cartNotifier = ref.watch(cartControllerProvider.notifier);
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return cartState.when(
      data: (items) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  localizations.total,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: _totalLabelFontSize,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 8.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 2.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    '${items.length} ${items.length == 1 ? localizations.item : localizations.items}',
                    style: TextStyle(
                      fontSize: _itemCountFontSize,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: _smallSpacing),
            Text(
              '\$${cartNotifier.totalPrice.toStringAsFixed(2)}',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontSize: _totalPriceFontSize,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
