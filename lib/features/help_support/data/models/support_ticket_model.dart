import 'package:flutter/foundation.dart';
import '../../domain/entities/support_ticket_entity.dart';
import 'support_message_model.dart';

/// Data Transfer Object for support tickets, strictly decoupled from [SupportTicketEntity].
class SupportTicketModel {
  final String? id;
  final String? ticketNumber;
  final String subject;
  final String category;
  final String message;
  final String priority;
  final String status;
  final DateTime createdAt;
  final DateTime? lastReplyAt;
  final int messagesCount;
  final int unreadMessagesCount;
  final List<SupportMessageModel> messages;

  const SupportTicketModel({
    this.id,
    this.ticketNumber,
    required this.subject,
    required this.category,
    required this.message,
    this.priority = 'normal',
    this.status = 'open',
    required this.createdAt,
    this.lastReplyAt,
    this.messagesCount = 1,
    this.unreadMessagesCount = 0,
    this.messages = const [],
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
    final String fallbackTicketNum =
        idStr != null && idStr.isNotEmpty ? 'SM-$idStr' : 'SM-TICKET';

    return SupportTicketModel(
      id: idStr,
      ticketNumber:
          (json['ticket_number'] ?? json['ticketNumber'] ?? fallbackTicketNum)
              .toString(),
      subject: (json['subject'] ?? '').toString(),
      category: (json['category'] ?? 'general').toString(),
      message: (json['message'] ?? '').toString(),
      priority: (json['priority'] ?? 'normal').toString(),
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
      'priority': priority,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      if (lastReplyAt != null) 'last_reply_at': lastReplyAt!.toIso8601String(),
      'messages_count': messagesCount,
      'unread_messages_count': unreadMessagesCount,
      'messages': messages.map((m) => m.toJson()).toList(),
    };
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
