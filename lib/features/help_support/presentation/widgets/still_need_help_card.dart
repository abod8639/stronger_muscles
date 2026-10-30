import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Bottom call-to-action: open a new ticket, or jump to existing ones.
class StillNeedHelpCard extends StatelessWidget {
  final VoidCallback onSubmitTicket;
  final VoidCallback? onOpenMyTickets;

  const StillNeedHelpCard({
    super.key,
    required this.onSubmitTicket,
    this.onOpenMyTickets,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCard(
      margin: const EdgeInsets.symmetric(horizontal: AppDimens.spacingLg),
      borderRadius: AppRadius.allXl,
      color: AppColors.primary.withValues(alpha: context.isDark ? 0.08 : 0.04),
      boxShadow: const [],
      border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      child: AppEmptyState(
        fillHeight: false,
        padding: const EdgeInsets.all(AppDimens.spacingLg + 4),
        icon: Icons.headset_mic_rounded,
        title: l10n?.stillNeedHelp ?? 'لم تجد إجابة لسؤالك؟',
        subtitle: l10n?.stillNeedHelpSubtitle,
        actionText: l10n?.submitTicket ?? 'إرسال تذكرة دعم',
        actionIcon: Icons.edit_note_rounded,
        onActionTap: onSubmitTicket,
        secondaryActionText: onOpenMyTickets == null ? null : l10n?.myTickets,
        onSecondaryActionTap: onOpenMyTickets,
      ),
    );
  }
}
