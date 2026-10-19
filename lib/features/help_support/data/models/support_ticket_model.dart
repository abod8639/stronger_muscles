import 'package:stronger_muscles/features/help_support/data/models/support_message_model.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_ticket_entity.dart';

class SupportTicketModel extends SupportTicketEntity {
  const SupportTicketModel({
    super.id,
    super.ticketNumber,
    required super.subject,
    required super.category,
    required super.message,
    super.priority,
    super.status,
    required super.createdAt,
    super.lastReplyAt,
    super.messagesCount,
    super.unreadMessagesCount,
    super.messages,
  });

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) {
    var rawMessages = json['messages'];
    List<SupportMessageModel> parsedMessages = [];
    if (rawMessages is List) {
      parsedMessages = rawMessages
          .whereType<Map<String, dynamic>>()
          .map((m) => SupportMessageModel.fromJson(m))
          .toList();
    }

    return SupportTicketModel(
      id: json['id']?.toString(),
      ticketNumber: json['ticket_number'] as String? ?? 'SM-${json['id']}',
      subject: json['subject'] as String? ?? '',
      category: json['category'] as String? ?? 'general',
      message: json['message'] as String? ?? '',
      priority: TicketPriority.fromString(json['priority'] as String?),
      status: json['status'] as String? ?? 'open',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      lastReplyAt: json['last_reply_at'] != null
          ? DateTime.tryParse(json['last_reply_at'].toString())
          : null,
      messagesCount: json['messages_count'] is int ? json['messages_count'] as int : parsedMessages.length,
      unreadMessagesCount: json['unread_messages_count'] is int ? json['unread_messages_count'] as int : 0,
      messages: parsedMessages,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (ticketNumber != null) 'ticket_number': ticketNumber,
      'subject': subject,
      'category': category,
      'message': message,
      'priority': priority.toApiString(),
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory SupportTicketModel.fromEntity(SupportTicketEntity entity) {
    return SupportTicketModel(
      id: entity.id,
      ticketNumber: entity.ticketNumber,
      subject: entity.subject,
      category: entity.category,
      message: entity.message,
      priority: entity.priority,
      status: entity.status,
      createdAt: entity.createdAt,
      lastReplyAt: entity.lastReplyAt,
      messagesCount: entity.messagesCount,
      unreadMessagesCount: entity.unreadMessagesCount,
      messages: entity.messages,
    );
  }
}
