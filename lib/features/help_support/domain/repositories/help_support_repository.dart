import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/faq_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_channel_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_message_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_ticket_entity.dart';

/// Contract for Help & Support data operations using fpdart Either pattern.
abstract class HelpSupportRepository {
  Future<Either<Failure, List<FaqEntity>>> getFaqs({
    FaqCategory? category,
    String? query,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, List<SupportChannelEntity>>> getSupportChannels({
    CancelToken? cancelToken,
  });

  Future<Either<Failure, SupportTicketEntity>> submitTicket(
    SupportTicketEntity ticket, {
    CancelToken? cancelToken,
  });

  Future<Either<Failure, List<SupportTicketEntity>>> getUserTickets({
    CancelToken? cancelToken,
  });

  Future<Either<Failure, SupportTicketEntity>> getTicketDetails(
    String ticketId, {
    CancelToken? cancelToken,
  });

  Future<Either<Failure, SupportMessageEntity>> sendTicketMessage(
    String ticketId,
    String message, {
    CancelToken? cancelToken,
  });

  Future<Either<Failure, SupportTicketEntity>> closeTicket(
    String ticketId, {
    CancelToken? cancelToken,
  });
}
