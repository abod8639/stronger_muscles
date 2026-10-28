import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles/core/components/app_bottom_sheet_handle.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_message_entity.dart';
import 'package:stronger_muscles/features/help_support/presentation/controllers/help_support_controller.dart';

class TicketChatSheet extends ConsumerStatefulWidget {
  final String ticketId;

  const TicketChatSheet({super.key, required this.ticketId});

  static Future<void> show(BuildContext context, String ticketId) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TicketChatSheet(ticketId: ticketId),
    );
  }

  @override
  ConsumerState<TicketChatSheet> createState() => _TicketChatSheetState();
}

class _TicketChatSheetState extends ConsumerState<TicketChatSheet> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(helpSupportControllerProvider.notifier)
          .loadTicketDetails(widget.ticketId);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    ref.read(helpSupportControllerProvider.notifier).clearSelectedTicket();
    super.dispose();
  }

  Future<void> _handleSend() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    final success = await ref
        .read(helpSupportControllerProvider.notifier)
        .sendReplyMessage(widget.ticketId, text);

    if (success && mounted) {
      await Future.delayed(const Duration(milliseconds: 150));
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Auto-scroll when new messages arrive via WebSocket
    ref.listen<int?>(
      helpSupportControllerProvider
          .select((s) => s.selectedTicket?.messages.length),
      (prev, next) {
        if (next != null && (prev == null || next > prev)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }
      },
    );

    // Listen to message sending failures
    ref.listen<AsyncValue<SupportMessageEntity?>>(
      helpSupportControllerProvider.select((s) => s.messageState),
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

    final selectedTicketState = ref.watch(
      helpSupportControllerProvider.select((s) => s.selectedTicketState),
    );
    final isSendingMessage = ref.watch(
      helpSupportControllerProvider.select((s) => s.isSendingMessage),
    );
    final ticket = selectedTicketState.value;
    final isDark = context.isDark;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final height = MediaQuery.of(context).size.height * 0.85;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: AppRadius.topBottomSheet,
      ),
      padding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, bottomInset + 10.0),
      child: Column(
        children: [
          const BottomSheetHandle(),
          const SizedBox(height: 10),

          // ── Header ────────────────────────────────────────────────────────
          if (ticket != null)
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
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
                          _StatusBadge(
                            status: ticket.status,
                            label: ticket.statusArabic,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ticket.subject,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.white : AppColors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (ticket.isOpen)
                  IconButton(
                    tooltip: 'إغلاق التذكرة',
                    icon: const Icon(Icons.check_circle_outline_rounded,
                        color: AppColors.grey),
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('إغلاق التذكرة'),
                          content: const Text(
                              'هل تم حل المشكلة وتريد إغلاق هذه التذكرة؟'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('إلغاء'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('نعم، إغلاق'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true && mounted) {
                        await ref
                            .read(helpSupportControllerProvider.notifier)
                            .closeTicket(widget.ticketId);
                      }
                    },
                  ),
              ],
            )
          else if (selectedTicketState.isLoading)
            const LinearProgressIndicator()
          else
            const SizedBox.shrink(),

          const Divider(height: 20),

          // ── Messages List with AsyncValue Fallback Handling ────────────────
          Expanded(
            child: selectedTicketState.when(
              data: (activeTicket) {
                if (activeTicket == null || activeTicket.messages.isEmpty) {
                  return Center(
                    child: Text(
                      'لا توجد رسائل بعد',
                      style: TextStyle(
                        color: isDark ? AppColors.grey : AppColors.greyDark,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: activeTicket.messages.length,
                  itemBuilder: (context, index) {
                    final msg = activeTicket.messages[index];
                    return _MessageBubble(message: msg, isDark: isDark);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: AppColors.error,
                        size: 46,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        error is Failure ? error.toMessage() : error.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDark ? AppColors.white : AppColors.black,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('إعادة المحاولة'),
                        onPressed: () {
                          ref
                              .read(helpSupportControllerProvider.notifier)
                              .loadTicketDetails(widget.ticketId);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Reply Input Box ────────────────────────────────────────────────
          if (ticket != null && !ticket.isClosed) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color:
                    isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark ? Colors.white12 : Colors.black12,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      minLines: 1,
                      maxLines: 4,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'اكتب رسالتك لفريق الدعم...',
                        hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      ),
                      onSubmitted: (_) => _handleSend(),
                    ),
                  ),
                  isSendingMessage
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.send_rounded,
                              color: AppColors.primary),
                          onPressed: _handleSend,
                        ),
                ],
              ),
            ),
          ] else if (ticket != null && ticket.isClosed) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline_rounded,
                      size: 18, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    'تم إغلاق هذه التذكرة. لا يمكن إرسال رسائل جديدة',
                    style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final SupportMessageEntity message;
  final bool isDark;

  const _MessageBubble({required this.message, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isFromUser;
    final timeStr = DateFormat('hh:mm a').format(message.createdAt);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? AppColors.primary
              : isDark
                  ? const Color(0xFF262626)
                  : const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isUser)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  message.senderName,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            Text(
              message.message,
              style: TextStyle(
                fontSize: 13.5,
                color: isUser
                    ? Colors.white
                    : isDark
                        ? Colors.white
                        : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              timeStr,
              style: TextStyle(
                fontSize: 10,
                color: isUser
                    ? Colors.white.withValues(alpha: 0.7)
                    : isDark
                        ? Colors.grey[400]
                        : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  final String label;

  const _StatusBadge({required this.status, required this.label});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (status) {
      case 'open':
        bg = Colors.amber.withValues(alpha: 0.15);
        fg = Colors.amber[800]!;
        break;
      case 'in_progress':
        bg = Colors.blue.withValues(alpha: 0.15);
        fg = Colors.blue[700]!;
        break;
      case 'waiting_user':
        bg = Colors.purple.withValues(alpha: 0.15);
        fg = Colors.purple[700]!;
        break;
      case 'resolved':
        bg = Colors.green.withValues(alpha: 0.15);
        fg = Colors.green[700]!;
        break;
      case 'closed':
      default:
        bg = Colors.grey.withValues(alpha: 0.15);
        fg = Colors.grey[700]!;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: fg,
        ),
      ),
    );
  }
}
