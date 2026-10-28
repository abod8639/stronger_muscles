import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/notifications/data/datasources/notification_local_data_source.dart';
import 'package:stronger_muscles/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:stronger_muscles/features/notifications/data/mappers/notification_mapper.dart';
import 'package:stronger_muscles/features/notifications/data/models/notification_model.dart';
import 'package:stronger_muscles/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:stronger_muscles/features/notifications/domain/repositories/notification_repository.dart';
import 'package:stronger_muscles/features/notifications/domain/usecases/delete_notification_usecase.dart';
import 'package:stronger_muscles/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:stronger_muscles/features/notifications/domain/usecases/get_unread_count_usecase.dart';
import 'package:stronger_muscles/features/notifications/domain/usecases/mark_all_as_read_usecase.dart';
import 'package:stronger_muscles/features/notifications/domain/usecases/mark_as_read_usecase.dart';

class MockNotificationRemoteDataSource implements NotificationRemoteDataSource {
  NotificationsPayloadModel? mockPayload;
  int mockUnreadCount = 0;
  bool shouldThrow = false;
  String? markedReadId;
  String? deletedId;
  bool markAllCalled = false;

  @override
  Future<NotificationsPayloadModel> getNotifications({
    int page = 1,
    int perPage = 20,
    CancelToken? cancelToken,
  }) async {
    if (shouldThrow) {
      throw const NetworkFailure();
    }
    return mockPayload ??
        const NotificationsPayloadModel(
          notifications: [],
          unreadCount: 0,
          hasMore: false,
        );
  }

  @override
  Future<int> getUnreadCount({CancelToken? cancelToken}) async {
    if (shouldThrow) {
      throw const NetworkFailure();
    }
    return mockUnreadCount;
  }

  @override
  Future<void> markAsRead(String id, {CancelToken? cancelToken}) async {
    if (shouldThrow) {
      throw const ServerFailure(message: 'Failed to mark as read');
    }
    markedReadId = id;
  }

  @override
  Future<void> markAllAsRead({CancelToken? cancelToken}) async {
    if (shouldThrow) {
      throw const ServerFailure(message: 'Failed to mark all as read');
    }
    markAllCalled = true;
  }

  @override
  Future<void> deleteNotification(String id, {CancelToken? cancelToken}) async {
    if (shouldThrow) {
      throw const ServerFailure(message: 'Failed to delete notification');
    }
    deletedId = id;
  }
}

class MockNotificationLocalDataSource implements NotificationLocalDataSource {
  List<NotificationModel> cached = [];
  int unread = 0;

  @override
  Future<List<NotificationModel>> getCachedNotifications() async => cached;

  @override
  Future<void> cacheNotifications(List<NotificationModel> notifications) async {
    cached = List.from(notifications);
  }

  @override
  Future<int> getCachedUnreadCount() async => unread;

  @override
  Future<void> cacheUnreadCount(int count) async {
    unread = count;
  }

  @override
  Future<void> markLocalAsRead(String id) async {
    cached = cached.map((n) {
      if (n.id == id && !n.isRead) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();
    unread = cached.where((n) => !n.isRead).length;
  }

  @override
  Future<void> markAllLocalAsRead() async {
    cached = cached.map((n) => n.copyWith(isRead: true)).toList();
    unread = 0;
  }

  @override
  Future<void> deleteLocalNotification(String id) async {
    cached = cached.where((n) => n.id != id).toList();
    unread = cached.where((n) => !n.isRead).length;
  }

  @override
  Future<void> clearCache() async {
    cached.clear();
    unread = 0;
  }
}

void main() {
  group('NotificationModel Safe Parsing Tests', () {
    test('fromJson handles standard json correctly', () {
      final json = {
        'id': 'notif_1',
        'title': 'New Offer',
        'body': '50% discount on proteins',
        'type': 'promo',
        'target_type': 'all',
        'user_id': 'u123',
        'data': {'promo_id': 'promo_abc'},
        'image_url': 'https://example.com/banner.png',
        'is_read': 1,
        'created_at': '2026-10-22T00:00:00.000Z',
      };

      final model = NotificationModel.fromJson(json);

      expect(model.id, 'notif_1');
      expect(model.title, 'New Offer');
      expect(model.body, '50% discount on proteins');
      expect(model.type, 'promo');
      expect(model.isRead, isTrue);
      expect(model.promoId, 'promo_abc');
      expect(model.createdAt, isNotNull);
    });

    test('fromJson handles null, corrupt, or missing fields with fallbacks', () {
      final model = NotificationModel.fromJson(null);

      expect(model.id, '');
      expect(model.title, '');
      expect(model.body, '');
      expect(model.type, 'general');
      expect(model.isRead, isFalse);
      expect(model.createdAt, isNull);
    });

    test('NotificationModelMapper conversions work as expected', () {
      const model = NotificationModel(
        id: '1',
        title: 'Title',
        body: 'Body',
        isRead: false,
      );
      final entity = model.toEntity();

      expect(entity.id, '1');
      expect(entity.title, 'Title');
      expect(entity.isRead, isFalse);

      final backToModel = entity.toModel();
      expect(backToModel.id, '1');
      expect(backToModel.title, 'Title');
    });
  });

  group('NotificationRepositoryImpl and UseCases Tests', () {
    late MockNotificationRemoteDataSource mockRemote;
    late MockNotificationLocalDataSource mockLocal;
    late NotificationRepository repository;

    setUp(() {
      mockRemote = MockNotificationRemoteDataSource();
      mockLocal = MockNotificationLocalDataSource();
      repository = NotificationRepositoryImpl(mockRemote, mockLocal);
    });

    test('GetNotificationsUseCase returns Right and updates local cache', () async {
      mockRemote.mockPayload = const NotificationsPayloadModel(
        notifications: [
          NotificationModel(id: 'n1', title: 'Order update', body: 'Dispatched', isRead: false),
        ],
        unreadCount: 1,
        hasMore: true,
      );

      final useCase = GetNotificationsUseCase(repository);
      final result = await useCase();

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should be right'),
        (payload) {
          expect(payload.notifications.length, 1);
          expect(payload.unreadCount, 1);
          expect(payload.hasMore, isTrue);
          expect(payload.notifications.first.id, 'n1');
        },
      );
      expect(mockLocal.cached.length, 1);
      expect(mockLocal.unread, 1);
    });

    test('GetNotificationsUseCase falls back to local cache on network error', () async {
      mockLocal.cached = [
        const NotificationModel(id: 'cached_1', title: 'Cached notif', body: 'Body'),
      ];
      mockLocal.unread = 1;
      mockRemote.shouldThrow = true;

      final useCase = GetNotificationsUseCase(repository);
      final result = await useCase();

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should be right from cache'),
        (payload) {
          expect(payload.notifications.length, 1);
          expect(payload.notifications.first.id, 'cached_1');
        },
      );
    });

    test('GetUnreadCountUseCase returns count and caches it', () async {
      mockRemote.mockUnreadCount = 5;

      final useCase = GetUnreadCountUseCase(repository);
      final result = await useCase();

      expect(result.isRight(), isTrue);
      expect(result.getOrElse((_) => 0), 5);
      expect(mockLocal.unread, 5);
    });

    test('MarkAsReadUseCase updates cache and calls remote', () async {
      mockLocal.cached = [
        const NotificationModel(id: 'n123', title: 'Title', body: 'Body', isRead: false),
      ];
      mockLocal.unread = 1;

      final useCase = MarkAsReadUseCase(repository);
      final result = await useCase('n123');

      expect(result.isRight(), isTrue);
      expect(mockRemote.markedReadId, 'n123');
    });

    test('MarkAllAsReadUseCase delegates successfully', () async {
      final useCase = MarkAllAsReadUseCase(repository);
      final result = await useCase();

      expect(result.isRight(), isTrue);
      expect(mockRemote.markAllCalled, isTrue);
    });

    test('DeleteNotificationUseCase removes from cache and calls remote', () async {
      mockLocal.cached = [
        const NotificationModel(id: 'del_1', title: 'Delete me', body: 'Body'),
      ];

      final useCase = DeleteNotificationUseCase(repository);
      final result = await useCase('del_1');

      expect(result.isRight(), isTrue);
      expect(mockRemote.deletedId, 'del_1');
      expect(mockLocal.cached.isEmpty, isTrue);
    });
  });
}
