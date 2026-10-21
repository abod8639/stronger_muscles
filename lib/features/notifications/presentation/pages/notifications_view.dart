import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import '../controllers/notification_controller.dart';
import '../widgets/notification_item_card.dart';

class NotificationsView extends ConsumerWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationControllerProvider);
    final notifier = ref.read(notificationControllerProvider.notifier);
    final l10n = AppLocalizations.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final theme = Theme.of(context);

    final unreadCount = state.value?.unreadCount ?? 0;

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
          if (data.notifications.isEmpty) {
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

          return RefreshIndicator(
            onRefresh: () => notifier.refresh(),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: data.notifications.length,
              itemBuilder: (context, index) {
                if (index < 0 || index >= data.notifications.length) {
                  return const SizedBox.shrink();
                }
                final notification = data.notifications[index];
                return NotificationItemCard(notification: notification);
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
