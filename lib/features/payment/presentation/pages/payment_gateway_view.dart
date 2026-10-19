import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/payment/domain/entities/payment_result_entity.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentGatewayView extends ConsumerWidget {
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
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تعذر فتح بوابة الدفع')),
          );
        }
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('حدث خطأ أثناء فتح بوابة الدفع')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isAr = context.isArabic;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isAr ? 'بوابة الدفع الإلكتروني' : 'Payment Gateway'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimens.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Icon & Header
            Center(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.12),
                ),
                child: const Icon(
                  Icons.lock_clock_outlined,
                  size: 48.0,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              isAr ? 'تم تجهيز جلسة الدفع بنجاح' : 'Payment Session Ready',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6.0),
            Text(
              isAr
                  ? 'يرجى الانتقال لبوابة الدفع الآمنة لإتمام المعاملة'
                  : 'Please proceed to the secure payment portal to finalize transaction',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 24.0),

            // Payment Details Card
            AppCard(
              padding: const EdgeInsets.all(AppDimens.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAr ? 'تفاصيل المعاملة' : 'Transaction Details',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  if (orderId != null)
                    AppInfoRow(
                      label: l10n?.orderId ?? (isAr ? 'رقم الطلب' : 'Order ID'),
                      value: '#$orderId',
                    ),
                  if (amount != null)
                    AppPriceRow(
                      label: isAr ? 'المبلغ المستحق' : 'Amount Due',
                      amount: amount!,
                      isTotal: true,
                    ),
                  if (paymentResult.transactionId.isNotEmpty)
                    AppInfoRow(
                      label: isAr ? 'رقم المعاملة' : 'Transaction ID',
                      value: paymentResult.transactionId,
                    ),
                  if (paymentResult.reference.isNotEmpty)
                    AppInfoRow(
                      label: isAr ? 'الرقم المرجعي' : 'Reference',
                      value: paymentResult.reference,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // Security Badge
            const AppSecureBadge(),
            const SizedBox(height: 28.0),

            // Action Button
            if (paymentResult.hasPaymentUrl)
              AppPrimaryButton(
                text: isAr ? 'الانتقال لبوابة الدفع' : 'Proceed to Payment',
                icon: Icons.open_in_new,
                onPressed: () => _launchPaymentUrl(context),
              ),
          ],
        ),
      ),
    );
  }
}
