import 'package:flutter/foundation.dart';
import '../../domain/entities/support_message_entity.dart';

/// Data Transfer Object for ticket messages, strictly decoupled from [SupportMessageEntity].
class SupportMessageModel {
  final int id;
  final int ticketId;
  final String senderType; // 'user', 'admin', 'system'
  final String senderName;
  final String message;
  final DateTime createdAt;
  final bool isRead;

  const SupportMessageModel({
    required this.id,
    required this.ticketId,
    required this.senderType,
    required this.senderName,
    required this.message,
    required this.createdAt,
    this.isRead = false,
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
