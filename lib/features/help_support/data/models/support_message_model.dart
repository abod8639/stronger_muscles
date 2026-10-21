import 'package:flutter/foundation.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_message_entity.dart';

class SupportMessageModel extends SupportMessageEntity {
  const SupportMessageModel({
    required super.id,
    required super.ticketId,
    required super.senderType,
    required super.senderName,
    required super.message,
    required super.createdAt,
    super.isRead,
  });

  /// Defensive JSON deserializer with safe fallback defaults preventing TypeError.
  factory SupportMessageModel.fromJson(Map<String, dynamic> json) {
    return SupportMessageModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      ticketId: json['ticket_id'] is int
          ? json['ticket_id'] as int
          : int.tryParse(json['ticket_id']?.toString() ?? json['ticketId']?.toString() ?? '0') ?? 0,
      senderType: (json['sender_type'] ?? json['senderType'] ?? 'user').toString(),
      senderName: (json['sender_name'] ?? json['senderName'] ?? 'مستخدم').toString(),
      message: (json['message'] ?? '').toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : (json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
              : DateTime.now()),
      isRead: json['is_read'] == true || json['is_read'] == 1 || json['isRead'] == true,
    );
  }

  /// Parses an individual message asynchronously via compute.
  static Future<SupportMessageModel> fromJsonAsync(Map<String, dynamic> json) {
    return compute(_parseMessageIsolate, json);
  }

  /// Parses a collection of messages on a background isolate to prevent UI stutters.
  static Future<List<SupportMessageModel>> parseListAsync(List<dynamic> list) {
    return compute(_parseMessageListIsolate, list);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticket_id': ticketId,
      'sender_type': senderType,
      'sender_name': senderName,
      'message': message,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead,
    };
  }
}

SupportMessageModel _parseMessageIsolate(Map<String, dynamic> json) {
  return SupportMessageModel.fromJson(json);
}

List<SupportMessageModel> _parseMessageListIsolate(List<dynamic> rawList) {
  return rawList
      .whereType<Map>()
      .map((item) => SupportMessageModel.fromJson(Map<String, dynamic>.from(item)))
      .toList();
}
