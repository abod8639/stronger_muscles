import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/help_support/data/datasources/help_support_local_data_source.dart';
import 'package:stronger_muscles/features/help_support/data/datasources/help_support_remote_data_source.dart';
import 'package:stronger_muscles/features/help_support/data/models/support_ticket_model.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/faq_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_channel_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_message_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_ticket_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/repositories/help_support_repository.dart';
import 'package:stronger_muscles/features/help_support/domain/usecases/get_faqs_usecase.dart';
import 'package:stronger_muscles/features/help_support/domain/usecases/get_support_channels_usecase.dart';
import 'package:stronger_muscles/features/help_support/domain/usecases/submit_ticket_usecase.dart';

class HelpSupportRepositoryImpl implements HelpSupportRepository {
  final HelpSupportLocalDataSource _localDataSource;
  final HelpSupportRemoteDataSource _remoteDataSource;

  HelpSupportRepositoryImpl(this._localDataSource, this._remoteDataSource);

  @override
  Future<Either<Failure, List<FaqEntity>>> getFaqs({
    FaqCategory? category,
    String? query,
    CancelToken? cancelToken,
  }) async {
    return NetworkErrorHandler.execute<List<FaqEntity>>(() async {
      if (cancelToken?.isCancelled ?? false) {
        throw const CancelFailure();
      }
      return await _localDataSource.getFaqs(category: category, query: query);
    });
  }

  @override
  Future<Either<Failure, List<SupportChannelEntity>>> getSupportChannels({
    CancelToken? cancelToken,
  }) async {
    return NetworkErrorHandler.execute<List<SupportChannelEntity>>(() async {
      if (cancelToken?.isCancelled ?? false) {
        throw const CancelFailure();
      }
      return await _localDataSource.getSupportChannels();
    });
  }

  @override
  Future<Either<Failure, SupportTicketEntity>> submitTicket(
    SupportTicketEntity ticket, {
    CancelToken? cancelToken,
  }) {
    return NetworkErrorHandler.execute<SupportTicketEntity>(() async {
      if (cancelToken?.isCancelled ?? false) {
        throw const CancelFailure();
      }

      final model = SupportTicketModel.fromEntity(ticket);
      try {
        final remoteTicket = await _remoteDataSource
            .submitTicket(model, cancelToken: cancelToken)
            .timeout(
              const Duration(seconds: 25),
              onTimeout: () => throw const TimeoutFailure(
                message: 'انتهت مهلة إرسال تذكرة الدعم، يرجى المحاولة لاحقاً',
              ),
            );
        return remoteTicket;
      } catch (error, stackTrace) {
        final failure = NetworkErrorHandler.handle(error, stackTrace);
        // Fallback to local simulation if network is unreachable
        if (failure.isConnectionError) {
          return await _localDataSource.submitTicket(model);
        }
        throw failure;
      }
    });
  }

  @override
  Future<Either<Failure, List<SupportTicketEntity>>> getUserTickets({
    CancelToken? cancelToken,
  }) {
    return NetworkErrorHandler.execute<List<SupportTicketEntity>>(() async {
      if (cancelToken?.isCancelled ?? false) {
        throw const CancelFailure();
      }
      return await _remoteDataSource
          .getUserTickets(cancelToken: cancelToken)
          .timeout(
            const Duration(seconds: 20),
            onTimeout: () => throw const TimeoutFailure(
              message: 'انتهت مهلة تحميل قائمة تذاكر الدعم',
            ),
          );
    });
  }

  @override
  Future<Either<Failure, SupportTicketEntity>> getTicketDetails(
    String ticketId, {
    CancelToken? cancelToken,
  }) {
    return NetworkErrorHandler.execute<SupportTicketEntity>(() async {
      if (cancelToken?.isCancelled ?? false) {
        throw const CancelFailure();
      }
      return await _remoteDataSource
          .getTicketDetails(ticketId, cancelToken: cancelToken)
          .timeout(
            const Duration(seconds: 20),
            onTimeout: () => throw const TimeoutFailure(
              message: 'انتهت مهلة تحميل تفاصيل التذكرة',
            ),
          );
    });
  }

  @override
  Future<Either<Failure, SupportMessageEntity>> sendTicketMessage(
    String ticketId,
    String message, {
    CancelToken? cancelToken,
  }) {
    return NetworkErrorHandler.execute<SupportMessageEntity>(() async {
      if (cancelToken?.isCancelled ?? false) {
        throw const CancelFailure();
      }
      return await _remoteDataSource
          .sendTicketMessage(ticketId, message, cancelToken: cancelToken)
          .timeout(
            const Duration(seconds: 20),
            onTimeout: () => throw const TimeoutFailure(
              message: 'انتهت مهلة إرسال الرسالة',
            ),
          );
    });
  }

  @override
  Future<Either<Failure, SupportTicketEntity>> closeTicket(
    String ticketId, {
    CancelToken? cancelToken,
  }) {
    return NetworkErrorHandler.execute<SupportTicketEntity>(() async {
      if (cancelToken?.isCancelled ?? false) {
        throw const CancelFailure();
      }
      return await _remoteDataSource
          .closeTicket(ticketId, cancelToken: cancelToken)
          .timeout(
            const Duration(seconds: 20),
            onTimeout: () => throw const TimeoutFailure(
              message: 'انتهت مهلة إغلاق التذكرة',
            ),
          );
    });
  }
}

// ── Riverpod Dependency Injection Providers ──────────────────────────────────

final helpSupportLocalDataSourceProvider =
    Provider<HelpSupportLocalDataSource>((ref) {
  return HelpSupportLocalDataSourceImpl();
});

final helpSupportRemoteDataSourceProvider =
    Provider<HelpSupportRemoteDataSource>((ref) {
  final api = ref.watch(apiServiceProvider);
  return HelpSupportRemoteDataSourceImpl(api);
});

final helpSupportRepositoryProvider = Provider<HelpSupportRepository>((ref) {
  final localDataSource = ref.watch(helpSupportLocalDataSourceProvider);
  final remoteDataSource = ref.watch(helpSupportRemoteDataSourceProvider);
  return HelpSupportRepositoryImpl(localDataSource, remoteDataSource);
});

final getFaqsUseCaseProvider = Provider<GetFaqsUseCase>((ref) {
  final repo = ref.watch(helpSupportRepositoryProvider);
  return GetFaqsUseCase(repo);
});

final getSupportChannelsUseCaseProvider =
    Provider<GetSupportChannelsUseCase>((ref) {
  final repo = ref.watch(helpSupportRepositoryProvider);
  return GetSupportChannelsUseCase(repo);
});

final submitTicketUseCaseProvider = Provider<SubmitTicketUseCase>((ref) {
  final repo = ref.watch(helpSupportRepositoryProvider);
  return SubmitTicketUseCase(repo);
});
