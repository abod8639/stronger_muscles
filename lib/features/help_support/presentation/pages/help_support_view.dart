import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/core/utils/components/app_card.dart';
import 'package:stronger_muscles/core/utils/components/section_title.dart';
import 'package:stronger_muscles/features/help_support/presentation/controllers/help_support_controller.dart';
import 'package:stronger_muscles/features/help_support/presentation/widgets/contact_channels_section.dart';
import 'package:stronger_muscles/features/help_support/presentation/widgets/faq_categories_chips.dart';
import 'package:stronger_muscles/features/help_support/presentation/widgets/faq_list_section.dart';
import 'package:stronger_muscles/features/help_support/presentation/widgets/help_support_hero_header.dart';
import 'package:stronger_muscles/features/help_support/presentation/widgets/submit_ticket_bottom_sheet.dart';
import 'package:stronger_muscles/features/help_support/presentation/widgets/ticket_success_dialog.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_ticket_entity.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class HelpSupportView extends ConsumerStatefulWidget {
  const HelpSupportView({super.key});

  @override
  ConsumerState<HelpSupportView> createState() => _HelpSupportViewState();
}

class _HelpSupportViewState extends ConsumerState<HelpSupportView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openTicketBottomSheet() {
    SubmitTicketBottomSheet.show(
      context,
      onSubmit: ({
        required String subject,
        required String category,
        required String message,
        priority = TicketPriority.normal,
      }) async {
        final ticketId = await ref
            .read(helpSupportControllerProvider.notifier)
            .submitTicket(
              subject: subject,
              category: category,
              message: message,
              priority: priority,
            );

        if (ticketId != null && mounted) {
          TicketSuccessDialog.show(context, ticketId);
        }
        return ticketId;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(helpSupportControllerProvider);
    final notifier = ref.read(helpSupportControllerProvider.notifier);
    final l10n = AppLocalizations.of(context);
    final isDark = context.isDark;

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
      ),
      body: state.isLoading && state.faqs.isEmpty
          ? const Center(child: CircularProgressIndicator())
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

                    // ── Contact Channels ─────────────────────────────────────
                    ContactChannelsSection(
                      channels: state.channels,
                      onChannelTap: (channel) {
                        notifier.launchChannel(
                          context,
                          channel,
                          onOpenTicket: _openTicketBottomSheet,
                        );
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
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                                color: AppColors.primary.withValues(alpha: 0.1),
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
                                color: isDark ? AppColors.white : AppColors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6.0),
                            Text(
                              l10n?.stillNeedHelpSubtitle ??
                                  'فريق الدعم الفني وخبراء التغذية الرياضية جاهزون لمساعدتك',
                              style: TextStyle(
                                fontSize: 13.0,
                                color: isDark ? AppColors.grey : AppColors.greyDark,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16.0),
                            AppPrimaryButton(
                              text: l10n?.submitTicket ?? 'إرسال تذكرة دعم',
                              icon: Icons.edit_note_rounded,
                              onPressed: _openTicketBottomSheet,
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
