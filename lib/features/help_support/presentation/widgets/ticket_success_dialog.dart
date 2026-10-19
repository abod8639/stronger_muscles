import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/help_support/presentation/widgets/ticket_chat_sheet.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class TicketSuccessDialog extends StatelessWidget {
  final String ticketId;

  const TicketSuccessDialog({
    super.key,
    required this.ticketId,
  });

  static Future<void> show(BuildContext context, String ticketId) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => TicketSuccessDialog(ticketId: ticketId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = context.isDark;

    return Dialog(
      shape: AppRadius.shapeXl,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 42,
              ),
            ),
            const SizedBox(height: 18.0),
            Text(
              l10n?.ticketSubmittedTitle ?? 'تم إرسال تذكرتك بنجاح!',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : AppColors.greyLight,
                borderRadius: AppRadius.allMd,
                border: Border.all(
                  color: isDark ? Colors.white12 : AppColors.greyMedium,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.confirmation_number_outlined,
                      size: 16.0, color: AppColors.primary),
                  const SizedBox(width: 8.0),
                  Text(
                    'رقم التذكرة: $ticketId',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14.0),
            Text(
              l10n?.ticketSubmittedMessage ??
                  'شكراً لتواصلك معنا. سيقوم فريق الدعم بالرد عليك في أقرب وقت وستصلك إشعارات بالرد.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.45,
                color: isDark ? AppColors.grey : AppColors.greyDark,
              ),
            ),
            const SizedBox(height: 24.0),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('إغلاق'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppPrimaryButton(
                    text: 'متابعة التذكرة',
                    onPressed: () {
                      Navigator.of(context).pop();
                      TicketChatSheet.show(context, ticketId);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
