import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/features/notifications/domain/entities/notification_feed_item.dart';
import 'package:stronger_muscles/features/notifications/presentation/controllers/notification_controller.dart';
import 'package:stronger_muscles/features/notifications/presentation/widgets/grouped_ticket_notification_card.dart';
import 'package:stronger_muscles/features/notifications/presentation/widgets/notification_card_frame.dart';
import 'package:stronger_muscles/features/notifications/presentation/widgets/notification_item_card.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class NotificationsView extends ConsumerWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationControllerProvider);
    final notifier = ref.read(notificationControllerProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    final unreadCount = ref.watch(unreadNotificationCountProvider);

    return Scaffold(
      appBar: baseAppBar(
        context,
        l10n.notifications,
        actions: [
          if (unreadCount > 0)
            IconButton(
              tooltip: l10n.markAllAsRead,
              icon: const Icon(Icons.done_all_rounded, color: AppColors.primary),
              onPressed: notifier.markAllAsRead,
            ),
        ],
      ),
      body: state.when(
        data: (data) {
          final feedItems = data.feedItems;

          if (feedItems.isEmpty) {
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: notifier.refresh,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: AppEmptyState(
                      icon: Icons.notifications_none_rounded,
                      title: l10n.noNotificationsYet,
                      subtitle: l10n.noNotificationsSubtitle,
                    ),
                  ),
                ],
              ),
            );
          }

          final isLoadingMore = ref.watch(
            notificationControllerProvider.notifier.select((n) => n.isLoadingMore),
          );
          final hasMore = ref.watch(
            notificationControllerProvider.notifier.select((n) => n.hasMore),
          );

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: notifier.refresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: AppDimens.spacingMd),
              itemCount: feedItems.length + (isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= feedItems.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppDimens.spacingLg),
                    child: Center(
                      child: SizedBox.square(
                        dimension: 24.0,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                    ),
                  );
                }

                // Trigger pagination when reaching near bottom
                if (index == feedItems.length - 3 && hasMore && !isLoadingMore) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    notifier.loadMoreNotifications();
                  });
                }

                return switch (feedItems[index]) {
                  SingleNotificationFeedItem(:final notification) => AppSwipeToDelete(
                      dismissKey: ValueKey('notification_${notification.id}'),
                      margin: NotificationCardFrame.margin,
                      onDeleted: () => notifier.deleteNotification(notification.id),
                      child: NotificationItemCard(notification: notification),
                    ),
                  final GroupedTicketNotificationFeedItem item => AppSwipeToDelete(
                      dismissKey: ValueKey('ticket_group_${item.ticketId}_${item.ticketNumber}'),
                      margin: NotificationCardFrame.margin,
                      onDeleted: () => notifier.deleteNotifications(item.allNotificationIds),
                      child: GroupedTicketNotificationCard(item: item),
                    ),
                };
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AppEmptyState(
          icon: AppErrorCard.iconFor(error),
          iconColor: AppColors.error,
          title: AppErrorCard.messageFor(error, l10n),
          actionText: l10n.retry,
          actionIcon: Icons.refresh_rounded,
          onActionTap: notifier.loadNotifications,
        ),
      ),
    );
  }
}
