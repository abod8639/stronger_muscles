import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/components/components.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppPriceRow(label: l10n.subtotal, amount: cartSubtotal),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppDimens.spacingSm),
            child: LinearProgressIndicator(minHeight: 2.0),
          ),
        ],
      ),
      error: (_, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppPriceRow(label: l10n.subtotal, amount: cartSubtotal),
          const SizedBox(height: AppDimens.spacingSm),
          AppAlertCard(
            color: AppColors.error,
            icon: Icons.cloud_off_rounded,
            message: l10n.pricingUnavailable,
            actionLabel: l10n.retry,
            onAction: () => ref.invalidate(checkoutQuoteProvider),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!quote.isAcceptingOrders)
          AppAlertCard(
            color: AppColors.warning,
            icon: Icons.storefront_outlined,
            message: l10n.storeNotAcceptingOrders,
            margin: const EdgeInsets.only(bottom: AppDimens.spacingSm),
          ),
        AppPriceRow(label: l10n.subtotal, amount: quote.subtotal),
        AppPriceRow(
          label: l10n.shippingCost,
          amount: quote.shippingCost,
          valueText: quote.hasFreeDelivery ? l10n.freeDelivery : null,
          valueColor: quote.hasFreeDelivery ? AppColors.success : null,
        ),
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
        const Divider(height: AppDimens.spacingLg),
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
