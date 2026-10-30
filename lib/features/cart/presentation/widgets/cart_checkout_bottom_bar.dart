import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/cart/presentation/controllers/cart_controller.dart';
import 'package:stronger_muscles/features/cart/presentation/utils/handle_checkout.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Sticky bottom bar with the cart total, item count and the checkout CTA.
class CartCheckoutBottomBar extends ConsumerWidget {
  const CartCheckoutBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final itemCount = ref.watch(
      cartControllerProvider.select((state) => state.valueOrNull?.length ?? 0),
    );
    final totalPrice = ref.watch(
      cartControllerProvider.select(
        (state) => (state.valueOrNull ?? const []).fold<double>(
          0.0,
          (sum, item) => sum + item.subtotal,
        ),
      ),
    );

    return AppBottomActionBar(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                l10n.total,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: AppDimens.spacingSm),
              AppBadge(
                label: '$itemCount ${itemCount == 1 ? l10n.item : l10n.items}',
                color: AppColors.primary,
                alpha: 0.12,
                border: Border.all(color: Colors.transparent),
                borderRadius: AppRadius.allPill,
              ),
              const Spacer(),
              AppPriceText(price: totalPrice, fontSize: 20.0),
            ],
          ),
          const SizedBox(height: AppDimens.spacingMd),
          Semantics(
            label: l10n.proceedToCheckout,
            button: true,
            child: AppPrimaryButton(
              text: l10n.checkout,
              icon: Icons.arrow_forward_rounded,
              height: 52.0,
              onPressed: itemCount == 0 ? null : () => handleCheckout(ref),
            ),
          ),
        ],
      ),
    );
  }
}
