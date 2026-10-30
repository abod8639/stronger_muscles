/// Pure domain entity representing a user notification.
/// 100% Pure Dart with zero dependencies on Flutter UI, Dio, or 3rd-party SDKs.
class NotificationEntity {
  final String id;
  final String title;
  final String body;
  final String type;
  final String targetType;
  final String? userId;
  final Map<String, dynamic>? data;
  final String? imageUrl;
  final bool isRead;
  final DateTime? createdAt;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    this.type = 'general',
    this.targetType = 'all',
    this.userId,
    this.data,
    this.imageUrl,
    this.isRead = false,
    this.createdAt,
  });

  NotificationEntity copyWith({
    String? id,
    String? title,
    String? body,
    String? type,
    String? targetType,
    String? userId,
    Map<String, dynamic>? data,
    String? imageUrl,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      targetType: targetType ?? this.targetType,
      userId: userId ?? this.userId,
      data: data ?? this.data,
      imageUrl: imageUrl ?? this.imageUrl,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String? get orderId => data?['order_id']?.toString();
  String? get promoId => data?['promo_id']?.toString();
  String? get productId => data?['product_id']?.toString();
  String? get ticketId =>
      data?['ticket_id']?.toString() ??
      data?['ticketId']?.toString();
  String? get ticketNumber =>
      data?['ticket_number']?.toString() ??
      data?['ticketNumber']?.toString();
  bool get isSupport =>
      type == 'support' ||
      type == 'support_ticket' ||
      (ticketId != null && ticketId!.isNotEmpty);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          body == other.body &&
          isRead == other.isRead;

  @override
  int get hashCode => Object.hash(id, title, body, isRead);
}

/// Pure domain container for paginated notifications and total unread count.
class NotificationsPayloadEntity {
  final List<NotificationEntity> notifications;
  final int unreadCount;
  final bool hasMore;

  const NotificationsPayloadEntity({
    required this.notifications,
    required this.unreadCount,
    this.hasMore = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationsPayloadEntity &&
          runtimeType == other.runtimeType &&
          unreadCount == other.unreadCount &&
          hasMore == other.hasMore;

  @override
  int get hashCode => Object.hash(unreadCount, hasMore);
}
