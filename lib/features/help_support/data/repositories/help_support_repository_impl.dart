import 'dart:async';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/network_error_handler.dart';
import '../../domain/entities/faq_entity.dart';
import '../../domain/entities/support_channel_entity.dart';
import '../../domain/entities/support_message_entity.dart';
import '../../domain/entities/support_ticket_entity.dart';
import '../../domain/repositories/help_support_repository.dart';
import '../datasources/help_support_local_data_source.dart';
import '../datasources/help_support_remote_data_source.dart';
import '../mappers/help_support_mapper.dart';

/// Single Source of Truth for Help & Support data operations.
/// Orchestrates calls between RemoteDataSource (Dio) and LocalDataSource (Hive).
class HelpSupportRepositoryImpl implements HelpSupportRepository {
  final HelpSupportLocalDataSource _localDataSource;
  final HelpSupportRemoteDataSource _remoteDataSource;

  HelpSupportRepositoryImpl(this._localDataSource, this._remoteDataSource);

  @override
  Future<Either<Failure, List<FaqEntity>>> getFaqs({
    FaqCategory? category,
    String? query,
  }) async {
    return NetworkErrorHandler.execute<List<FaqEntity>>(() async {
      final models = await _localDataSource.getFaqs(category: category, query: query);
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, List<SupportChannelEntity>>> getSupportChannels() async {
    return NetworkErrorHandler.execute<List<SupportChannelEntity>>(() async {
      final models = await _localDataSource.getSupportChannels();
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, SupportTicketEntity>> submitTicket(
    SupportTicketEntity ticket,
  ) {
    return NetworkErrorHandler.execute<SupportTicketEntity>(() async {
      final model = ticket.toModel();
      try {
        final remoteModel = await _remoteDataSource.submitTicket(model).timeout(
              const Duration(seconds: 25),
              onTimeout: () => throw const TimeoutFailure(
                message: 'انتهت مهلة إرسال تذكرة الدعم، يرجى المحاولة لاحقاً',
              ),
            );
        // Cache created ticket locally
        await _localDataSource.cacheTicketDetails(remoteModel);
        final currentTickets = await _localDataSource.getUserTickets();
        await _localDataSource.cacheUserTickets([remoteModel, ...currentTickets]);
        return remoteModel.toEntity();
      } catch (error, stackTrace) {
        final failure = NetworkErrorHandler.handle(error, stackTrace);
        // Fallback to local simulation when offline/connection error
        if (failure.isConnectionError) {
          final localModel = await _localDataSource.submitTicket(model);
          return localModel.toEntity();
        }
        throw failure;
      }
    });
  }

  @override
  Future<Either<Failure, List<SupportTicketEntity>>> getUserTickets() {
    return NetworkErrorHandler.execute<List<SupportTicketEntity>>(() async {
      try {
        final remoteModels = await _remoteDataSource.getUserTickets().timeout(
              const Duration(seconds: 20),
              onTimeout: () => throw const TimeoutFailure(
                message: 'انتهت مهلة تحميل قائمة تذاكر الدعم',
              ),
            );
        await _localDataSource.cacheUserTickets(remoteModels);
        return remoteModels.map((m) => m.toEntity()).toList();
      } catch (error) {
        // Fallback to locally cached tickets if offline
        final cached = await _localDataSource.getUserTickets();
        if (cached.isNotEmpty) {
          return cached.map((m) => m.toEntity()).toList();
        }
        rethrow;
      }
    });
  }

  @override
  Future<Either<Failure, SupportTicketEntity>> getTicketDetails(
    String ticketId,
  ) {
    return NetworkErrorHandler.execute<SupportTicketEntity>(() async {
      try {
        final remoteModel =
            await _remoteDataSource.getTicketDetails(ticketId).timeout(
                  const Duration(seconds: 20),
                  onTimeout: () => throw const TimeoutFailure(
                    message: 'انتهت مهلة تحميل تفاصيل التذكرة',
                  ),
                );
        await _localDataSource.cacheTicketDetails(remoteModel);
        return remoteModel.toEntity();
      } catch (error) {
        final cached = await _localDataSource.getCachedTicketDetails(ticketId);
        if (cached != null) {
          return cached.toEntity();
        }
        rethrow;
      }
    });
  }

  @override
  Future<Either<Failure, SupportMessageEntity>> sendTicketMessage({
    required String ticketId,
    required String message,
  }) {
    return NetworkErrorHandler.execute<SupportMessageEntity>(() async {
      final remoteMsg = await _remoteDataSource
          .sendTicketMessage(ticketId, message)
          .timeout(
            const Duration(seconds: 20),
            onTimeout: () => throw const TimeoutFailure(
              message: 'انتهت مهلة إرسال الرسالة',
            ),
          );
      return remoteMsg.toEntity();
    });
  }

  @override
  Future<Either<Failure, SupportTicketEntity>> closeTicket(
    String ticketId,
  ) {
    return NetworkErrorHandler.execute<SupportTicketEntity>(() async {
      final remoteTicket =
          await _remoteDataSource.closeTicket(ticketId).timeout(
                const Duration(seconds: 20),
                onTimeout: () => throw const TimeoutFailure(
                  message: 'انتهت مهلة إغلاق التذكرة',
                ),
              );
      await _localDataSource.cacheTicketDetails(remoteTicket);
      return remoteTicket.toEntity();
    });
  }
}
