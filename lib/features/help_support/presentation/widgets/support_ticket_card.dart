import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_ticket_entity.dart';
import 'package:stronger_muscles/features/help_support/presentation/utils/help_support_ui.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Summary card for a support ticket: number, status, subject, preview and category.
class SupportTicketCard extends StatelessWidget {
  final SupportTicketEntity ticket;
  final VoidCallback onTap;

  const SupportTicketCard({
    super.key,
    required this.ticket,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = context.textTheme;
    final mutedColor = context.colorScheme.onSurfaceVariant;
    final hasUnread = ticket.unreadMessagesCount > 0;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14.0),
      border: hasUnread ? Border.all(color: AppColors.primary, width: 1.5) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppBadge(
                label: ticket.ticketNumber ?? '#${ticket.id}',
                color: AppColors.primary,
              ),
              const SizedBox(width: AppDimens.spacingSm),
              AppBadge(label: ticket.statusArabic, color: ticket.statusColor),
              const Spacer(),
              if (hasUnread)
                AppBadge(
                  label: l10n?.newReply ?? 'رد جديد',
                  color: AppColors.primary,
                  backgroundColor: AppColors.primary,
                  textColor: AppColors.white,
                  borderRadius: AppRadius.allPill,
                )
              else
                Text(
                  DateFormat('yyyy/MM/dd • h:mm a').format(ticket.createdAt),
                  style: textTheme.bodySmall?.copyWith(fontSize: 10.5, color: mutedColor),
                ),
            ],
          ),
          const SizedBox(height: AppDimens.spacingSm),
          Text(
            ticket.subject,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppDimens.spacingXs),
          Text(
            ticket.message,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(color: mutedColor, height: 1.4),
          ),
          const SizedBox(height: AppDimens.spacingSm),
          Row(
            children: [
              Icon(Icons.category_outlined, size: 14.0, color: mutedColor),
              const SizedBox(width: AppDimens.spacingXs),
              Expanded(
                child: Text(
                  ticket.category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(fontSize: 11.0, color: mutedColor),
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 14.0, color: AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }
}
