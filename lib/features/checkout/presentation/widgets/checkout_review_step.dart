import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/components/components.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/theme/theme.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../cart/cart_feature.dart';
import '../controllers/checkout_controller.dart';
import 'checkout_notes_input.dart';
import 'checkout_price_summary.dart';

/// Step 3: review items, prices, shipping address and payment method.
class CheckoutReviewStep extends ConsumerWidget {
  const CheckoutReviewStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectedAddress = ref.watch(checkoutControllerProvider.select((s) => s.selectedAddress));
    final paymentMethod = ref.watch(checkoutControllerProvider.select((s) => s.selectedPaymentMethod));
    final cartState = ref.watch(cartControllerProvider);
    final mutedStyle = context.textTheme.bodyMedium?.copyWith(
      color: context.colorScheme.onSurfaceVariant,
      height: 1.4,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSectionCard(
          title: l10n.orderSummary,
          icon: Icons.receipt_long_outlined,
          child: cartState.when(
            data: (items) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final item in items)
                  AppOrderItemTile(
                    imageUrl: item.primaryImageUrl,
                    title: item.product.getLocalizedName(locale: l10n.localeName),
                    subtitle: [item.selectedFlavor, item.selectedSize]
                        .whereType<String>()
                        .where((v) => v.isNotEmpty)
                        .join(' • '),
                    quantity: item.quantity,
                    unitPrice: item.product.getEffectivePriceForSize(item.selectedSize),
                    total: item.subtotal,
                  ),
                Divider(height: AppDimens.spacingXl, color: context.colorScheme.outlineVariant),
                CheckoutPriceSummary(
                  cartSubtotal: items.fold(0.0, (sum, item) => sum + item.subtotal),
                ),
              ],
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(AppDimens.spacingLg),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => AppErrorCard(
              error: error,
              onRetry: () => ref.invalidate(cartControllerProvider),
            ),
          ),
        ),
        const SizedBox(height: AppDimens.spacingMd),
        if (selectedAddress != null) ...[
          AppSectionCard(
            title: l10n.shippingTo,
            icon: Icons.location_on_outlined,
            child: Text(selectedAddress.fullAddress, style: mutedStyle),
          ),
          const SizedBox(height: AppDimens.spacingMd),
        ],
        AppSectionCard(
          title: l10n.paymentMethod,
          icon: paymentMethod == 'cash' ? Icons.payments_outlined : Icons.credit_card_outlined,
          child: Text(
            paymentMethod == 'cash' ? l10n.cashOnDelivery : l10n.creditCardOrOnline,
            style: mutedStyle,
          ),
        ),
        const SizedBox(height: AppDimens.spacingMd),
        AppSectionCard(
          title: l10n.notes,
          icon: Icons.sticky_note_2_outlined,
          child: const CheckoutNotesInput(),
        ),
      ],
    );
  }
}
