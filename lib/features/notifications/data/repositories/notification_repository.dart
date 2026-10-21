import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:stronger_muscles/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:stronger_muscles/features/notifications/domain/repositories/notification_repository.dart';

export 'package:stronger_muscles/features/notifications/domain/repositories/notification_repository.dart';
export 'package:stronger_muscles/features/notifications/data/repositories/notification_repository_impl.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final remoteDataSource = ref.watch(notificationRemoteDataSourceProvider);
  return NotificationRepositoryImpl(remoteDataSource);
});
