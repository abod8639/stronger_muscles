import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/cart/presentation/controllers/cart_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

const double _totalLabelFontSize = 14.0;
const double _totalPriceFontSize = 21.0;
const double _itemCountFontSize = 12.0;

/// Total price and item count section for the bottom checkout bar.
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
                const SizedBox(width: AppDimens.spacingSm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 2.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: .12),
                    borderRadius: AppRadius.allPill,
                  ),
                  child: Text(
                    '${items.length} ${items.length == 1 ? localizations.item : localizations.items}',
                    style: const TextStyle(
                      fontSize: _itemCountFontSize,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2.0),
            Text(
              'LE ${cartNotifier.totalPrice.toStringAsFixed(2)}',
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
