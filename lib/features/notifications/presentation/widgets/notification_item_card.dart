import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/notifications/domain/entities/notification_entity.dart';
import 'package:stronger_muscles/features/notifications/presentation/controllers/notification_controller.dart';
import 'package:stronger_muscles/features/notifications/presentation/widgets/notification_card_frame.dart';
import 'package:stronger_muscles/routes/routes.dart';

/// Card for a single notification; tapping marks it read and deep-links
/// to the related ticket, order or product.
class NotificationItemCard extends ConsumerWidget {
  final NotificationEntity notification;

  const NotificationItemCard({super.key, required this.notification});

  static Color _typeColor(String type) => switch (type) {
        'promo' => AppColors.warning,
        'order' => AppColors.primary,
        'system' => AppColors.error,
        'support' || 'support_ticket' => AppColors.info,
        _ => AppColors.success,
      };

  static IconData _typeIcon(String type) => switch (type) {
        'promo' => Icons.local_offer_outlined,
        'order' => Icons.local_shipping_outlined,
        'system' => Icons.security_outlined,
        'support' || 'support_ticket' => Icons.support_agent_outlined,
        _ => Icons.campaign_outlined,
      };

  void _handleTap(BuildContext context, WidgetRef ref) {
    if (!notification.isRead) {
      ref
          .read(notificationControllerProvider.notifier)
          .markAsRead(notification.id);
    }

    // 1. Support & ticket notifications navigation
    final ticketId = notification.ticketId;
    final isSupport = notification.isSupport;

    if (isSupport) {
      if (ticketId != null && ticketId.isNotEmpty) {
        context.push(
          AppRoutes.supportChat,
          extra: {'ticket_id': ticketId},
        );
      } else {
        context.push(
          AppRoutes.helpSupport,
          extra: {
            if (notification.ticketNumber != null)
              'ticket_number': notification.ticketNumber,
            'open_active_ticket': true,
          },
        );
      }
      return;
    }

    // 2. Orders navigation
    final orderId = notification.orderId;
    if (orderId != null && orderId.isNotEmpty) {
      context.push(AppRoutes.orderView);
      return;
    }

    // 3. Products navigation
    final productId = notification.productId;
    if (productId != null && productId.isNotEmpty) {
      context.push(
        AppRoutes.productDetails,
        extra: {'productId': productId},
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = context.textTheme;
    final typeColor = _typeColor(notification.type);
    final createdAt = notification.createdAt;

    return NotificationCardFrame(
      isRead: notification.isRead,
      onTap: () => _handleTap(context, ref),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconTile(
            icon: _typeIcon(notification.type),
            color: typeColor,
            backgroundColor: typeColor.withValues(alpha: 0.15),
            iconSize: 22.0,
            padding: 10.0,
            circular: true,
          ),
          const SizedBox(width: 14.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.bold,
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (!notification.isRead) ...[
                      const SizedBox(width: 6.0),
                      const UnreadDot(),
                    ],
                  ],
                ),
                const SizedBox(height: 5.0),
                Text(
                  notification.body,
                  style: textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
                if (createdAt != null) ...[
                  const SizedBox(height: 8.0),
                  Text(
                    DateFormat('yyyy/MM/dd  •  hh:mm a').format(createdAt),
                    style: textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.outline,
                      fontSize: 10.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
