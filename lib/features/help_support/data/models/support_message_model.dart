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

  factory SupportMessageModel.fromJson(Map<String, dynamic> json) {
    return SupportMessageModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      ticketId: json['ticket_id'] is int
          ? json['ticket_id'] as int
          : int.tryParse(json['ticket_id']?.toString() ?? '0') ?? 0,
      senderType: json['sender_type'] as String? ?? 'user',
      senderName: json['sender_name'] as String? ?? 'مستخدم',
      message: json['message'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      isRead: json['is_read'] == true || json['is_read'] == 1,
    );
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
