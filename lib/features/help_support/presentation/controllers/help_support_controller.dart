import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/core/services/websocket_service.dart';
import 'package:stronger_muscles/features/help_support/data/models/support_message_model.dart';
import 'package:stronger_muscles/features/help_support/data/repositories/help_support_repository_impl.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/faq_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_channel_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_message_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_ticket_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/repositories/help_support_repository.dart';
import 'package:stronger_muscles/features/help_support/domain/usecases/get_faqs_usecase.dart';
import 'package:stronger_muscles/features/help_support/domain/usecases/get_support_channels_usecase.dart';
import 'package:stronger_muscles/features/help_support/domain/usecases/submit_ticket_usecase.dart';

@immutable
class HelpSupportState {
  final AsyncValue<List<FaqEntity>> faqsState;
  final AsyncValue<List<SupportChannelEntity>> channelsState;
  final AsyncValue<List<SupportTicketEntity>> ticketsState;
  final AsyncValue<SupportTicketEntity?> selectedTicketState;
  final AsyncValue<SupportTicketEntity?> submissionState;
  final AsyncValue<SupportMessageEntity?> messageState;

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

  /// Safely extracts any active failure across the state slices
  Failure? get failure {
    final err = submissionState.error ??
        selectedTicketState.error ??
        ticketsState.error ??
        messageState.error ??
        faqsState.error ??
        channelsState.error;

    if (err is Failure) return err;
    if (err != null) return Failure(message: err.toString());
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

    AsyncValue<SupportTicketEntity?> newSelectedTicket =
        clearSelectedTicket ? const AsyncData(null) : (selectedTicketState ?? this.selectedTicketState);
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
      final f = Failure(message: error);
      newSubmission = AsyncError(f, StackTrace.current);
    }

    return HelpSupportState(
      faqsState: newFaqs,
      channelsState: newChannels,
      ticketsState: newTickets,
      selectedTicketState: newSelectedTicket,
      submissionState: newSubmission,
      messageState: newMessage,
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
  final HelpSupportRepository _repository;
  final WebSocketService _webSocketService;

  final List<StreamSubscription> _activeWsSubscriptions = [];
  CancelToken? _cancelToken;
  String? _activeTicketId;

  HelpSupportNotifier({
    required GetFaqsUseCase getFaqsUseCase,
    required GetSupportChannelsUseCase getChannelsUseCase,
    required SubmitTicketUseCase submitTicketUseCase,
    required HelpSupportRepository repository,
    WebSocketService? webSocketService,
  })  : _getFaqsUseCase = getFaqsUseCase,
        _getChannelsUseCase = getChannelsUseCase,
        _submitTicketUseCase = submitTicketUseCase,
        _repository = repository,
        _webSocketService = webSocketService ?? WebSocketService(),
        super(const HelpSupportState()) {
    _cancelToken = CancelToken();
    init();
  }

  /// Initial load of FAQs and Support Channels with Cancellation protection
  Future<void> init() async {
    state = state.copyWith(
      faqsState: const AsyncLoading(),
      channelsState: const AsyncLoading(),
    );

    final faqsResult = await _getFaqsUseCase(cancelToken: _cancelToken);
    final channelsResult = await _getChannelsUseCase(cancelToken: _cancelToken);

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
          channelsState: AsyncError(failure, failure.stackTrace ?? StackTrace.current),
        );
      },
      (channels) {
        state = state.copyWith(channelsState: AsyncData(channels));
      },
    );

    // Concurrently load user tickets
    loadUserTickets();
  }

  /// Loads tickets submitted by the authenticated customer
  Future<void> loadUserTickets() async {
    state = state.copyWith(ticketsState: const AsyncLoading());

    final result = await _repository.getUserTickets(cancelToken: _cancelToken);

    result.fold(
      (failure) {
        state = state.copyWith(
          ticketsState: AsyncError(failure, failure.stackTrace ?? StackTrace.current),
        );
      },
      (tickets) {
        state = state.copyWith(ticketsState: AsyncData(tickets));
      },
    );
  }

  /// Loads full details and conversation messages of a specific ticket
  Future<void> loadTicketDetails(String ticketId) async {
    state = state.copyWith(selectedTicketState: const AsyncLoading());

    final result = await _repository.getTicketDetails(
      ticketId,
      cancelToken: _cancelToken,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          selectedTicketState: AsyncError(
            failure,
            failure.stackTrace ?? StackTrace.current,
          ),
        );
      },
      (ticket) {
        state = state.copyWith(selectedTicketState: AsyncData(ticket));
        _subscribeToTicketRealtime(ticketId);
      },
    );
  }

  /// Subscribes to real-time events on WebSocket channel for streaming replies
  void _subscribeToTicketRealtime(String ticketId) {
    if (_activeTicketId == ticketId) return;

    _unsubscribeActiveTicket();
    _activeTicketId = ticketId;

    try {
      final channel = _webSocketService.subscribeToTicket(ticketId);

      // 1. Listen for new messages in this ticket
      final subMsg = channel.bind('SupportMessageSent').listen((event) async {
        try {
          final map = event.tryGetDataAsMap();
          if (map != null && map['message'] != null) {
            final rawMsg = map['message'];
            if (rawMsg is Map) {
              final newMsg = await SupportMessageModel.fromJsonAsync(
                Map<String, dynamic>.from(rawMsg),
              );

              final current = state.selectedTicket;
              if (current != null && current.id == ticketId) {
                final exists = current.messages.any((m) => m.id == newMsg.id);
                if (!exists) {
                  final updatedMsgs = List<SupportMessageEntity>.from(current.messages)..add(newMsg);
                  final updatedTicket = current.copyWith(
                    messages: updatedMsgs,
                    messagesCount: current.messagesCount + 1,
                    lastReplyAt: newMsg.createdAt,
                  );
                  state = state.copyWith(
                    selectedTicketState: AsyncData(updatedTicket),
                  );
                }
              }
            }
          }
        } catch (e) {
          debugPrint('Error processing realtime support message: $e');
        }
      });

      // 2. Listen for ticket status/priority updates
      final subUpdate = channel.bind('SupportTicketUpdated').listen((event) {
        try {
          final map = event.tryGetDataAsMap();
          if (map != null && map['ticket'] != null) {
            final rawTicket = map['ticket'];
            if (rawTicket is Map) {
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
        } catch (e) {
          debugPrint('Error processing realtime ticket update: $e');
        }
      });

      _activeWsSubscriptions.addAll([subMsg, subUpdate]);
    } catch (e) {
      debugPrint('Realtime subscription error for ticket $ticketId: $e');
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

  /// Sends a reply inside an open ticket conversation
  Future<bool> sendReplyMessage(String ticketId, String message) async {
    final text = message.trim();
    if (text.isEmpty) return false;

    state = state.copyWith(messageState: const AsyncLoading());

    final result = await _repository.sendTicketMessage(
      ticketId,
      text,
      cancelToken: _cancelToken,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          messageState: AsyncError(failure, failure.stackTrace ?? StackTrace.current),
        );
        return false;
      },
      (sentMsg) {
        state = state.copyWith(messageState: AsyncData(sentMsg));
        loadTicketDetails(ticketId);
        loadUserTickets();
        return true;
      },
    );
  }

  /// Closes an open ticket
  Future<bool> closeTicket(String ticketId) async {
    final result = await _repository.closeTicket(
      ticketId,
      cancelToken: _cancelToken,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          selectedTicketState: AsyncError(
            failure,
            failure.stackTrace ?? StackTrace.current,
          ),
        );
        return false;
      },
      (closedTicket) {
        state = state.copyWith(selectedTicketState: AsyncData(closedTicket));
        loadUserTickets();
        return true;
      },
    );
  }

  /// Filters FAQs by category
  Future<void> selectCategory(FaqCategory category) async {
    if (state.selectedCategory == category) return;
    state = state.copyWith(
      selectedCategory: category,
      faqsState: const AsyncLoading(),
    );

    final result = await _getFaqsUseCase(
      category: category,
      query: state.searchQuery,
      cancelToken: _cancelToken,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          faqsState: AsyncError(failure, failure.stackTrace ?? StackTrace.current),
        );
      },
      (faqs) {
        state = state.copyWith(faqsState: AsyncData(faqs));
      },
    );
  }

  /// Searches FAQs by query term
  Future<void> search(String query) async {
    state = state.copyWith(searchQuery: query);

    final result = await _getFaqsUseCase(
      category: state.selectedCategory,
      query: query,
      cancelToken: _cancelToken,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          faqsState: AsyncError(failure, failure.stackTrace ?? StackTrace.current),
        );
      },
      (faqs) {
        state = state.copyWith(faqsState: AsyncData(faqs));
      },
    );
  }

  /// Submits a new support ticket
  Future<SupportTicketEntity?> submitTicket({
    required String subject,
    required String category,
    required String message,
    TicketPriority priority = TicketPriority.normal,
  }) async {
    state = state.copyWith(submissionState: const AsyncLoading());

    final ticket = SupportTicketEntity(
      subject: subject,
      category: category,
      message: message,
      priority: priority,
      createdAt: DateTime.now(),
    );

    final result = await _submitTicketUseCase(
      ticket,
      cancelToken: _cancelToken,
    );

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
  /// Optional [context] parameter kept for backward-compatibility.
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
    _cancelToken?.cancel('HelpSupportNotifier disposed');
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
  final repo = ref.watch(helpSupportRepositoryProvider);
  final wsService = ref.watch(webSocketServiceProvider);

  final notifier = HelpSupportNotifier(
    getFaqsUseCase: getFaqs,
    getChannelsUseCase: getChannels,
    submitTicketUseCase: submitTicket,
    repository: repo,
    webSocketService: wsService,
  );

  ref.onDispose(() {
    notifier.dispose();
  });

  return notifier;
});
