import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/auth/auth_state_provider.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/core/utils/functions/app_guard.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_channel_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_ticket_entity.dart';
import 'package:stronger_muscles/features/help_support/presentation/controllers/help_support_controller.dart';
import 'package:stronger_muscles/features/help_support/presentation/widgets/contact_channels_section.dart';
import 'package:stronger_muscles/features/help_support/presentation/widgets/faq_categories_chips.dart';
import 'package:stronger_muscles/features/help_support/presentation/widgets/faq_list_section.dart';
import 'package:stronger_muscles/features/help_support/presentation/widgets/help_support_hero_header.dart';
import 'package:stronger_muscles/features/help_support/presentation/widgets/my_tickets_sheet.dart';
import 'package:stronger_muscles/features/help_support/presentation/widgets/still_need_help_card.dart';
import 'package:stronger_muscles/features/help_support/presentation/widgets/submit_ticket_bottom_sheet.dart';
import 'package:stronger_muscles/features/help_support/presentation/widgets/ticket_success_dialog.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

class HelpSupportView extends ConsumerStatefulWidget {
  final String? initialTicketId;
  final String? initialTicketNumber;
  final bool openActiveTicket;

  const HelpSupportView({
    super.key,
    this.initialTicketId,
    this.initialTicketNumber,
    this.openActiveTicket = false,
  });

  @override
  ConsumerState<HelpSupportView> createState() => _HelpSupportViewState();
}

class _HelpSupportViewState extends ConsumerState<HelpSupportView> {
  final _searchController = TextEditingController();
  bool _hasHandledInitialTicket = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndOpenInitialTicket();
    });
  }

  void _checkAndOpenInitialTicket() {
    if (!mounted || _hasHandledInitialTicket) return;

    final isLoggedIn = ref.read(authStateProvider);
    if (!isLoggedIn) return;

    // 1. If explicit ticketId is provided, open its chat immediately
    if (widget.initialTicketId != null && widget.initialTicketId!.isNotEmpty) {
      _hasHandledInitialTicket = true;
      context.push(
        AppRoutes.supportChat,
        extra: {'ticket_id': widget.initialTicketId!},
      );
      return;
    }

    // 2. Open active or matching ticket if already loaded in memory
    if (widget.initialTicketNumber != null || widget.openActiveTicket) {
      final tickets = ref.read(helpSupportControllerProvider).userTickets;
      if (tickets.isNotEmpty) {
        _openMatchingOrActiveTicket(tickets);
      }
    }
  }

  void _openMatchingOrActiveTicket(List<SupportTicketEntity> tickets) {
    if (_hasHandledInitialTicket || !mounted) return;

    SupportTicketEntity? target;
    if (widget.initialTicketNumber != null &&
        widget.initialTicketNumber!.isNotEmpty) {
      for (final t in tickets) {
        if (t.ticketNumber == widget.initialTicketNumber) {
          target = t;
          break;
        }
      }
    }

    if (target == null && widget.openActiveTicket) {
      for (final t in tickets) {
        if (t.isOpen) {
          target = t;
          break;
        }
      }
      target ??= tickets.isNotEmpty ? tickets.first : null;
    }

    if (target != null && target.id != null && target.id!.isNotEmpty) {
      _hasHandledInitialTicket = true;
      context.push(
        AppRoutes.supportChat,
        extra: {'ticket_id': target.id!},
      );
    } else if (widget.openActiveTicket) {
      _hasHandledInitialTicket = true;
      MyTicketsSheet.show(context);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openTicketBottomSheet() async {
    await AppGuard.runSafeAuth(
      ref,
      () async {
        final ticket = await SubmitTicketBottomSheet.show(
          context,
          onSubmit: ({
            required String subject,
            required String category,
            required String message,
            priority = TicketPriority.normal,
          }) async {
            final ticket = await ref
                .read(helpSupportControllerProvider.notifier)
                .submitTicket(
                  subject: subject,
                  category: category,
                  message: message,
                  priority: priority,
                );
            // Surface the controller's failure inline in the sheet.
            final failure = ref.read(helpSupportControllerProvider).failure;
            if (ticket == null && failure != null) throw failure;
            return ticket;
          },
        );

        if (ticket != null && mounted) {
          await TicketSuccessDialog.show(context, ticket);
        }
      },
    );
  }

  void _openMyTickets() {
    AppGuard.runSafeAuth(
      ref,
      () async {
        MyTicketsSheet.show(context);
      },
    );
  }

  Future<void> _onChannelTap(SupportChannelEntity channel) async {
    final l10n = AppLocalizations.of(context)!;
    final opened = await ref
        .read(helpSupportControllerProvider.notifier)
        .launchChannel(channel, _openTicketBottomSheet);

    if (!opened && channel.type != SupportChannelType.ticket && mounted) {
      AppSnackBar.showError(context, '${l10n.couldNotOpenChannel}: ${channel.actionValue}');
    }
  }

  void _resetSearch() {
    _searchController.clear();
    ref.read(helpSupportControllerProvider.notifier).search('');
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<List<SupportTicketEntity>>>(
      helpSupportControllerProvider.select((s) => s.ticketsState),
      (prev, next) {
        final isLoggedIn = ref.read(authStateProvider);
        if (!isLoggedIn) return;

        next.whenData((tickets) {
          if (!_hasHandledInitialTicket &&
              (widget.initialTicketNumber != null || widget.openActiveTicket)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _openMatchingOrActiveTicket(tickets);
            });
          }
        });
      },
    );

    final state = ref.watch(helpSupportControllerProvider);
    final notifier = ref.read(helpSupportControllerProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    final tickets = state.userTickets;
    final unreadTicketsCount = tickets.where((t) => t.unreadMessagesCount > 0).length;

    return Scaffold(
      appBar: baseAppBar(
        context,
        l10n.helpSupport,
        // Deep links (e.g. notifications) can land here with nothing to pop.
        leading: context.canPop()
            ? null
            : IconButton(
                icon: const BackButtonIcon(),
                onPressed: () => context.go(AppRoutes.main),
              ),
        actions: [
          IconButton(
            tooltip: l10n.myTickets,
            onPressed: _openMyTickets,
            icon: Badge(
              backgroundColor: AppColors.primary,
              isLabelVisible: unreadTicketsCount > 0,
              label: Text('$unreadTicketsCount'),
              child: const Icon(Icons.mark_chat_unread_outlined),
            ),
          ),
          const SizedBox(width: AppDimens.spacingSm),
        ],
      ),
      body: state.isLoading && state.faqs.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : state.faqsState.hasError && state.faqs.isEmpty
              ? AppEmptyState(
                  icon: AppErrorCard.iconFor(state.failure),
                  iconColor: AppColors.error,
                  title: l10n.helpLoadError,
                  subtitle: state.failure?.toMessage() ?? l10n.checkConnectionAndRetry,
                  actionText: l10n.retry,
                  actionIcon: Icons.refresh_rounded,
                  onActionTap: notifier.init,
                )
              : RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async {
                    _searchController.clear();
                    await notifier.init();
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.only(bottom: 32.0),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(AppDimens.spacingLg),
                        child: HelpSupportHeroHeader(
                          searchController: _searchController,
                          onSearchChanged: notifier.search,
                        ),
                      ),
                      if (tickets.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppDimens.spacingLg,
                            0,
                            AppDimens.spacingLg,
                            AppDimens.spacingLg,
                          ),
                          child: AppActionCard(
                            icon: Icons.confirmation_number_rounded,
                            iconColor: AppColors.warning,
                            title: l10n.activeTicketsCount(tickets.length),
                            subtitle: l10n.activeTicketsSubtitle,
                            badge: unreadTicketsCount > 0
                                ? AppBadge(
                                    label: l10n.newReply,
                                    color: AppColors.primary,
                                    borderRadius: AppRadius.allPill,
                                  )
                                : null,
                            onTap: _openMyTickets,
                          ),
                        ),
                      ContactChannelsSection(
                        channels: state.channels,
                        onChannelTap: _onChannelTap,
                      ),
                      const SizedBox(height: AppDimens.spacingXl),
                      AppSectionTitle(title: l10n.faqTitle),
                      FaqCategoriesChips(
                        selectedCategory: state.selectedCategory,
                        onSelectCategory: notifier.selectCategory,
                      ),
                      const SizedBox(height: AppDimens.spacingMd),
                      FaqListSection(
                        faqs: state.faqs,
                        onResetSearch: _resetSearch,
                      ),
                      const SizedBox(height: AppDimens.spacingLg + 4),
                      StillNeedHelpCard(
                        onSubmitTicket: _openTicketBottomSheet,
                        onOpenMyTickets: tickets.isNotEmpty ? _openMyTickets : null,
                      ),
                    ],
                  ),
                ),
    );
  }
}
