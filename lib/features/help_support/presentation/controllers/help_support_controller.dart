import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/websocket_service.dart';
import '../../domain/entities/faq_entity.dart';
import '../../domain/entities/support_channel_entity.dart';
import '../../domain/entities/support_message_entity.dart';
import '../../domain/entities/support_ticket_entity.dart';
import '../../domain/usecases/close_ticket_usecase.dart';
import '../../domain/usecases/get_faqs_usecase.dart';
import '../../domain/usecases/get_support_channels_usecase.dart';
import '../../domain/usecases/get_ticket_details_usecase.dart';
import '../../domain/usecases/get_user_tickets_usecase.dart';
import '../../domain/usecases/send_ticket_message_usecase.dart';
import '../../domain/usecases/submit_ticket_usecase.dart';
import 'help_support_di.dart';

@immutable
class HelpSupportState {
  final AsyncValue<List<FaqEntity>> faqsState;
  final AsyncValue<List<SupportChannelEntity>> channelsState;
  final AsyncValue<List<SupportTicketEntity>> ticketsState;
  final AsyncValue<SupportTicketEntity?> selectedTicketState;
  final AsyncValue<SupportTicketEntity?> submissionState;
  final AsyncValue<SupportMessageEntity?> messageState;
  final AsyncValue<SupportTicketEntity?> closeTicketState;

  final FaqCategory selectedCategory;
  final String searchQuery;
  final String? lastSubmittedTicketId;
  final String? lastSubmittedTicketNumber;

  const HelpSupportState({
    this.faqsState = const AsyncData([]),
    this.channelsState = const AsyncData([]),
    this.ticketsState = const AsyncData([]),
    this.selectedTicketState = const AsyncData(null),
    this.submissionState = const AsyncData(null),
    this.messageState = const AsyncData(null),
    this.closeTicketState = const AsyncData(null),
    this.selectedCategory = FaqCategory.all,
    this.searchQuery = '',
    this.lastSubmittedTicketId,
    this.lastSubmittedTicketNumber,
  });

  // ── Backward-Compatible Getters ────────────────────────────────────────────

  List<FaqEntity> get faqs => faqsState.value ?? const [];
  List<SupportChannelEntity> get channels => channelsState.value ?? const [];
  List<SupportTicketEntity> get userTickets => ticketsState.value ?? const [];
  SupportTicketEntity? get selectedTicket => selectedTicketState.value;

  bool get isLoading => faqsState.isLoading || channelsState.isLoading;
  bool get isSubmitting => submissionState.isLoading;
  bool get isLoadingTickets => ticketsState.isLoading;
  bool get isSendingMessage => messageState.isLoading;
  bool get isClosingTicket => closeTicketState.isLoading;

  /// Safely extracts any active failure across the state slices
  Failure? get failure {
    final err = submissionState.error ??
        selectedTicketState.error ??
        ticketsState.error ??
        messageState.error ??
        closeTicketState.error ??
        faqsState.error ??
        channelsState.error;

    if (err is Failure) return err;
    if (err != null) return GeneralFailure(message: err.toString());
    return null;
  }

  String? get error => failure?.toMessage();

  HelpSupportState copyWith({
    AsyncValue<List<FaqEntity>>? faqsState,
    AsyncValue<List<SupportChannelEntity>>? channelsState,
    AsyncValue<List<SupportTicketEntity>>? ticketsState,
    AsyncValue<SupportTicketEntity?>? selectedTicketState,
    AsyncValue<SupportTicketEntity?>? submissionState,
    AsyncValue<SupportMessageEntity?>? messageState,
    AsyncValue<SupportTicketEntity?>? closeTicketState,
    bool clearSelectedTicket = false,
    FaqCategory? selectedCategory,
    String? searchQuery,
    String? lastSubmittedTicketId,
    String? lastSubmittedTicketNumber,
    // Backward-compatibility parameter overrides
    List<FaqEntity>? faqs,
    List<SupportChannelEntity>? channels,
    List<SupportTicketEntity>? userTickets,
    SupportTicketEntity? selectedTicket,
    bool? isLoading,
    bool? isSubmitting,
    bool? isLoadingTickets,
    bool? isSendingMessage,
    String? error,
  }) {
    AsyncValue<List<FaqEntity>> newFaqs = faqsState ?? this.faqsState;
    if (faqs != null) newFaqs = AsyncData(faqs);
    if (isLoading != null && isLoading) newFaqs = const AsyncLoading();

    AsyncValue<List<SupportChannelEntity>> newChannels =
        channelsState ?? this.channelsState;
    if (channels != null) newChannels = AsyncData(channels);

    AsyncValue<List<SupportTicketEntity>> newTickets =
        ticketsState ?? this.ticketsState;
    if (userTickets != null) newTickets = AsyncData(userTickets);
    if (isLoadingTickets != null) {
      newTickets = isLoadingTickets ? const AsyncLoading() : newTickets;
    }

    AsyncValue<SupportTicketEntity?> newSelectedTicket = clearSelectedTicket
        ? const AsyncData(null)
        : (selectedTicketState ?? this.selectedTicketState);
    if (selectedTicket != null) newSelectedTicket = AsyncData(selectedTicket);

    AsyncValue<SupportTicketEntity?> newSubmission =
        submissionState ?? this.submissionState;
    if (isSubmitting != null) {
      newSubmission = isSubmitting ? const AsyncLoading() : newSubmission;
    }

    AsyncValue<SupportMessageEntity?> newMessage =
        messageState ?? this.messageState;
    if (isSendingMessage != null) {
      newMessage = isSendingMessage ? const AsyncLoading() : newMessage;
    }

    if (error != null) {
      final f = GeneralFailure(message: error);
      newSubmission = AsyncError(f, StackTrace.current);
    }

    return HelpSupportState(
      faqsState: newFaqs,
      channelsState: newChannels,
      ticketsState: newTickets,
      selectedTicketState: newSelectedTicket,
      submissionState: newSubmission,
      messageState: newMessage,
      closeTicketState: closeTicketState ?? this.closeTicketState,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      lastSubmittedTicketId:
          lastSubmittedTicketId ?? this.lastSubmittedTicketId,
      lastSubmittedTicketNumber:
          lastSubmittedTicketNumber ?? this.lastSubmittedTicketNumber,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HelpSupportState &&
          runtimeType == other.runtimeType &&
          faqsState == other.faqsState &&
          channelsState == other.channelsState &&
          ticketsState == other.ticketsState &&
          selectedTicketState == other.selectedTicketState &&
          submissionState == other.submissionState &&
          messageState == other.messageState &&
          closeTicketState == other.closeTicketState &&
          selectedCategory == other.selectedCategory &&
          searchQuery == other.searchQuery &&
          lastSubmittedTicketId == other.lastSubmittedTicketId &&
          lastSubmittedTicketNumber == other.lastSubmittedTicketNumber;

  @override
  int get hashCode => Object.hash(
        faqsState,
        channelsState,
        ticketsState,
        selectedTicketState,
        submissionState,
        messageState,
        closeTicketState,
        selectedCategory,
        searchQuery,
        lastSubmittedTicketId,
        lastSubmittedTicketNumber,
      );
}

class HelpSupportNotifier extends StateNotifier<HelpSupportState> {
  final GetFaqsUseCase _getFaqsUseCase;
  final GetSupportChannelsUseCase _getChannelsUseCase;
  final SubmitTicketUseCase _submitTicketUseCase;
  final GetUserTicketsUseCase _getUserTicketsUseCase;
  final GetTicketDetailsUseCase _getTicketDetailsUseCase;
  final SendTicketMessageUseCase _sendTicketMessageUseCase;
  final CloseTicketUseCase _closeTicketUseCase;
  final WebSocketService _webSocketService;

  final List<StreamSubscription> _activeWsSubscriptions = [];
  String? _activeTicketId;

  HelpSupportNotifier({
    required GetFaqsUseCase getFaqsUseCase,
    required GetSupportChannelsUseCase getChannelsUseCase,
    required SubmitTicketUseCase submitTicketUseCase,
    required GetUserTicketsUseCase getUserTicketsUseCase,
    required GetTicketDetailsUseCase getTicketDetailsUseCase,
    required SendTicketMessageUseCase sendTicketMessageUseCase,
    required CloseTicketUseCase closeTicketUseCase,
    WebSocketService? webSocketService,
  })  : _getFaqsUseCase = getFaqsUseCase,
        _getChannelsUseCase = getChannelsUseCase,
        _submitTicketUseCase = submitTicketUseCase,
        _getUserTicketsUseCase = getUserTicketsUseCase,
        _getTicketDetailsUseCase = getTicketDetailsUseCase,
        _sendTicketMessageUseCase = sendTicketMessageUseCase,
        _closeTicketUseCase = closeTicketUseCase,
        _webSocketService = webSocketService ?? WebSocketService(),
        super(const HelpSupportState()) {
    init();
  }

  /// Initial load of FAQs, Support Channels, and User Tickets.
  Future<void> init() async {
    state = state.copyWith(
      faqsState: const AsyncLoading(),
      channelsState: const AsyncLoading(),
    );

    final faqsResult = await _getFaqsUseCase();
    final channelsResult = await _getChannelsUseCase();

    faqsResult.fold(
      (failure) {
        state = state.copyWith(
          faqsState: AsyncError(failure, failure.stackTrace ?? StackTrace.current),
        );
      },
      (faqs) {
        state = state.copyWith(faqsState: AsyncData(faqs));
      },
    );

    channelsResult.fold(
      (failure) {
        state = state.copyWith(
          channelsState:
              AsyncError(failure, failure.stackTrace ?? StackTrace.current),
        );
      },
      (channels) {
        state = state.copyWith(channelsState: AsyncData(channels));
      },
    );

    await loadUserTickets();
  }

  /// Loads tickets submitted by the authenticated customer.
  Future<void> loadUserTickets() async {
    if (state.isLoadingTickets) return;
    state = state.copyWith(ticketsState: const AsyncLoading());

    final result = await _getUserTicketsUseCase();

    result.fold(
      (failure) {
        state = state.copyWith(
          ticketsState:
              AsyncError(failure, failure.stackTrace ?? StackTrace.current),
        );
      },
      (tickets) {
        state = state.copyWith(ticketsState: AsyncData(tickets));
      },
    );
  }

  /// Loads full details and conversation messages of a specific ticket.
  Future<void> loadTicketDetails(
    String ticketId, {
    bool isSilentRefresh = false,
  }) async {
    if (!isSilentRefresh) {
      state = state.copyWith(selectedTicketState: const AsyncLoading());
    }

    final result = await _getTicketDetailsUseCase(ticketId);

    result.fold(
      (failure) {
        if (!isSilentRefresh) {
          state = state.copyWith(
            selectedTicketState: AsyncError(
              failure,
              failure.stackTrace ?? StackTrace.current,
            ),
          );
        }
      },
      (freshTicket) {
        final current = state.selectedTicket;
        if (isSilentRefresh && current != null) {
          final hasNewMessages =
              freshTicket.messages.length != current.messages.length;
          final statusChanged = freshTicket.status != current.status;
          if (hasNewMessages || statusChanged) {
            state = state.copyWith(selectedTicketState: AsyncData(freshTicket));
          }
        } else {
          state = state.copyWith(selectedTicketState: AsyncData(freshTicket));
        }
        _subscribeToTicketRealtime(ticketId);
      },
    );
  }

  /// Subscribes to real-time events on WebSocket channel for streaming replies.
  void _subscribeToTicketRealtime(String ticketId) {
    if (_activeTicketId == ticketId) return;

    _unsubscribeActiveTicket();
    _activeTicketId = ticketId;

    try {
      final channel = _webSocketService.subscribeToTicket(ticketId);

      // Listen to all events on this channel (handles any event naming conventions)
      final subAll = channel.bindToAll().listen((event) {
        final eventName = event.name;
        if (eventName.contains('SupportMessageSent')) {
          _handleIncomingMessageEvent(ticketId, event);
        } else if (eventName.contains('SupportTicketUpdated')) {
          _handleIncomingTicketUpdatedEvent(ticketId, event);
        }
      });

      _activeWsSubscriptions.add(subAll);
    } catch (e) {
      debugPrint('Realtime subscription error for ticket $ticketId: $e');
    }
  }

  void _handleIncomingMessageEvent(String ticketId, dynamic event) {
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

      final current = state.selectedTicket;
      if (current != null &&
          (current.id == ticketId || newMsg.ticketId.toString() == ticketId)) {
        final exists = current.messages.any((m) => m.id == newMsg.id);
        if (!exists) {
          final updatedMsgs =
              List<SupportMessageEntity>.from(current.messages)..add(newMsg);
          final updatedTicket = current.copyWith(
            messages: updatedMsgs,
            messagesCount: current.messagesCount + 1,
            lastReplyAt: newMsg.createdAt,
          );
          state = state.copyWith(
            selectedTicketState: AsyncData(updatedTicket),
          );
        }
      } else {
        loadTicketDetails(ticketId, isSilentRefresh: true);
      }
    }
  }

  void _handleIncomingTicketUpdatedEvent(String ticketId, dynamic event) {
    final map = event.tryGetDataAsMap();
    if (map != null && map['ticket'] is Map) {
      final rawTicket = Map<String, dynamic>.from(map['ticket'] as Map);
      final newStatus = rawTicket['status']?.toString();
      final newPriority = rawTicket['priority']?.toString();
      final current = state.selectedTicket;
      if (current != null && current.id == ticketId) {
        final updatedTicket = current.copyWith(
          status: newStatus ?? current.status,
          priority: newPriority != null
              ? TicketPriority.fromString(newPriority)
              : current.priority,
        );
        state = state.copyWith(
          selectedTicketState: AsyncData(updatedTicket),
        );
      }
      loadUserTickets();
    }
  }

  void _unsubscribeActiveTicket() {
    if (_activeTicketId != null) {
      for (final sub in _activeWsSubscriptions) {
        sub.cancel();
      }
      _activeWsSubscriptions.clear();
      _webSocketService.unsubscribeFromTicket(_activeTicketId!);
      _activeTicketId = null;
    }
  }

  void clearSelectedTicket() {
    _unsubscribeActiveTicket();
    state = state.copyWith(clearSelectedTicket: true);
  }

  /// Sends a reply inside an open ticket conversation with duplicate guard.
  Future<bool> sendReplyMessage(String ticketId, String message) async {
    final text = message.trim();
    if (text.isEmpty || state.isSendingMessage) return false;

    state = state.copyWith(messageState: const AsyncLoading());

    final result = await _sendTicketMessageUseCase(
      ticketId: ticketId,
      message: text,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          messageState:
              AsyncError(failure, failure.stackTrace ?? StackTrace.current),
        );
        return false;
      },
      (sentMsg) {
        state = state.copyWith(messageState: AsyncData(sentMsg));
        loadTicketDetails(ticketId, isSilentRefresh: true);
        loadUserTickets();
        return true;
      },
    );
  }

  /// Closes an open ticket with duplicate guard.
  Future<bool> closeTicket(String ticketId) async {
    if (state.isClosingTicket) return false;
    state = state.copyWith(closeTicketState: const AsyncLoading());

    final result = await _closeTicketUseCase(ticketId);

    return result.fold(
      (failure) {
        state = state.copyWith(
          closeTicketState:
              AsyncError(failure, failure.stackTrace ?? StackTrace.current),
        );
        return false;
      },
      (closedTicket) {
        state = state.copyWith(
          closeTicketState: AsyncData(closedTicket),
          selectedTicketState: AsyncData(closedTicket),
        );
        loadUserTickets();
        return true;
      },
    );
  }

  /// Filters FAQs by category.
  Future<void> selectCategory(FaqCategory category) async {
    if (state.selectedCategory == category) return;
    state = state.copyWith(
      selectedCategory: category,
      faqsState: const AsyncLoading(),
    );

    final result = await _getFaqsUseCase(
      category: category,
      query: state.searchQuery,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          faqsState:
              AsyncError(failure, failure.stackTrace ?? StackTrace.current),
        );
      },
      (faqs) {
        state = state.copyWith(faqsState: AsyncData(faqs));
      },
    );
  }

  /// Searches FAQs by query term.
  Future<void> search(String query) async {
    state = state.copyWith(searchQuery: query);

    final result = await _getFaqsUseCase(
      category: state.selectedCategory,
      query: query,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          faqsState:
              AsyncError(failure, failure.stackTrace ?? StackTrace.current),
        );
      },
      (faqs) {
        state = state.copyWith(faqsState: AsyncData(faqs));
      },
    );
  }

  /// Submits a new support ticket with strict duplicate submission guard.
  Future<SupportTicketEntity?> submitTicket({
    required String subject,
    required String category,
    required String message,
    TicketPriority priority = TicketPriority.normal,
  }) async {
    if (state.isSubmitting) return null;

    state = state.copyWith(submissionState: const AsyncLoading());

    final ticket = SupportTicketEntity(
      subject: subject,
      category: category,
      message: message,
      priority: priority,
      createdAt: DateTime.now(),
    );

    final result = await _submitTicketUseCase(ticket);

    return result.fold(
      (failure) {
        state = state.copyWith(
          submissionState: AsyncError(
            failure,
            failure.stackTrace ?? StackTrace.current,
          ),
        );
        return null;
      },
      (createdTicket) {
        state = state.copyWith(
          submissionState: AsyncData(createdTicket),
          lastSubmittedTicketId: createdTicket.id,
          lastSubmittedTicketNumber: createdTicket.ticketNumber,
        );
        loadUserTickets();
        return createdTicket;
      },
    );
  }

  /// Launches an external communication channel decoupled from BuildContext.
  Future<bool> launchChannel(
    dynamic contextOrChannel, [
    dynamic channelOrCallback,
    dynamic maybeCallback,
  ]) async {
    SupportChannelEntity channel;
    VoidCallback? onOpenTicket;

    if (contextOrChannel is SupportChannelEntity) {
      channel = contextOrChannel;
      if (channelOrCallback is VoidCallback) onOpenTicket = channelOrCallback;
    } else if (channelOrCallback is SupportChannelEntity) {
      channel = channelOrCallback;
      if (maybeCallback is VoidCallback) onOpenTicket = maybeCallback;
    } else {
      return false;
    }

    if (channel.type == SupportChannelType.ticket) {
      onOpenTicket?.call();
      return true;
    }

    try {
      final uri = Uri.parse(channel.actionValue);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return false;
    } catch (e) {
      debugPrint('Error launching support channel ${channel.titleEn}: $e');
      return false;
    }
  }

  @override
  void dispose() {
    _unsubscribeActiveTicket();
    super.dispose();
  }
}

// ── Controller Provider ──────────────────────────────────────────────────────

final helpSupportControllerProvider =
    StateNotifierProvider<HelpSupportNotifier, HelpSupportState>((ref) {
  final getFaqs = ref.watch(getFaqsUseCaseProvider);
  final getChannels = ref.watch(getSupportChannelsUseCaseProvider);
  final submitTicket = ref.watch(submitTicketUseCaseProvider);
  final getUserTickets = ref.watch(getUserTicketsUseCaseProvider);
  final getTicketDetails = ref.watch(getTicketDetailsUseCaseProvider);
  final sendTicketMessage = ref.watch(sendTicketMessageUseCaseProvider);
  final closeTicket = ref.watch(closeTicketUseCaseProvider);
  final wsService = ref.watch(webSocketServiceProvider);

  final notifier = HelpSupportNotifier(
    getFaqsUseCase: getFaqs,
    getChannelsUseCase: getChannels,
    submitTicketUseCase: submitTicket,
    getUserTicketsUseCase: getUserTickets,
    getTicketDetailsUseCase: getTicketDetails,
    sendTicketMessageUseCase: sendTicketMessage,
    closeTicketUseCase: closeTicket,
    webSocketService: wsService,
  );

  return notifier;
});
