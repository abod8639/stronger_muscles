import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
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

class HelpSupportState {
  final List<FaqEntity> faqs;
  final List<SupportChannelEntity> channels;
  final List<SupportTicketEntity> userTickets;
  final SupportTicketEntity? selectedTicket;
  final FaqCategory selectedCategory;
  final String searchQuery;
  final bool isLoading;
  final bool isSubmitting;
  final bool isLoadingTickets;
  final bool isSendingMessage;
  final String? error;
  final String? lastSubmittedTicketId;
  final String? lastSubmittedTicketNumber;

  const HelpSupportState({
    this.faqs = const [],
    this.channels = const [],
    this.userTickets = const [],
    this.selectedTicket,
    this.selectedCategory = FaqCategory.all,
    this.searchQuery = '',
    this.isLoading = false,
    this.isSubmitting = false,
    this.isLoadingTickets = false,
    this.isSendingMessage = false,
    this.error,
    this.lastSubmittedTicketId,
    this.lastSubmittedTicketNumber,
  });

  HelpSupportState copyWith({
    List<FaqEntity>? faqs,
    List<SupportChannelEntity>? channels,
    List<SupportTicketEntity>? userTickets,
    SupportTicketEntity? selectedTicket,
    bool clearSelectedTicket = false,
    FaqCategory? selectedCategory,
    String? searchQuery,
    bool? isLoading,
    bool? isSubmitting,
    bool? isLoadingTickets,
    bool? isSendingMessage,
    String? error,
    String? lastSubmittedTicketId,
    String? lastSubmittedTicketNumber,
  }) {
    return HelpSupportState(
      faqs: faqs ?? this.faqs,
      channels: channels ?? this.channels,
      userTickets: userTickets ?? this.userTickets,
      selectedTicket: clearSelectedTicket ? null : (selectedTicket ?? this.selectedTicket),
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isLoadingTickets: isLoadingTickets ?? this.isLoadingTickets,
      isSendingMessage: isSendingMessage ?? this.isSendingMessage,
      error: error,
      lastSubmittedTicketId: lastSubmittedTicketId ?? this.lastSubmittedTicketId,
      lastSubmittedTicketNumber: lastSubmittedTicketNumber ?? this.lastSubmittedTicketNumber,
    );
  }
}

class HelpSupportNotifier extends StateNotifier<HelpSupportState> {
  final GetFaqsUseCase _getFaqsUseCase;
  final GetSupportChannelsUseCase _getChannelsUseCase;
  final SubmitTicketUseCase _submitTicketUseCase;
  final HelpSupportRepository _repository;
  final WebSocketService _webSocketService;
  final List<StreamSubscription> _activeWsSubscriptions = [];
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
    init();
  }

  Future<void> init() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final faqs = await _getFaqsUseCase();
      final channels = await _getChannelsUseCase();
      state = state.copyWith(
        faqs: faqs,
        channels: channels,
        isLoading: false,
      );
      // Load user's previous tickets
      loadUserTickets();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadUserTickets() async {
    state = state.copyWith(isLoadingTickets: true);
    try {
      final tickets = await _repository.getUserTickets();
      state = state.copyWith(
        userTickets: tickets,
        isLoadingTickets: false,
      );
    } catch (_) {
      state = state.copyWith(isLoadingTickets: false);
    }
  }

  Future<void> loadTicketDetails(String ticketId) async {
    state = state.copyWith(isLoadingTickets: true);
    try {
      final ticket = await _repository.getTicketDetails(ticketId);
      state = state.copyWith(
        selectedTicket: ticket,
        isLoadingTickets: false,
      );
      _subscribeToTicketRealtime(ticketId);
    } catch (e) {
      state = state.copyWith(
        isLoadingTickets: false,
        error: e.toString(),
      );
    }
  }

  void _subscribeToTicketRealtime(String ticketId) {
    if (_activeTicketId == ticketId) return;

    _unsubscribeActiveTicket();
    _activeTicketId = ticketId;

    try {
      final channel = _webSocketService.subscribeToTicket(ticketId);

      // 1. Listen for new messages in this ticket
      final subMsg = channel.bind('SupportMessageSent').listen((event) {
        final map = event.tryGetDataAsMap();
        if (map != null && map['message'] != null) {
          final msgMap = map['message'] is Map ? Map<String, dynamic>.from(map['message'] as Map) : null;
          if (msgMap != null) {
            final newMsg = SupportMessageModel.fromJson(msgMap);
            if (state.selectedTicket != null && state.selectedTicket!.id == ticketId) {
              final exists = state.selectedTicket!.messages.any((m) => m.id == newMsg.id);
              if (!exists) {
                final updatedMsgs = List<SupportMessageEntity>.from(state.selectedTicket!.messages)..add(newMsg);
                state = state.copyWith(
                  selectedTicket: state.selectedTicket!.copyWith(
                    messages: updatedMsgs,
                    messagesCount: state.selectedTicket!.messagesCount + 1,
                    lastReplyAt: newMsg.createdAt,
                  ),
                );
              }
            }
          }
        }
      });

      // 2. Listen for ticket status/priority updates
      final subUpdate = channel.bind('SupportTicketUpdated').listen((event) {
        final map = event.tryGetDataAsMap();
        if (map != null && map['ticket'] != null) {
          final ticketMap = map['ticket'] is Map ? Map<String, dynamic>.from(map['ticket'] as Map) : null;
          if (ticketMap != null) {
            final newStatus = ticketMap['status']?.toString();
            final newPriority = ticketMap['priority']?.toString();
            if (state.selectedTicket != null && state.selectedTicket!.id == ticketId) {
              state = state.copyWith(
                selectedTicket: state.selectedTicket!.copyWith(
                  status: newStatus ?? state.selectedTicket!.status,
                  priority: newPriority != null ? TicketPriority.fromString(newPriority) : state.selectedTicket!.priority,
                ),
              );
            }
            loadUserTickets();
          }
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

  @override
  void dispose() {
    _unsubscribeActiveTicket();
    super.dispose();
  }

  Future<bool> sendReplyMessage(String ticketId, String message) async {
    if (message.trim().isEmpty) return false;
    state = state.copyWith(isSendingMessage: true);
    try {
      await _repository.sendTicketMessage(ticketId, message);
      await loadTicketDetails(ticketId);
      await loadUserTickets();
      state = state.copyWith(isSendingMessage: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSendingMessage: false, error: e.toString());
      return false;
    }
  }

  Future<bool> closeTicket(String ticketId) async {
    try {
      final updated = await _repository.closeTicket(ticketId);
      state = state.copyWith(selectedTicket: updated);
      await loadUserTickets();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<void> selectCategory(FaqCategory category) async {
    if (state.selectedCategory == category) return;
    state = state.copyWith(selectedCategory: category, isLoading: true);
    try {
      final faqs = await _getFaqsUseCase(
        category: category,
        query: state.searchQuery,
      );
      state = state.copyWith(faqs: faqs, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> search(String query) async {
    state = state.copyWith(searchQuery: query);
    try {
      final faqs = await _getFaqsUseCase(
        category: state.selectedCategory,
        query: query,
      );
      state = state.copyWith(faqs: faqs);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<SupportTicketEntity?> submitTicket({
    required String subject,
    required String category,
    required String message,
    TicketPriority priority = TicketPriority.normal,
  }) async {
    state = state.copyWith(isSubmitting: true, error: null);
    try {
      final ticket = SupportTicketEntity(
        subject: subject,
        category: category,
        message: message,
        priority: priority,
        createdAt: DateTime.now(),
      );
      final result = await _submitTicketUseCase(ticket);
      state = state.copyWith(
        isSubmitting: false,
        lastSubmittedTicketId: result.id,
        lastSubmittedTicketNumber: result.ticketNumber,
      );
      // Reload tickets list
      loadUserTickets();
      return result;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: e.toString(),
      );
      return null;
    }
  }

  Future<void> launchChannel(
    BuildContext context,
    SupportChannelEntity channel, {
    VoidCallback? onOpenTicket,
  }) async {
    if (channel.type == SupportChannelType.ticket) {
      onOpenTicket?.call();
      return;
    }

    try {
      final uri = Uri.parse(channel.actionValue);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تعذر فتح الرابط: ${channel.actionValue}')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ أثناء تشغيل القناة: $e')),
        );
      }
    }
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

  return HelpSupportNotifier(
    getFaqsUseCase: getFaqs,
    getChannelsUseCase: getChannels,
    submitTicketUseCase: submitTicket,
    repository: repo,
    webSocketService: wsService,
  );
});
