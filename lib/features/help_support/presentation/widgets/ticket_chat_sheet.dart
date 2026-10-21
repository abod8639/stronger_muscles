import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles/core/components/app_bottom_sheet_handle.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
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
      ref.read(helpSupportControllerProvider.notifier).loadTicketDetails(widget.ticketId);
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
      // Scroll to bottom
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
      helpSupportControllerProvider.select((s) => s.selectedTicket?.messages.length),
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

    final state = ref.watch(helpSupportControllerProvider);
    final ticket = state.selectedTicket;
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
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                          _StatusBadge(status: ticket.status, label: ticket.statusArabic),
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
                    icon: const Icon(Icons.check_circle_outline_rounded, color: AppColors.grey),
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('إغلاق التذكرة'),
                          content: const Text('هل تم حل المشكلة وتريد إغلاق هذه التذكرة؟'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('إلغاء'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('نعم، إغلاق', style: TextStyle(color: AppColors.primary)),
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
          else
            const LinearProgressIndicator(),

          const Divider(height: 20),

          // ── Messages List ──────────────────────────────────────────────────
          Expanded(
            child: state.isLoadingTickets && ticket == null
                ? const Center(child: CircularProgressIndicator())
                : ticket == null || ticket.messages.isEmpty
                    ? Center(
                        child: Text(
                          'لا توجد رسائل بعد',
                          style: TextStyle(color: isDark ? AppColors.grey : AppColors.greyDark),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: ticket.messages.length,
                        itemBuilder: (context, index) {
                          final msg = ticket.messages[index];
                          return _MessageBubble(message: msg, isDark: isDark);
                        },
                      ),
          ),

          // ── Reply Input Box ────────────────────────────────────────────────
          if (ticket != null && !ticket.isClosed) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF3F4F6),
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
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      ),
                      onSubmitted: (_) => _handleSend(),
                    ),
                  ),
                  state.isSendingMessage
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.send_rounded, color: AppColors.primary),
                          onPressed: _handleSend,
                        ),
                ],
              ),
            ),
          ] else if (ticket != null && ticket.isClosed) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'تم إغلاق هذه التذكرة. إذا كانت لديك مشكلة جديدة يرجى فتح تذكرة جديدة.',
                  style: TextStyle(fontSize: 12.5, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
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
    final isUser = message.isUser;
    final timeStr = DateFormat('h:mm a').format(message.createdAt);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isUser
              ? AppColors.primary
              : isDark
                  ? const Color(0xFF2C2C2C)
                  : const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 2),
            bottomRight: Radius.circular(isUser ? 2 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isUser) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.verified_user_rounded, size: 14, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(
                    message.senderName,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
            ],
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
