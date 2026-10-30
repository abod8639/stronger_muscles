import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/features/payment/domain/entities/payment_result_entity.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

/// Presentation page for rendering online payment gateway initiation result and redirection.
class PaymentGatewayView extends StatelessWidget {
  final PaymentResultEntity paymentResult;
  final String? orderId;
  final double? amount;

  const PaymentGatewayView({
    super.key,
    required this.paymentResult,
    this.orderId,
    this.amount,
  });

  Future<void> _launchPaymentUrl(BuildContext context) async {
    final uri = Uri.parse(paymentResult.paymentUrl);
    var opened = false;
    try {
      opened = await canLaunchUrl(uri) && await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      opened = false;
    }
    if (!opened && context.mounted) {
      AppSnackBar.showError(context, AppLocalizations.of(context)!.paymentGatewayOpenFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final orderId = this.orderId;
    final amount = this.amount;

    return Scaffold(
      appBar: baseAppBar(context, l10n.paymentGateway),
      bottomNavigationBar: paymentResult.hasPaymentUrl
          ? AppBottomActionBar(
              child: AppPrimaryButton(
                text: l10n.proceedToPayment,
                icon: Icons.open_in_new_rounded,
                height: 52.0,
                onPressed: () => _launchPaymentUrl(context),
              ),
            )
          : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimens.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimens.spacingSm),
            AppHeroHeader(
              icon: Icons.lock_clock_outlined,
              title: l10n.paymentSessionReady,
              subtitle: l10n.paymentSessionReadySubtitle,
            ),
            const SizedBox(height: AppDimens.spacingXl),
            AppSectionCard(
              title: l10n.transactionDetails,
              icon: Icons.receipt_long_outlined,
              child: Column(
                children: [
                  if (orderId != null) AppInfoRow(label: l10n.orderId, value: '#$orderId'),
                  if (paymentResult.transactionId.isNotEmpty)
                    AppInfoRow(label: l10n.transactionId, value: paymentResult.transactionId),
                  if (paymentResult.reference.isNotEmpty)
                    AppInfoRow(label: l10n.paymentReference, value: paymentResult.reference),
                  if (amount != null) ...[
                    const Divider(height: AppDimens.spacingLg + 4),
                    AppPriceRow(label: l10n.amountDue, amount: amount, isTotal: true),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppDimens.spacingLg),
            const AppSecureBadge(),
            if (!paymentResult.hasPaymentUrl)
              AppAlertCard(
                color: AppColors.error,
                icon: Icons.link_off_rounded,
                message: l10n.paymentLinkUnavailable,
                margin: const EdgeInsets.only(top: AppDimens.spacingLg),
              ),
          ],
        ),
      ),
    );
  }
}
