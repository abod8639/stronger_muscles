import 'package:stronger_muscles/features/help_support/domain/entities/faq_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_channel_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_message_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_ticket_entity.dart';

/// Contract for Help & Support data operations.
abstract class HelpSupportRepository {
  Future<List<FaqEntity>> getFaqs({FaqCategory? category, String? query});
  Future<List<SupportChannelEntity>> getSupportChannels();
  Future<SupportTicketEntity> submitTicket(SupportTicketEntity ticket);
  Future<List<SupportTicketEntity>> getUserTickets();
  Future<SupportTicketEntity> getTicketDetails(String ticketId);
  Future<SupportMessageEntity> sendTicketMessage(String ticketId, String message);
  Future<SupportTicketEntity> closeTicket(String ticketId);
}
