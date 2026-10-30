import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/features/help_support/presentation/controllers/help_support_controller.dart';
import 'package:stronger_muscles/features/help_support/presentation/widgets/support_ticket_card.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

/// Bottom sheet listing the user's support tickets.
class MyTicketsSheet extends ConsumerWidget {
  const MyTicketsSheet({super.key});

  static Future<void> show(BuildContext context) =>
      AppBottomSheetScaffold.show<void>(context, (_) => const MyTicketsSheet());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final ticketsState = ref.watch(
      helpSupportControllerProvider.select((s) => s.ticketsState),
    );
    final notifier = ref.read(helpSupportControllerProvider.notifier);

    return AppBottomSheetScaffold(
      heightFactor: 0.8,
      icon: Icons.confirmation_number_outlined,
      title: l10n.myTickets,
      subtitle: l10n.myTicketsSubtitle,
      trailing: IconButton(
        tooltip: l10n.retry,
        icon: const Icon(Icons.refresh_rounded, size: AppDimens.iconSm),
        onPressed: notifier.loadUserTickets,
      ),
      child: ticketsState.when(
        data: (tickets) => tickets.isEmpty
            ? AppEmptyState(
                icon: Icons.inbox_outlined,
                title: l10n.noTicketsYet,
                subtitle: l10n.noTicketsYetSubtitle,
              )
            : ListView.separated(
                itemCount: tickets.length,
                separatorBuilder: (_, _) => const SizedBox(height: AppDimens.spacingSm + 2),
                itemBuilder: (context, index) {
                  final ticket = tickets[index];
                  return SupportTicketCard(
                    ticket: ticket,
                    onTap: () {
                      Navigator.pop(context);
                      context.push(
                        AppRoutes.supportChat,
                        extra: {'ticket_id': ticket.id ?? ''},
                      );
                    },
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AppEmptyState(
          icon: AppErrorCard.iconFor(error),
          iconColor: AppColors.error,
          title: AppErrorCard.messageFor(error, l10n),
          actionText: l10n.retry,
          actionIcon: Icons.refresh_rounded,
          onActionTap: notifier.loadUserTickets,
        ),
      ),
    );
  }
}
