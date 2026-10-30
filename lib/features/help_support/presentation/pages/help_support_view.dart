import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_channel_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_ticket_entity.dart';
import 'package:stronger_muscles/features/help_support/presentation/controllers/help_support_controller.dart';
import 'package:stronger_muscles/features/help_support/presentation/widgets/contact_channels_section.dart';
import 'package:stronger_muscles/features/help_support/presentation/widgets/faq_categories_chips.dart';
import 'package:stronger_muscles/features/help_support/presentation/widgets/faq_list_section.dart';
import 'package:stronger_muscles/features/help_support/presentation/widgets/help_support_hero_header.dart';
import 'package:stronger_muscles/features/help_support/presentation/widgets/my_tickets_sheet.dart';
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
    final ticketNumber = await SubmitTicketBottomSheet.show(
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

        if (ticket == null && mounted) {
          final Failure? failure =
              ref.read(helpSupportControllerProvider).failure;
          final msg = failure?.toMessage() ??
              'تعذر إرسال تذكرة الدعم، يرجى المحاولة لاحقاً';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(msg),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return ticket?.ticketNumber ?? ticket?.id;
      },
    );

    if (ticketNumber != null && mounted) {
      await TicketSuccessDialog.show(
        context,
        ticketNumber,
      );
    }
  }

  void _openMyTickets() {
    MyTicketsSheet.show(context);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<List<SupportTicketEntity>>>(
      helpSupportControllerProvider.select((s) => s.ticketsState),
      (prev, next) {
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
    final l10n = AppLocalizations.of(context);
    final isDark = context.isDark;
    final hasUserTickets = state.userTickets.isNotEmpty;
    final unreadTicketsCount =
        state.userTickets.where((t) => t.unreadMessagesCount > 0).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.helpSupport ?? 'المساعدة والدعم'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20.0),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                tooltip: 'تذاكري وبلاغاتي',
                icon: const Icon(Icons.mark_chat_unread_outlined),
                onPressed: _openMyTickets,
              ),
              if (unreadTicketsCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    constraints:
                        const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '$unreadTicketsCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: state.isLoading && state.faqs.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : state.faqsState.hasError && state.faqs.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          color: AppColors.error,
                          size: 56,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.failure?.toMessage() ??
                              'تعذر تحميل بيانات المساعدة والدعم',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.white : AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'يرجى التحقق من اتصالك بالإنترنت ثم إعادة المحاولة',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color:
                                isDark ? AppColors.grey : AppColors.greyDark,
                          ),
                        ),
                        const SizedBox(height: 24),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.refresh, size: 20),
                          label: const Text('إعادة المحاولة'),
                          style: OutlinedButton.styleFrom(
                            shape: AppRadius.shapeMd,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                          onPressed: () => notifier.init(),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    _searchController.clear();
                    await notifier.init();
                  },
                  color: AppColors.primary,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Hero Banner with Search ──────────────────────────────
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: HelpSupportHeroHeader(
                            searchController: _searchController,
                            onSearchChanged: (query) => notifier.search(query),
                          ),
                        ),

                        // ── Active Tickets Banner if user has open tickets ─────────
                        if (hasUserTickets)
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                            child: InkWell(
                              onTap: _openMyTickets,
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.all(14.0),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isDark
                                        ? [
                                            const Color(0xFF2E2218),
                                            const Color(0xFF1E1712)
                                          ]
                                        : [
                                            const Color(0xFFFFF7ED),
                                            const Color(0xFFFFEDD5)
                                          ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.orange.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.orange
                                            .withValues(alpha: 0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.confirmation_number_rounded,
                                        color: Colors.orange,
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'لديك ${state.userTickets.length} تذكرة دعم وبلاغات',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'انقر لمتابعة حالة الشكاوى والرد على المشرفين',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: isDark
                                                  ? Colors.grey[400]
                                                  : Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 16,
                                        color: Colors.orange),
                                  ],
                                ),
                              ),
                            ),
                          ),

                        // ── Contact Channels ─────────────────────────────────────
                        ContactChannelsSection(
                          channels: state.channels,
                          onChannelTap: (channel) async {
                            final opened = await notifier.launchChannel(
                              channel,
                              _openTicketBottomSheet,
                            );

                            if (!opened &&
                                channel.type != SupportChannelType.ticket &&
                                context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'تعذر فتح قناة التواصل: ${channel.actionValue}'),
                                  backgroundColor: AppColors.error,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                        ),

                        const SizedBox(height: 24.0),

                        // ── FAQ Header ───────────────────────────────────────────
                        SectionTitle(
                          title: l10n?.faqTitle ?? 'الأسئلة الشائعة',
                        ),

                        // ── Categories Chips ─────────────────────────────────────
                        FaqCategoriesChips(
                          selectedCategory: state.selectedCategory,
                          onSelectCategory: (category) =>
                              notifier.selectCategory(category),
                        ),

                        const SizedBox(height: 12.0),

                        // ── FAQ List ─────────────────────────────────────────────
                        FaqListSection(
                          faqs: state.faqs,
                          onResetSearch: () {
                            _searchController.clear();
                            notifier.search('');
                          },
                        ),

                        const SizedBox(height: 20.0),

                        // ── Still Need Help CTA Banner ───────────────────────────
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          child: AppCard(
                            padding: const EdgeInsets.all(20.0),
                            borderRadius: AppRadius.allXl,
                            gradient: LinearGradient(
                              colors: isDark
                                  ? [
                                      const Color(0xFF222222),
                                      const Color(0xFF181818),
                                    ]
                                  : [
                                      const Color(0xFFFFF5F5),
                                      const Color(0xFFFFECEC),
                                    ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              width: 1.0,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.primary.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.headset_mic_rounded,
                                    color: AppColors.primary,
                                    size: 28.0,
                                  ),
                                ),
                                const SizedBox(height: 12.0),
                                Text(
                                  l10n?.stillNeedHelp ?? 'لم تجد إجابة لسؤالك؟',
                                  style: TextStyle(
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? AppColors.white
                                        : AppColors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 6.0),
                                Text(
                                  l10n?.stillNeedHelpSubtitle ??
                                      'فريق الدعم الفني وخبراء التغذية الرياضية جاهزون لمساعدتك',
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    color: isDark
                                        ? AppColors.grey
                                        : AppColors.greyDark,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16.0),
                                Row(
                                  children: [
                                    Expanded(
                                      child: AppPrimaryButton(
                                        text: l10n?.submitTicket ??
                                            'إرسال تذكرة دعم',
                                        icon: Icons.edit_note_rounded,
                                        onPressed: _openTicketBottomSheet,
                                      ),
                                    ),
                                    if (hasUserTickets) ...[
                                      const SizedBox(width: 10),
                                      OutlinedButton.icon(
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          side: const BorderSide(
                                              color: AppColors.primary),
                                        ),
                                        onPressed: _openMyTickets,
                                        icon: const Icon(Icons.history_rounded,
                                            size: 18,
                                            color: AppColors.primary),
                                        label: const Text('تذاكري',
                                            style: TextStyle(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
