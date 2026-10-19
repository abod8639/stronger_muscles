enum TicketPriority {
  normal,
  urgent,
}

class SupportTicketEntity {
  final String? id;
  final String subject;
  final String category;
  final String message;
  final TicketPriority priority;
  final DateTime createdAt;

  const SupportTicketEntity({
    this.id,
    required this.subject,
    required this.category,
    required this.message,
    this.priority = TicketPriority.normal,
    required this.createdAt,
  });
}
