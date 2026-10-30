import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/help_support/help_support_feature.dart';
import 'package:stronger_muscles/features/notifications/domain/entities/notification_feed_item.dart';
import 'package:stronger_muscles/features/notifications/presentation/controllers/notification_controller.dart';
import 'package:stronger_muscles/features/notifications/presentation/widgets/notification_card_frame.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

/// A consolidated card displaying aggregated updates for a support ticket,
/// so many replies on one ticket show as a single entry.
class GroupedTicketNotificationCard extends ConsumerWidget {
  final GroupedTicketNotificationFeedItem item;

  const GroupedTicketNotificationCard({super.key, required this.item});

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
    final copied = AppLocalizations.of(context)?.copiedToClipboard ?? 'تم النسخ إلى الحافظة';
    AppSnackBar.showInfo(context, '$copied: ${item.ticketNumber}');
  }

  /// Maps the backend's status (and its Arabic / legacy aliases) to a label
  /// and a canonical status for [ticketStatusColor].
  static ({String label, String status}) _statusOf(String? rawStatus) {
    final s = (rawStatus ?? '').toLowerCase().trim();
    return switch (s) {
      'waiting_user' || 'waiting_customer' || 'بانتظار العميل' || 'بانتظار ردك' =>
        (label: 'بانتظار العميل', status: 'waiting_user'),
      'waiting_admin' || 'waiting_agent' || 'بانتظار الدعم' || 'بانتظار الرد' =>
        (label: 'بانتظار الدعم', status: 'in_progress'),
      'open' || 'in_progress' || 'مفتوحة' || 'قيد المعالجة' =>
        (label: 'مفتوحة', status: 'open'),
      'closed' || 'resolved' || 'مغلقة' || 'تم الحل' =>
        (label: 'مغلقة', status: 'closed'),
      _ => (label: rawStatus ?? 'تذكرة دعم', status: 'open'),
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final textTheme = context.textTheme;
    final mutedColor = context.colorScheme.onSurfaceVariant;
    final status = _statusOf(item.status);
    final latestAt = item.latestCreatedAt;
    final category = item.category;

    return NotificationCardFrame(
      isRead: item.isRead,
      onTap: () => _handleTap(context, ref),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ticket number (tap to copy) and timestamp
          Row(
            children: [
              InkWell(
                onTap: () => _copyTicketNumber(context),
                borderRadius: AppRadius.allSm,
                child: AppBadge(
                  label: item.ticketNumber,
                  icon: Icons.copy_rounded,
                  color: mutedColor,
                  alpha: 0.1,
                  border: Border.all(color: Colors.transparent),
                  textStyle: textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: context.colorScheme.onSurface,
                  ),
                ),
              ),
              const Spacer(),
              if (latestAt != null)
                Text(
                  DateFormat('MM/dd • h:mm a').format(latestAt),
                  style: textTheme.labelMedium?.copyWith(color: mutedColor),
                ),
            ],
          ),
          const SizedBox(height: AppDimens.spacingMd),

          // Sender avatar, name and latest message preview
          Row(
            children: [
              AppNetworkImage(
                imageUrl: item.senderAvatar,
                width: 40.0,
                height: 40.0,
                borderRadius: AppRadius.allPill,
                errorIcon: Icons.support_agent_rounded,
              ),
              const SizedBox(width: AppDimens.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            item.senderName ?? l10n?.supportTeam ?? 'الدعم الفني',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                        ),
                        if (!item.isRead) ...[
                          const SizedBox(width: 6.0),
                          const UnreadDot(),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3.0),
                    Text(
                      item.latestMessage,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        fontSize: 13.0,
                        height: 1.35,
                        color: mutedColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spacingMd),

          // Status, category and message count
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: AppDimens.spacingSm,
                  runSpacing: AppDimens.spacingXs,
                  children: [
                    AppBadge(label: status.label, color: ticketStatusColor(status.status)),
                    if (category != null && category.isNotEmpty)
                      AppBadge(label: category, color: mutedColor, alpha: 0.1),
                  ],
                ),
              ),
              Icon(Icons.chat_bubble_outline_rounded, size: 16.0, color: mutedColor),
              const SizedBox(width: 6.0),
              Text(
                '${item.totalMessagesCount}',
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
