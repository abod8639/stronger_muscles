import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_message_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_ticket_entity.dart';

abstract class SupportChatRepository {
  Future<Either<Failure, SupportTicketEntity>> getTicketDetails(String ticketId);
  Future<Either<Failure, SupportMessageEntity>> sendMessage({
    required String ticketId,
    required String message,
  });
  Future<Either<Failure, SupportTicketEntity>> closeTicket(String ticketId);
}

