import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_ticket_entity.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import '../controllers/support_chat_controller.dart';
import '../controllers/support_chat_di.dart';
import '../widgets/support_chat_message_bubble.dart';
import '../widgets/support_chat_status_badge.dart';

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

  Widget _buildMessages(SupportChatState state, AppLocalizations l10n) {
    final ticket = state.ticket;

    if (state.isLoading && ticket == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.ticketState.hasError && ticket == null) {
      return AppEmptyState(
        icon: AppErrorCard.iconFor(state.failure),
        iconColor: AppColors.error,
        title: l10n.supportChatLoadError,
        subtitle: state.failure?.toMessage() ?? l10n.checkConnectionAndRetry,
        actionText: l10n.retry,
        actionIcon: Icons.refresh_rounded,
        onActionTap: ref
            .read(supportChatControllerProvider(widget.ticketId).notifier)
            .loadTicketDetails,
      );
    }

    if (state.messages.isEmpty) {
      return AppEmptyState(
        icon: Icons.forum_outlined,
        title: l10n.supportChatEmpty,
        subtitle: ticket?.isOpen == true ? l10n.supportChatEmptySubtitle : null,
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      itemCount: state.messages.length,
      itemBuilder: (context, index) =>
          SupportChatMessageBubble(message: state.messages[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(supportChatControllerProvider(widget.ticketId));
    final ticket = state.ticket;

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
          error: (error, _) => AppSnackBar.showError(
            context,
            AppErrorCard.messageFor(error, l10n),
          ),
        );
      },
    );

    return Scaffold(
      appBar: baseAppBar(
        context,
        l10n.ticketNumberLabel(ticket?.ticketNumber ?? widget.ticketId),
      ),
      body: Column(
        children: [
          if (ticket != null) _TicketHeader(ticket: ticket),
          Expanded(child: _buildMessages(state, l10n)),
          if (ticket != null && ticket.isOpen)
            AppChatComposer(
              controller: _messageController,
              isSending: state.isSending,
              onSend: _handleSend,
              hintText: l10n.supportChatInputHint,
              sendTooltip: l10n.sendMessage,
            )
          else if (ticket != null && ticket.isClosed)
            SafeArea(
              top: false,
              child: AppAlertCard(
                color: AppColors.grey,
                icon: Icons.lock_outline_rounded,
                message: l10n.ticketClosedNotice,
                margin: const EdgeInsets.all(12.0),
              ),
            ),
        ],
      ),
    );
  }
}

/// Ticket subject and current status, pinned under the app bar.
class _TicketHeader extends StatelessWidget {
  final SupportTicketEntity ticket;

  const _TicketHeader({required this.ticket});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 12.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              ticket.subject,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          SupportChatStatusBadge(
            status: ticket.status,
            label: ticket.statusArabic,
          ),
        ],
      ),
    );
  }
}
