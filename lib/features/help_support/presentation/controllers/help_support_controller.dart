import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:stronger_muscles/features/help_support/data/repositories/help_support_repository_impl.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/faq_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_channel_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_ticket_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/usecases/get_faqs_usecase.dart';
import 'package:stronger_muscles/features/help_support/domain/usecases/get_support_channels_usecase.dart';
import 'package:stronger_muscles/features/help_support/domain/usecases/submit_ticket_usecase.dart';

class HelpSupportState {
  final List<FaqEntity> faqs;
  final List<SupportChannelEntity> channels;
  final FaqCategory selectedCategory;
  final String searchQuery;
  final bool isLoading;
  final bool isSubmitting;
  final String? error;
  final String? lastSubmittedTicketId;

  const HelpSupportState({
    this.faqs = const [],
    this.channels = const [],
    this.selectedCategory = FaqCategory.all,
    this.searchQuery = '',
    this.isLoading = false,
    this.isSubmitting = false,
    this.error,
    this.lastSubmittedTicketId,
  });

  HelpSupportState copyWith({
    List<FaqEntity>? faqs,
    List<SupportChannelEntity>? channels,
    FaqCategory? selectedCategory,
    String? searchQuery,
    bool? isLoading,
    bool? isSubmitting,
    String? error,
    String? lastSubmittedTicketId,
  }) {
    return HelpSupportState(
      faqs: faqs ?? this.faqs,
      channels: channels ?? this.channels,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
      lastSubmittedTicketId: lastSubmittedTicketId ?? this.lastSubmittedTicketId,
    );
  }
}

class HelpSupportNotifier extends StateNotifier<HelpSupportState> {
  final GetFaqsUseCase _getFaqsUseCase;
  final GetSupportChannelsUseCase _getChannelsUseCase;
  final SubmitTicketUseCase _submitTicketUseCase;

  HelpSupportNotifier({
    required GetFaqsUseCase getFaqsUseCase,
    required GetSupportChannelsUseCase getChannelsUseCase,
    required SubmitTicketUseCase submitTicketUseCase,
  })  : _getFaqsUseCase = getFaqsUseCase,
        _getChannelsUseCase = getChannelsUseCase,
        _submitTicketUseCase = submitTicketUseCase,
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
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
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

  Future<String?> submitTicket({
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
      );
      return result.id;
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

  return HelpSupportNotifier(
    getFaqsUseCase: getFaqs,
    getChannelsUseCase: getChannels,
    submitTicketUseCase: submitTicket,
  );
});
