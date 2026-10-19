import 'package:stronger_muscles/features/help_support/domain/entities/support_ticket_entity.dart';

class SupportTicketModel extends SupportTicketEntity {
  const SupportTicketModel({
    super.id,
    required super.subject,
    required super.category,
    required super.message,
    super.priority,
    required super.createdAt,
  });

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) {
    return SupportTicketModel(
      id: json['id'] as String?,
      subject: json['subject'] as String,
      category: json['category'] as String,
      message: json['message'] as String,
      priority: TicketPriority.values.firstWhere(
        (p) => p.name == json['priority'],
        orElse: () => TicketPriority.normal,
      ),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'subject': subject,
      'category': category,
      'message': message,
      'priority': priority.name,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory SupportTicketModel.fromEntity(SupportTicketEntity entity) {
    return SupportTicketModel(
      id: entity.id,
      subject: entity.subject,
      category: entity.category,
      message: entity.message,
      priority: entity.priority,
      createdAt: entity.createdAt,
    );
  }
}
