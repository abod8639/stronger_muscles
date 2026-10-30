import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/features/notifications/domain/entities/notification_feed_item.dart';
import 'package:stronger_muscles/features/notifications/presentation/controllers/notification_controller.dart';
import 'package:stronger_muscles/routes/routes.dart';

/// A sleek, consolidated card displaying aggregated updates for a support ticket.
/// Designed specifically to prevent notification clutter and provide immediate ticket context.
class GroupedTicketNotificationCard extends ConsumerWidget {
  final GroupedTicketNotificationFeedItem item;

  const GroupedTicketNotificationCard({
    super.key,
    required this.item,
  });

  void _handleTap(BuildContext context, WidgetRef ref) {
    if (!item.isRead) {
      ref
          .read(notificationControllerProvider.notifier)
          .markNotificationsAsRead(item.allNotificationIds);
    }

    context.push(
      AppRoutes.supportChat,
      extra: {'ticket_id': item.ticketId},
    );
  }

  void _copyTicketNumber(BuildContext context) {
    Clipboard.setData(ClipboardData(text: item.ticketNumber));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم نسخ رقم التذكرة: ${item.ticketNumber}'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  _PriorityBadgeConfig _getPriorityConfig(String? rawPriority) {
    final p = (rawPriority ?? '').toLowerCase().trim();
    if (p == 'urgent' || p == 'عاجلة' || p == 'عاجلة جداً' || p == 'critical') {
      return const _PriorityBadgeConfig(
        label: 'عاجلة جداً',
        textColor: Color(0xFFEF5350),
        backgroundColor: Color(0xFF381A1A),
      );
    }
    if (p == 'high' || p == 'مرتفعة') {
      return const _PriorityBadgeConfig(
        label: 'مرتفعة',
        textColor: Color(0xFFFFA726),
        backgroundColor: Color(0xFF382914),
      );
    }
    if (p == 'low' || p == 'منخفضة') {
      return const _PriorityBadgeConfig(
        label: 'منخفضة',
        textColor: Color(0xFF9E9E9E),
        backgroundColor: Color(0xFF26262B),
      );
    }
    // Default: normal / عادية
    return const _PriorityBadgeConfig(
      label: 'عادية',
      textColor: Color(0xFF4FA3FF),
      backgroundColor: Color(0xFF14293D),
    );
  }

  _StatusBadgeConfig _getStatusConfig(String? rawStatus) {
    final s = (rawStatus ?? '').toLowerCase().trim();
    if (s == 'waiting_user' ||
        s == 'waiting_customer' ||
        s == 'بانتظار العميل' ||
        s == 'بانتظار ردك') {
      return const _StatusBadgeConfig(
        label: 'بانتظار العميل',
        textColor: Color(0xFFE5A93C),
        backgroundColor: Color(0xFF352512),
      );
    }
    if (s == 'waiting_admin' ||
        s == 'waiting_agent' ||
        s == 'بانتظار الدعم' ||
        s == 'بانتظار الرد') {
      return const _StatusBadgeConfig(
        label: 'بانتظار الدعم',
        textColor: Color(0xFF4FA3FF),
        backgroundColor: Color(0xFF14293D),
      );
    }
    if (s == 'open' || s == 'in_progress' || s == 'مفتوحة' || s == 'قيد المعالجة') {
      return const _StatusBadgeConfig(
        label: 'مفتوحة',
        textColor: Color(0xFF4CAF50),
        backgroundColor: Color(0xFF132F1E),
      );
    }
    if (s == 'closed' || s == 'resolved' || s == 'مغلقة' || s == 'تم الحل') {
      return const _StatusBadgeConfig(
        label: 'مغلقة',
        textColor: Color(0xFFA0A0A8),
        backgroundColor: Color(0xFF26262D),
      );
    }

    return _StatusBadgeConfig(
      label: rawStatus ?? 'تذكرة دعم',
      textColor: const Color(0xFFE5A93C),
      backgroundColor: const Color(0xFF352512),
    );
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    try {
      // Produces formatted string like "10/30 • 2:24 AM"
      return DateFormat('MM/dd • h:mm a').format(dt);
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final priorityConfig = _getPriorityConfig(item.priority);
    final statusConfig = _getStatusConfig(item.status);
    final formattedDate = _formatDate(item.latestCreatedAt);

    final cardBg = isDark
        ? (item.isRead ? const Color(0xFF1A1A1E) : const Color(0xFF1E1F26))
        : (item.isRead ? Colors.white : const Color(0xFFF7F8FC));

    final borderColor = !item.isRead
        ? AppColors.primary.withValues(alpha: 0.5)
        : (isDark ? const Color(0xFF2B2B33) : const Color(0xFFE4E4E8));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: item.isRead ? 1.0 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _handleTap(context, ref),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Row: Ticket Number chip, Priority badge, and Timestamp
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Ticket Number with copy button
                        InkWell(
                          onTap: () => _copyTicketNumber(context),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF282830)
                                  : const Color(0xFFEDEDF0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.ticketNumber,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(
                                  Icons.copy_rounded,
                                  size: 13,
                                  color: isDark
                                      ? const Color(0xFFA0A0A8)
                                      : const Color(0xFF6E6E75),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Priority Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? priorityConfig.backgroundColor
                                : priorityConfig.backgroundColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            priorityConfig.label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: priorityConfig.textColor,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Timestamp
                    if (formattedDate.isNotEmpty)
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? const Color(0xFF8A8A93)
                              : const Color(0xFF75757A),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 12),

                // Middle Row: Avatar, Sender Name & Message preview
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: isDark
                          ? const Color(0xFF282832)
                          : const Color(0xFFE0E0E6),
                      backgroundImage: item.senderAvatar != null &&
                              item.senderAvatar!.isNotEmpty
                          ? NetworkImage(item.senderAvatar!)
                          : null,
                      child: item.senderAvatar == null ||
                              item.senderAvatar!.isEmpty
                          ? Icon(
                              Icons.support_agent_rounded,
                              size: 22,
                              color: isDark ? Colors.white70 : Colors.black54,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  item.senderName ?? 'الدعم الفني',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (!item.isRead) ...[
                                const SizedBox(width: 6),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.latestMessage,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.35,
                              color: isDark
                                  ? const Color(0xFFA8A8B2)
                                  : const Color(0xFF55555B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Bottom Row: Status Badge, Category & Total Messages Counter
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Status Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? statusConfig.backgroundColor
                                : statusConfig.backgroundColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            statusConfig.label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: statusConfig.textColor,
                            ),
                          ),
                        ),

                        // Category Badge
                        if (item.category != null && item.category!.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF26262D)
                                  : const Color(0xFFEDEDF2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item.category!,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? const Color(0xFFB5B5BE)
                                    : const Color(0xFF4E4E55),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    // Messages Counter
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 16,
                          color: isDark
                              ? const Color(0xFFA0A0A8)
                              : const Color(0xFF6E6E75),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${item.totalMessagesCount}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? const Color(0xFFD0D0D8)
                                : const Color(0xFF333338),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PriorityBadgeConfig {
  final String label;
  final Color textColor;
  final Color backgroundColor;

  const _PriorityBadgeConfig({
    required this.label,
    required this.textColor,
    required this.backgroundColor,
  });
}

class _StatusBadgeConfig {
  final String label;
  final Color textColor;
  final Color backgroundColor;

  const _StatusBadgeConfig({
    required this.label,
    required this.textColor,
    required this.backgroundColor,
  });
}

