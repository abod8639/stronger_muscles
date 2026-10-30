import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import '../controllers/support_chat_di.dart';
import '../widgets/support_chat_input_bar.dart';
import '../widgets/support_chat_message_bubble.dart';

class SupportChatPage extends ConsumerStatefulWidget {
  final String ticketId;

  const SupportChatPage({super.key, required this.ticketId});

  @override
  ConsumerState<SupportChatPage> createState() => _SupportChatPageState();
}

class _SupportChatPageState extends ConsumerState<SupportChatPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleSend() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    final notifier =
        ref.read(supportChatControllerProvider(widget.ticketId).notifier);
    final success = await notifier.sendMessage(text);

    if (success && mounted) {
      await Future.delayed(const Duration(milliseconds: 150));
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  // Future<void> _showCloseTicketDialog() async {
  //   final confirmed = await showDialog<bool>(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       title: const Text('إغلاق التذكرة'),
  //       content: const Text('هل تم حل المشكلة وتريد إغلاق تذكرة الدعم الفني هذه؟'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(ctx, false),
  //           child: const Text('إلغاء'),
  //         ),
  //         ElevatedButton(
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: AppColors.primary,
  //             foregroundColor: Colors.white,
  //           ),
  //           onPressed: () => Navigator.pop(ctx, true),
  //           child: const Text('نعم، إغلاق'),
  //         ),
  //       ],
  //     ),
  //   );

  //   if (confirmed == true && mounted) {
  //     final notifier =
  //         ref.read(supportChatControllerProvider(widget.ticketId).notifier);
  //     await notifier.closeTicket();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(supportChatControllerProvider(widget.ticketId));
    final ticket = state.ticket;
    final isDark = context.isDark;

    // Auto-scroll when new messages arrive via WebSocket or polling
    ref.listen<int?>(
      supportChatControllerProvider(widget.ticketId)
          .select((s) => s.ticket?.messages.length),
      (prev, next) {
        if (next != null && (prev == null || next > prev)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
        }
      },
    );

    // Error feedback
    ref.listen<AsyncValue>(
      supportChatControllerProvider(widget.ticketId)
          .select((s) => s.messageState),
      (prev, next) {
        next.whenOrNull(
          error: (error, _) {
            final message =
                error is Failure ? error.toMessage() : error.toString();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        );
      },
    );

    return Scaffold(

      appBar: baseAppBar(
        context, 
        'محادثة الدعم ${widget.ticketId} # ${ticket?.subject}'
        ),
      
      // AppBar(
      //   centerTitle: false,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
      //     onPressed: () {
      //       if (context.canPop()) {
      //         context.pop();
      //       } else {
      //         context.go('/help_support');
      //       }
      //     },
      //   ),
      //   title: ticket == null
      //       ? Text(
      //           'محادثة الدعم #${widget.ticketId}',
      //           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      //         )
      //       : Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Row(
      //               children: [
      //                 Container(
      //                   padding: const EdgeInsets.symmetric(
      //                       horizontal: 6, vertical: 2),
      //                   decoration: BoxDecoration(
      //                     color: AppColors.primary.withValues(alpha: 0.12),
      //                     borderRadius: BorderRadius.circular(6),
      //                   ),
      //                   child: Text(
      //                     ticket.ticketNumber ?? '#${ticket.id}',
      //                     style: const TextStyle(
      //                       fontSize: 11,
      //                       fontWeight: FontWeight.bold,
      //                       color: AppColors.primary,
      //                     ),
      //                   ),
      //                 ),
      //                 const SizedBox(width: 8),
      //                 SupportChatStatusBadge(
      //                   status: ticket.status,
      //                   label: ticket.statusArabic,
      //                 ),
      //               ],
      //             ),
      //             const SizedBox(height: 2),
      //             Text(
      //               ticket.subject,
      //               style: TextStyle(
      //                 fontSize: 14.5,
      //                 fontWeight: FontWeight.bold,
      //                 color: isDark ? AppColors.white : AppColors.black,
      //               ),
      //               maxLines: 1,
      //               overflow: TextOverflow.ellipsis,
      //             ),
      //           ],
      //         ),
      //   actions: [
      //     if (ticket != null && ticket.isOpen)
      //       IconButton(
      //         tooltip: 'إغلاق التذكرة',
      //         icon: const Icon(Icons.check_circle_outline_rounded,
      //             color: AppColors.primary),
      //         onPressed: _showCloseTicketDialog,
      //       ),
      //     const SizedBox(width: 4),
      //   ],
      // ),

      body: Column(
        children: [
          if (state.isLoading && ticket == null)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (state.ticketState.hasError && ticket == null)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: AppColors.error,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.failure?.toMessage() ??
                            'تعذر تحميل تفاصيل تذكرة الدعم',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.white : AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('إعادة المحاولة'),
                        onPressed: () {
                          ref
                              .read(supportChatControllerProvider(widget.ticketId)
                                  .notifier)
                              .loadTicketDetails();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: state.messages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mark_chat_read_outlined,
                            size: 52,
                            color: isDark ? Colors.white24 : Colors.black26,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'لا توجد رسائل سابقة في هذه المحادثة',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? AppColors.grey : AppColors.greyDark,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final msg = state.messages[index];
                        return SupportChatMessageBubble(
                          message: msg,
                          isDark: isDark,
                        );
                      },
                    ),
            ),

          // Bottom Input Bar
          if (ticket != null && ticket.isOpen)
            SupportChatInputBar(
              controller: _messageController,
              isSending: state.isSending,
              onSend: _handleSend,
              isDark: isDark,
            )
          else if (ticket != null && ticket.isClosed)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF3F4F6),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline_rounded,
                      size: 18, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    'تم إغلاق هذه التذكرة. لا يمكن إرسال رسائل جديدة',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

