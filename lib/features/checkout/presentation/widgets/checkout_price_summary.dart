import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/components/components.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/theme.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/checkout_quote.dart';
import '../controllers/checkout_controller.dart';

/// Subtotal, delivery fee, tax and grand total for the review step, priced by
/// the server so the total shown is the total the customer is charged.
class CheckoutPriceSummary extends ConsumerWidget {
  const CheckoutPriceSummary({super.key, required this.cartSubtotal});

  /// Locally computed products subtotal, shown while the quote is loading or unavailable.
  final double cartSubtotal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final quoteState = ref.watch(checkoutQuoteProvider);

    return quoteState.when(
      data: (quote) => quote == null
          ? const SizedBox.shrink()
          : _QuoteRows(quote: quote),
      loading: () => Column(
        children: [
          AppPriceRow(label: l10n.subtotal, amount: cartSubtotal),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: LinearProgressIndicator(minHeight: 2.0),
          ),
        ],
      ),
      error: (_, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppPriceRow(label: l10n.subtotal, amount: cartSubtotal),
          InkWell(
            borderRadius: AppRadius.allSm,
            onTap: () => ref.invalidate(checkoutQuoteProvider),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.refresh,
                    size: 18.0,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      l10n.pricingUnavailable,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
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

class _QuoteRows extends StatelessWidget {
  const _QuoteRows({required this.quote});

  final CheckoutQuote quote;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!quote.isAcceptingOrders)
          Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
              borderRadius: AppRadius.allMd,
            ),
            child: Text(
              l10n.storeNotAcceptingOrders,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        AppPriceRow(label: l10n.subtotal, amount: quote.subtotal),
        if (quote.hasFreeDelivery)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.shippingCost,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  l10n.freeDelivery,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )
        else
          AppPriceRow(label: l10n.shippingCost, amount: quote.shippingCost),
        if (quote.taxAmount > 0)
          AppPriceRow(
            label: '${l10n.tax} (${_formatRate(quote.taxRate)}%)',
            amount: quote.taxAmount,
          ),
        if (quote.discount > 0)
          AppPriceRow(
            label: l10n.discount,
            amount: quote.discount,
            isDiscount: true,
          ),
        const Divider(height: 16.0),
        AppPriceRow(
          label: l10n.totalAmount,
          amount: quote.totalAmount,
          isTotal: true,
        ),
      ],
    );
  }

  static String _formatRate(double rate) {
    return rate == rate.truncateToDouble()
        ? rate.toStringAsFixed(0)
        : rate.toString();
  }
}
