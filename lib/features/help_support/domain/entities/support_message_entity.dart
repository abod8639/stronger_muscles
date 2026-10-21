class SupportMessageEntity {
  final int id;
  final int ticketId;
  final String senderType; // 'user', 'admin', 'system'
  final String senderName;
  final String message;
  final DateTime createdAt;
  final bool isRead;

  const SupportMessageEntity({
    required this.id,
    required this.ticketId,
    required this.senderType,
    required this.senderName,
    required this.message,
    required this.createdAt,
    this.isRead = false,
  });

  bool get isUser => senderType == 'user';
  bool get isFromUser => isUser;
  bool get isAdmin => senderType == 'admin';
}
