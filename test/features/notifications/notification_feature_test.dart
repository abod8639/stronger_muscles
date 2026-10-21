import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:stronger_muscles/features/notifications/data/models/notification_model.dart';
import 'package:stronger_muscles/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:stronger_muscles/features/notifications/domain/repositories/notification_repository.dart';

class MockNotificationRemoteDataSource implements NotificationRemoteDataSource {
  Map<String, dynamic>? mockNotificationsResponse;
  int mockUnreadCount = 0;
  bool shouldThrow = false;
  String? markedReadId;
  bool markAllCalled = false;

  @override
  Future<Map<String, dynamic>> getNotifications({
    int page = 1,
    int perPage = 20,
    CancelToken? cancelToken,
  }) async {
    if (shouldThrow) {
      throw const NetworkFailure();
    }
    return mockNotificationsResponse ??
        {
          'notifications': <NotificationModel>[],
          'unread_count': 0,
        };
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

    test('fromJsonList drops invalid elements defensively without crashing', () {
      final rawList = [
        {'id': '1', 'title': 'Valid'},
        'corrupt_string_element',
        null,
        {'id': '2', 'title': 'Also Valid'},
      ];

      final list = NotificationModel.fromJsonList(rawList);

      expect(list.length, 2);
      expect(list[0].id, '1');
      expect(list[1].id, '2');
    });
  });

  group('NotificationRepositoryImpl Tests', () {
    late MockNotificationRemoteDataSource mockDataSource;
    late NotificationRepository repository;

    setUp(() {
      mockDataSource = MockNotificationRemoteDataSource();
      repository = NotificationRepositoryImpl(mockDataSource);
    });

    test('getNotifications returns Right with NotificationsPayloadEntity', () async {
      mockDataSource.mockNotificationsResponse = {
        'notifications': [
          const NotificationModel(id: 'n1', title: 'Order update', body: 'Dispatched'),
        ],
        'unread_count': 1,
      };

      final result = await repository.getNotifications();

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should be right'),
        (payload) {
          expect(payload.notifications.length, 1);
          expect(payload.unreadCount, 1);
          expect(payload.notifications.first.id, 'n1');
        },
      );
    });

    test('getNotifications returns Left on NetworkFailure', () async {
      mockDataSource.shouldThrow = true;

      final result = await repository.getNotifications();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<NetworkFailure>());
        },
        (_) => fail('Should be left'),
      );
    });

    test('markAsRead delegates successfully and returns Right(unit)', () async {
      final result = await repository.markAsRead('n123');

      expect(result.isRight(), isTrue);
      expect(mockDataSource.markedReadId, 'n123');
    });

    test('markAllAsRead delegates successfully and returns Right(unit)', () async {
      final result = await repository.markAllAsRead();

      expect(result.isRight(), isTrue);
      expect(mockDataSource.markAllCalled, isTrue);
    });
  });
}
