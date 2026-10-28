import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/faq_entity.dart';
import '../entities/support_channel_entity.dart';
import '../entities/support_message_entity.dart';
import '../entities/support_ticket_entity.dart';

/// Pure Dart contract for Help & Support data operations using fpdart Either pattern.
///
/// Contains zero dependencies on Flutter UI, Dio, Hive, or 3rd-party SDKs.
abstract class HelpSupportRepository {
  Future<Either<Failure, List<FaqEntity>>> getFaqs({
    FaqCategory? category,
    String? query,
  });

  Future<Either<Failure, List<SupportChannelEntity>>> getSupportChannels();

  Future<Either<Failure, SupportTicketEntity>> submitTicket(
    SupportTicketEntity ticket,
  );

  Future<Either<Failure, List<SupportTicketEntity>>> getUserTickets();

  Future<Either<Failure, SupportTicketEntity>> getTicketDetails(
    String ticketId,
  );

  Future<Either<Failure, SupportMessageEntity>> sendTicketMessage({
    required String ticketId,
    required String message,
  });

  Future<Either<Failure, SupportTicketEntity>> closeTicket(
    String ticketId,
  );
}
