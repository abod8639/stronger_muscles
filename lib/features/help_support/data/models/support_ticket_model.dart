import 'package:flutter/foundation.dart';
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

  /// Defensive JSON deserializer with safe type fallback handling preventing NullPointer and TypeError.
  factory SupportTicketModel.fromJson(Map<String, dynamic> json) {
    final rawMessages = json['messages'];
    List<SupportMessageModel> parsedMessages = [];
    if (rawMessages is List) {
      parsedMessages = rawMessages
          .whereType<Map>()
          .map((m) => SupportMessageModel.fromJson(Map<String, dynamic>.from(m)))
          .toList();
    }

    final String? idStr = json['id']?.toString();
    final String fallbackTicketNum = idStr != null && idStr.isNotEmpty ? 'SM-$idStr' : 'SM-TICKET';

    return SupportTicketModel(
      id: idStr,
      ticketNumber: (json['ticket_number'] ?? json['ticketNumber'] ?? fallbackTicketNum).toString(),
      subject: (json['subject'] ?? '').toString(),
      category: (json['category'] ?? 'general').toString(),
      message: (json['message'] ?? '').toString(),
      priority: TicketPriority.fromString(json['priority']?.toString()),
      status: (json['status'] ?? 'open').toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : (json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
              : DateTime.now()),
      lastReplyAt: json['last_reply_at'] != null
          ? DateTime.tryParse(json['last_reply_at'].toString())
          : (json['lastReplyAt'] != null
              ? DateTime.tryParse(json['lastReplyAt'].toString())
              : null),
      messagesCount: json['messages_count'] is num
          ? (json['messages_count'] as num).toInt()
          : (json['messagesCount'] is num
              ? (json['messagesCount'] as num).toInt()
              : parsedMessages.length),
      unreadMessagesCount: json['unread_messages_count'] is num
          ? (json['unread_messages_count'] as num).toInt()
          : (json['unreadMessagesCount'] is num
              ? (json['unreadMessagesCount'] as num).toInt()
              : 0),
      messages: parsedMessages,
    );
  }

  /// Parses an individual ticket asynchronously on a background isolate.
  static Future<SupportTicketModel> fromJsonAsync(Map<String, dynamic> json) {
    return compute(_parseTicketIsolate, json);
  }

  /// Parses a collection of tickets on a background isolate preventing UI thread blocking.
  static Future<List<SupportTicketModel>> parseListAsync(List<dynamic> list) {
    return compute(_parseTicketListIsolate, list);
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

SupportTicketModel _parseTicketIsolate(Map<String, dynamic> json) {
  return SupportTicketModel.fromJson(json);
}

List<SupportTicketModel> _parseTicketListIsolate(List<dynamic> rawList) {
  return rawList
      .whereType<Map>()
      .map((item) => SupportTicketModel.fromJson(Map<String, dynamic>.from(item)))
      .toList();
}
