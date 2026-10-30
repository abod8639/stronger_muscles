import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/core/services/websocket_service.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_message_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_ticket_entity.dart';
import '../../domain/usecases/close_ticket_chat_usecase.dart';
import '../../domain/usecases/get_ticket_chat_details_usecase.dart';
import '../../domain/usecases/send_ticket_chat_message_usecase.dart';

@immutable
class SupportChatState {
  final AsyncValue<SupportTicketEntity?> ticketState;
  final AsyncValue<SupportMessageEntity?> messageState;
  final bool isClosingTicket;

  const SupportChatState({
    this.ticketState = const AsyncLoading(),
    this.messageState = const AsyncData(null),
    this.isClosingTicket = false,
  });

  SupportTicketEntity? get ticket => ticketState.value;
  List<SupportMessageEntity> get messages => ticket?.messages ?? const [];
  bool get isLoading => ticketState.isLoading;
  bool get isSending => messageState.isLoading;

  Failure? get failure {
    final err = ticketState.error ?? messageState.error;
    if (err is Failure) return err;
    if (err != null) return GeneralFailure(message: err.toString());
    return null;
  }

  SupportChatState copyWith({
    AsyncValue<SupportTicketEntity?>? ticketState,
    AsyncValue<SupportMessageEntity?>? messageState,
    bool? isClosingTicket,
  }) {
    return SupportChatState(
      ticketState: ticketState ?? this.ticketState,
      messageState: messageState ?? this.messageState,
      isClosingTicket: isClosingTicket ?? this.isClosingTicket,
    );
  }
}

class SupportChatNotifier extends StateNotifier<SupportChatState> {
  final String ticketId;
  final GetTicketChatDetailsUseCase _getTicketDetailsUseCase;
  final SendTicketChatMessageUseCase _sendMessageUseCase;
  final CloseTicketChatUseCase _closeTicketUseCase;
  final WebSocketService _webSocketService;

  final List<StreamSubscription> _subscriptions = [];
  Timer? _pollingTimer;
  bool _isDisposed = false;

  SupportChatNotifier({
    required this.ticketId,
    required GetTicketChatDetailsUseCase getTicketDetailsUseCase,
    required SendTicketChatMessageUseCase sendMessageUseCase,
    required CloseTicketChatUseCase closeTicketUseCase,
    WebSocketService? webSocketService,
  })  : _getTicketDetailsUseCase = getTicketDetailsUseCase,
        _sendMessageUseCase = sendMessageUseCase,
        _closeTicketUseCase = closeTicketUseCase,
        _webSocketService = webSocketService ?? WebSocketService(),
        super(const SupportChatState()) {
    init();
  }

  Future<void> init() async {
    await loadTicketDetails();
    _subscribeToRealtime();
    _startPolling();
  }

  /// Loads ticket and message history. Supports non-blocking silent refresh.
  Future<void> loadTicketDetails({bool isSilentRefresh = false}) async {
    if (_isDisposed) return;

    if (!isSilentRefresh && state.ticket == null) {
      state = state.copyWith(ticketState: const AsyncLoading());
    }

    final result = await _getTicketDetailsUseCase(ticketId);
    if (_isDisposed) return;

    result.fold(
      (failure) {
        if (!isSilentRefresh) {
          state = state.copyWith(
            ticketState: AsyncError(
              failure,
              failure.stackTrace ?? StackTrace.current,
            ),
          );
        }
      },
      (freshTicket) {
        final current = state.ticket;
        if (isSilentRefresh && current != null) {
          final hasNewMessages =
              freshTicket.messages.length != current.messages.length;
          final statusChanged = freshTicket.status != current.status;
          if (hasNewMessages || statusChanged) {
            state = state.copyWith(ticketState: AsyncData(freshTicket));
          }
        } else {
          state = state.copyWith(ticketState: AsyncData(freshTicket));
        }
      },
    );
  }

  /// Establishes WebSocket subscription to listen for new incoming messages.
  void _subscribeToRealtime() {
    try {
      final channel = _webSocketService.subscribeToTicket(ticketId);

      final sub = channel.bindToAll().listen((event) {
        final eventName = event.name;
        if (eventName.contains('SupportMessageSent')) {
          _handleIncomingMessageEvent(event);
        } else if (eventName.contains('SupportTicketUpdated')) {
          _handleIncomingTicketUpdatedEvent(event);
        }
      });

      _subscriptions.add(sub);
    } catch (e) {
      debugPrint('Realtime error on ticket $ticketId: $e');
    }
  }

  void _handleIncomingMessageEvent(dynamic event) {
    if (_isDisposed) return;
    final map = event.tryGetDataAsMap();
    if (map != null && map['message'] is Map) {
      final rawMsg = Map<String, dynamic>.from(map['message'] as Map);
      final newMsg = SupportMessageEntity(
        id: rawMsg['id'] is int
            ? rawMsg['id'] as int
            : int.tryParse(rawMsg['id']?.toString() ?? '0') ?? 0,
        ticketId: rawMsg['ticket_id'] is int
            ? rawMsg['ticket_id'] as int
            : int.tryParse(rawMsg['ticket_id']?.toString() ?? '0') ?? 0,
        senderType: (rawMsg['sender_type'] ?? 'user').toString(),
        senderName: (rawMsg['sender_name'] ?? 'مستخدم').toString(),
        message: (rawMsg['message'] ?? '').toString(),
        createdAt: rawMsg['created_at'] != null
            ? DateTime.tryParse(rawMsg['created_at'].toString()) ??
                DateTime.now()
            : DateTime.now(),
        isRead: rawMsg['is_read'] == true || rawMsg['is_read'] == 1,
      );

      final current = state.ticket;
      if (current != null) {
        final exists = current.messages.any((m) => m.id == newMsg.id);
        if (!exists) {
          final updatedMsgs =
              List<SupportMessageEntity>.from(current.messages)..add(newMsg);
          final updatedTicket = current.copyWith(
            messages: updatedMsgs,
            messagesCount: current.messagesCount + 1,
            lastReplyAt: newMsg.createdAt,
          );
          state = state.copyWith(ticketState: AsyncData(updatedTicket));
        }
      } else {
        loadTicketDetails(isSilentRefresh: true);
      }
    }
  }

  void _handleIncomingTicketUpdatedEvent(dynamic event) {
    if (_isDisposed) return;
    final map = event.tryGetDataAsMap();
    if (map != null && map['ticket'] is Map) {
      final rawTicket = Map<String, dynamic>.from(map['ticket'] as Map);
      final newStatus = rawTicket['status']?.toString();
      final newPriority = rawTicket['priority']?.toString();
      final current = state.ticket;
      if (current != null) {
        final updatedTicket = current.copyWith(
          status: newStatus ?? current.status,
          priority: newPriority != null
              ? TicketPriority.fromString(newPriority)
              : current.priority,
        );
        state = state.copyWith(ticketState: AsyncData(updatedTicket));
      }
    }
  }

  /// Starts a silent fallback polling timer every 2.5 seconds.
  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(milliseconds: 2500), (_) {
      if (!_isDisposed) {
        loadTicketDetails(isSilentRefresh: true);
      }
    });
  }

  /// Sends a reply inside this conversation.
  Future<bool> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isSending || _isDisposed) return false;

    state = state.copyWith(messageState: const AsyncLoading());

    final result = await _sendMessageUseCase(
      ticketId: ticketId,
      message: trimmed,
    );

    if (_isDisposed) return false;

    return result.fold(
      (failure) {
        state = state.copyWith(
          messageState: AsyncError(
            failure,
            failure.stackTrace ?? StackTrace.current,
          ),
        );
        return false;
      },
      (sentMsg) {
        state = state.copyWith(messageState: AsyncData(sentMsg));
        loadTicketDetails(isSilentRefresh: true);
        return true;
      },
    );
  }

  /// Closes this ticket conversation.
  Future<bool> closeTicket() async {
    if (state.isClosingTicket || _isDisposed) return false;

    state = state.copyWith(isClosingTicket: true);

    final result = await _closeTicketUseCase(ticketId);
    if (_isDisposed) return false;

    return result.fold(
      (failure) {
        state = state.copyWith(
          isClosingTicket: false,
          ticketState: AsyncError(
            failure,
            failure.stackTrace ?? StackTrace.current,
          ),
        );
        return false;
      },
      (closedTicket) {
        state = state.copyWith(
          isClosingTicket: false,
          ticketState: AsyncData(closedTicket),
        );
        return true;
      },
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    _pollingTimer?.cancel();
    _pollingTimer = null;
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
    _webSocketService.unsubscribeFromTicket(ticketId);
    super.dispose();
  }
}
