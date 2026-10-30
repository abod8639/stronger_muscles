import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_ticket_entity.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

/// Confirmation shown after a ticket is submitted, with a shortcut to its chat.
class TicketSuccessDialog extends StatelessWidget {
  final SupportTicketEntity ticket;

  const TicketSuccessDialog({super.key, required this.ticket});

  static Future<void> show(BuildContext context, SupportTicketEntity ticket) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => TicketSuccessDialog(ticket: ticket),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ticketId = ticket.id;

    return Dialog(
      shape: AppRadius.shapeXl,
      backgroundColor: context.colorScheme.surface,
      child: AppEmptyState(
        fillHeight: false,
        padding: const EdgeInsets.all(24.0),
        icon: Icons.check_rounded,
        iconColor: AppColors.success,
        title: l10n.ticketSubmittedTitle,
        subtitle: l10n.ticketSubmittedMessage,
        extra: AppBadge(
          icon: Icons.confirmation_number_outlined,
          label: l10n.ticketNumberLabel(ticket.ticketNumber ?? ticketId ?? ''),
          color: AppColors.primary,
          borderRadius: AppRadius.allMd,
        ),
        actionText: ticketId == null || ticketId.isEmpty ? null : l10n.followTicket,
        actionIcon: Icons.forum_outlined,
        onActionTap: () {
          Navigator.of(context).pop();
          context.push(AppRoutes.supportChat, extra: {'ticket_id': ticketId});
        },
        secondaryActionText: l10n.close,
        onSecondaryActionTap: () => Navigator.of(context).pop(),
      ),
    );
  }
}
