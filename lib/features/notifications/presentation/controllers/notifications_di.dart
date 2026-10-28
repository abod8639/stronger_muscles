import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/notifications/data/datasources/notification_local_data_source.dart';
import 'package:stronger_muscles/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:stronger_muscles/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:stronger_muscles/features/notifications/domain/repositories/notification_repository.dart';
import 'package:stronger_muscles/features/notifications/domain/usecases/delete_notification_usecase.dart';
import 'package:stronger_muscles/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:stronger_muscles/features/notifications/domain/usecases/get_unread_count_usecase.dart';
import 'package:stronger_muscles/features/notifications/domain/usecases/mark_all_as_read_usecase.dart';
import 'package:stronger_muscles/features/notifications/domain/usecases/mark_as_read_usecase.dart';

// ── Data Layer Providers ─────────────────────────────────────────────────────

final notificationLocalDataSourceProvider =
    Provider<NotificationLocalDataSource>((ref) {
  return NotificationLocalDataSourceImpl();
});

final notificationRemoteDataSourceProvider =
    Provider<NotificationRemoteDataSource>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return NotificationRemoteDataSourceImpl(apiService);
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final remoteDataSource = ref.watch(notificationRemoteDataSourceProvider);
  final localDataSource = ref.watch(notificationLocalDataSourceProvider);
  return NotificationRepositoryImpl(remoteDataSource, localDataSource);
});

// ── Domain UseCase Providers ─────────────────────────────────────────────────

final getNotificationsUseCaseProvider = Provider<GetNotificationsUseCase>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return GetNotificationsUseCase(repository);
});

final getUnreadCountUseCaseProvider = Provider<GetUnreadCountUseCase>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return GetUnreadCountUseCase(repository);
});

final markAsReadUseCaseProvider = Provider<MarkAsReadUseCase>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return MarkAsReadUseCase(repository);
});

final markAllAsReadUseCaseProvider = Provider<MarkAllAsReadUseCase>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return MarkAllAsReadUseCase(repository);
});

final deleteNotificationUseCaseProvider = Provider<DeleteNotificationUseCase>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return DeleteNotificationUseCase(repository);
});
