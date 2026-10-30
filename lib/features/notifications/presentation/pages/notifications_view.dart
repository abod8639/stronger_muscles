import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/notifications/domain/entities/notification_feed_item.dart';
import 'package:stronger_muscles/features/notifications/presentation/controllers/notification_controller.dart';
import 'package:stronger_muscles/features/notifications/presentation/widgets/grouped_ticket_notification_card.dart';
import 'package:stronger_muscles/features/notifications/presentation/widgets/notification_item_card.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class NotificationsView extends ConsumerWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationControllerProvider);
    final notifier = ref.read(notificationControllerProvider.notifier);
    final l10n = AppLocalizations.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final theme = Theme.of(context);

    final unreadCount = ref.watch(unreadNotificationCountProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(l10n?.notifications ?? 'الإشعارات'),
        actions: [
          if (unreadCount > 0)
            IconButton(
              tooltip: isAr ? 'تحديد الكل كمقروء' : 'Mark all as read',
              icon: const Icon(Icons.done_all_rounded, color: AppColors.primary),
              onPressed: () => notifier.markAllAsRead(),
            ),
        ],
      ),
      body: state.when(
        data: (data) {
          final feedItems = data.feedItems;

          if (feedItems.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => notifier.refresh(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.5),
                            ),
                            child: Icon(
                              Icons.notifications_none_rounded,
                              size: 56,
                              color: theme.colorScheme.outline,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isAr
                                ? 'لا توجد إشعارات حتى الآن'
                                : 'No notifications yet',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isAr
                                ? 'ستظهر هنا الإشعارات وتحديثات طلباتك وعروضنا'
                                : 'Updates about orders and offers will appear here',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
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

          final count = feedItems.length + (isLoadingMore ? 1 : 0);

          return RefreshIndicator(
            onRefresh: () => notifier.refresh(),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: count,
              itemBuilder: (context, index) {
                if (index >= feedItems.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
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

                final item = feedItems[index];
                switch (item) {
                  case SingleNotificationFeedItem(:final notification):
                    return Dismissible(
                      key: ValueKey('notification_${notification.id}'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.delete_outline_rounded,
                            color: Colors.white),
                      ),
                      onDismissed: (_) {
                        notifier.deleteNotification(notification.id);
                      },
                      child: NotificationItemCard(notification: notification),
                    );

                  case GroupedTicketNotificationFeedItem():
                    return Dismissible(
                      key: ValueKey('ticket_group_${item.ticketId}_${item.ticketNumber}'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.delete_outline_rounded,
                            color: Colors.white),
                      ),
                      onDismissed: (_) {
                        notifier.deleteNotifications(item.allNotificationIds);
                      },
                      child: GroupedTicketNotificationCard(item: item),
                    );
                }
              },
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) {
          final errorMessage = error is Failure
              ? error.toMessage()
              : (error is String
                  ? error
                  : (l10n?.error ?? 'تعذر تحميل الإشعارات حالياً'));

          final isConnection = error is Failure && error.isConnectionError;

          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isConnection
                        ? Icons.wifi_off_rounded
                        : Icons.error_outline_rounded,
                    size: 64,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    errorMessage,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: () => notifier.loadNotifications(),
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(l10n?.retry ?? 'إعادة المحاولة'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
