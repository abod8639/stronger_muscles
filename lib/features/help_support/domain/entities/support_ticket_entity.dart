import 'support_message_entity.dart';

enum TicketPriority {
  low,
  normal,
  high,
  urgent;

  static TicketPriority fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'urgent':
        return TicketPriority.urgent;
      case 'high':
        return TicketPriority.high;
      case 'low':
        return TicketPriority.low;
      case 'normal':
      default:
        return TicketPriority.normal;
    }
  }

  String toApiString() {
    switch (this) {
      case TicketPriority.urgent:
        return 'urgent';
      case TicketPriority.high:
        return 'high';
      case TicketPriority.low:
        return 'low';
      case TicketPriority.normal:
        return 'normal';
    }
  }
}

class SupportTicketEntity {
  final String? id;
  final String? ticketNumber;
  final String subject;
  final String category;
  final String message;
  final TicketPriority priority;
  final String status; // 'open', 'in_progress', 'waiting_user', 'resolved', 'closed'
  final DateTime createdAt;
  final DateTime? lastReplyAt;
  final int messagesCount;
  final int unreadMessagesCount;
  final List<SupportMessageEntity> messages;

  const SupportTicketEntity({
    this.id,
    this.ticketNumber,
    required this.subject,
    required this.category,
    required this.message,
    this.priority = TicketPriority.normal,
    this.status = 'open',
    required this.createdAt,
    this.lastReplyAt,
    this.messagesCount = 1,
    this.unreadMessagesCount = 0,
    this.messages = const [],
  });

  SupportTicketEntity copyWith({
    String? id,
    String? ticketNumber,
    String? subject,
    String? category,
    String? message,
    TicketPriority? priority,
    String? status,
    DateTime? createdAt,
    DateTime? lastReplyAt,
    int? messagesCount,
    int? unreadMessagesCount,
    List<SupportMessageEntity>? messages,
  }) {
    return SupportTicketEntity(
      id: id ?? this.id,
      ticketNumber: ticketNumber ?? this.ticketNumber,
      subject: subject ?? this.subject,
      category: category ?? this.category,
      message: message ?? this.message,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      lastReplyAt: lastReplyAt ?? this.lastReplyAt,
      messagesCount: messagesCount ?? this.messagesCount,
      unreadMessagesCount: unreadMessagesCount ?? this.unreadMessagesCount,
      messages: messages ?? this.messages,
    );
  }

  bool get isOpen => status == 'open' || status == 'in_progress' || status == 'waiting_user';
  bool get isResolved => status == 'resolved';
  bool get isClosed => status == 'closed';
  bool get isWaitingUser => status == 'waiting_user';

  String get statusArabic {
    switch (status) {
      case 'open':
        return 'جديدة قيد المراجعة';
      case 'in_progress':
        return 'جاري العمل عليها';
      case 'waiting_user':
        return 'بانتظار ردك';
      case 'resolved':
        return 'تم الحل بنجاح';
      case 'closed':
        return 'مغلقة';
      default:
        return status;
    }
  }

  String get priorityArabic {
    switch (priority) {
      case TicketPriority.urgent:
        return 'عاجلة جداً';
      case TicketPriority.high:
        return 'مرتفعة';
      case TicketPriority.normal:
        return 'عادية';
      case TicketPriority.low:
        return 'منخفضة';
    }
  }
}
