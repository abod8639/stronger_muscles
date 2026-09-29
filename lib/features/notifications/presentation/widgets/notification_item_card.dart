import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/routes/routes.dart';
import '../../data/models/notification_model.dart';
import '../controllers/notification_controller.dart';

class NotificationItemCard extends ConsumerWidget {
  final NotificationModel notification;

  const NotificationItemCard({super.key, required this.notification});

  Color _getTypeColor(String type) {
    switch (type) {
      case 'promo':
        return Colors.orangeAccent;
      case 'order':
        return AppColors.primary;
      case 'system':
        return Colors.redAccent;
      default:
        return Colors.tealAccent;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'promo':
        return Icons.local_offer_outlined;
      case 'order':
        return Icons.local_shipping_outlined;
      case 'system':
        return Icons.security_outlined;
      default:
        return Icons.campaign_outlined;
    }
  }

  void _handleTap(BuildContext context, WidgetRef ref) {
    if (!notification.isRead) {
      ref.read(notificationControllerProvider.notifier).markAsRead(notification.id);
    }

    if (notification.orderId != null) {
      context.push(AppRoutes.orderView);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final typeColor = _getTypeColor(notification.type);

    final dateStr = notification.createdAt != null
        ? DateFormat('yyyy/MM/dd  •  hh:mm a').format(notification.createdAt!)
        : '';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: notification.isRead
            ? (isDark ? theme.colorScheme.surfaceContainer : Colors.white)
            : (isDark
                ? Color.lerp(theme.colorScheme.surfaceContainer, AppColors.primary, 0.08)!
                : Color.lerp(Colors.white, AppColors.primary, 0.04)!),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: notification.isRead
              ? theme.colorScheme.outlineVariant.withValues(alpha: 0.3)
              : AppColors.primary.withValues(alpha: 0.4),
          width: notification.isRead ? 1 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 8,
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Avatar
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: typeColor.withValues(alpha: 0.15),
                  ),
                  child: Icon(
                    _getTypeIcon(notification.type),
                    color: typeColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!notification.isRead) ...[
                            const SizedBox(width: 6),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        notification.body,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),
                      if (dateStr.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          dateStr,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.outline,
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
