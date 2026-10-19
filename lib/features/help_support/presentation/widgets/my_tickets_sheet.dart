import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles/core/components/app_bottom_sheet_handle.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_ticket_entity.dart';
import 'package:stronger_muscles/features/help_support/presentation/controllers/help_support_controller.dart';
import 'package:stronger_muscles/features/help_support/presentation/widgets/ticket_chat_sheet.dart';

class MyTicketsSheet extends ConsumerWidget {
  const MyTicketsSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const MyTicketsSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(helpSupportControllerProvider);
    final notifier = ref.read(helpSupportControllerProvider.notifier);
    final isDark = context.isDark;
    final height = MediaQuery.of(context).size.height * 0.8;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: AppRadius.topBottomSheet,
      ),
      padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 20.0),
      child: Column(
        children: [
          const BottomSheetHandle(),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.confirmation_number_outlined,
                  color: AppColors.primary,
                  size: 22.0,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تذاكري وبلاغاتي',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.white : AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'متابعة حالة الشكاوى والردود المباشرة من فريق الدعم',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.grey : AppColors.greyDark,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, size: 20),
                onPressed: () => notifier.loadUserTickets(),
              ),
            ],
          ),
          const Divider(height: 24),
          Expanded(
            child: state.isLoadingTickets && state.userTickets.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : state.userTickets.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 54,
                              color: isDark ? Colors.white24 : Colors.black26,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'لا توجد لديك تذاكر دعم سابقة',
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.white : AppColors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'يمكنك إنشاء تذكرة جديدة وسيقوم فريق الدعم بالرد عليك',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.grey : AppColors.greyDark,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: state.userTickets.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final ticket = state.userTickets[index];
                          return _TicketCard(
                            ticket: ticket,
                            isDark: isDark,
                            onTap: () {
                              Navigator.pop(context);
                              TicketChatSheet.show(context, ticket.id ?? '');
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  final SupportTicketEntity ticket;
  final bool isDark;
  final VoidCallback onTap;

  const _TicketCard({
    required this.ticket,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('yyyy/MM/dd • h:mm a').format(ticket.createdAt);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: ticket.unreadMessagesCount > 0
                ? AppColors.primary
                : isDark
                    ? Colors.white10
                    : Colors.black.withValues(alpha: 0.06),
            width: ticket.unreadMessagesCount > 0 ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    ticket.ticketNumber ?? '#${ticket.id}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: ticket.status == 'resolved'
                        ? Colors.green.withValues(alpha: 0.15)
                        : ticket.status == 'waiting_user'
                            ? Colors.purple.withValues(alpha: 0.15)
                            : Colors.blue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    ticket.statusArabic,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: ticket.status == 'resolved'
                          ? Colors.green[700]
                          : ticket.status == 'waiting_user'
                              ? Colors.purple[700]
                              : Colors.blue[700],
                    ),
                  ),
                ),
                const Spacer(),
                if (ticket.unreadMessagesCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'رد جديد',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                else
                  Text(
                    dateStr,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              ticket.subject,
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              ticket.message,
              style: TextStyle(
                fontSize: 12.5,
                color: isDark ? AppColors.grey : AppColors.greyDark,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.category_outlined, size: 13, color: isDark ? Colors.grey[400] : Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  ticket.category,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const Spacer(),
                Text(
                  'انقر للمتابعة والمراسلة ←',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
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
