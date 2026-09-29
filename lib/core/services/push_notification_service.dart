import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/config/api_config.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/core/services/firebase_options.dart';
import 'package:stronger_muscles/core/services/storage_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}

final pushNotificationServiceProvider = Provider<PushNotificationService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return PushNotificationService(apiService);
});

class PushNotificationService {
  final ApiService _apiService;
  final FirebaseMessaging? _messagingInstance;
  final FlutterLocalNotificationsPlugin? _localNotificationsInstance;

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important push notifications.',
    importance: Importance.max,
    playSound: true,
  );

  PushNotificationService(
    this._apiService, {
    FirebaseMessaging? messaging,
    FlutterLocalNotificationsPlugin? localNotifications,
  })  : _messagingInstance = messaging,
        _localNotificationsInstance = localNotifications;

  FirebaseMessaging get _messaging => _messagingInstance ?? FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin get _localNotifications =>
      _localNotificationsInstance ?? FlutterLocalNotificationsPlugin();

  /// Initialize Firebase Messaging, permissions, local notifications channel, and listeners.
  Future<void> initialize({void Function(RemoteMessage)? onForegroundMessage}) async {
    try {
      // 1. Request system notification permission (Android 13+ & iOS)
      await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      // 2. Setup local notification channel for heads-up foreground notifications
      const androidInitSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const darwinInitSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );
      const initSettings = InitializationSettings(
        android: androidInitSettings,
        iOS: darwinInitSettings,
      );

      await _localNotifications.initialize(settings: initSettings);

      await _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_channel);

      // 3. Synchronize device token with backend if user is already logged in
      await syncDeviceToken();

      // 4. Listen to token refreshes
      _messaging.onTokenRefresh.listen((newToken) {
        if (StorageService.hasToken) {
          registerDeviceToken(newToken);
        }
      });

      // 5. Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        final notification = message.notification;
        if (notification != null) {
          _localNotifications.show(
            id: notification.hashCode,
            title: notification.title,
            body: notification.body,
            notificationDetails: NotificationDetails(
              android: AndroidNotificationDetails(
                _channel.id,
                _channel.name,
                channelDescription: _channel.description,
                importance: Importance.max,
                priority: Priority.high,
                icon: '@mipmap/ic_launcher',
              ),
              iOS: const DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
            ),
            payload: message.data.isNotEmpty ? jsonEncode(message.data) : null,
          );
        }

        onForegroundMessage?.call(message);
      });
    } catch (_) {
      // Gracefully prevent initialization crashes on unsupported platforms/simulators
    }
  }

  /// Synchronize device token with backend if user has an auth token.
  Future<bool> syncDeviceToken() async {
    if (!StorageService.hasToken) return false;

    try {
      final token = await _messaging.getToken();
      if (token != null && token.isNotEmpty) {
        return await registerDeviceToken(token);
      }
    } catch (_) {}

    return false;
  }

  /// Synchronize FCM device registration token with the backend.
  Future<bool> registerDeviceToken(String fcmToken) async {
    if (fcmToken.trim().isEmpty) return false;

    try {
      final response = await _apiService.post(
        ApiConfig.fcmToken,
        data: {'fcm_token': fcmToken.trim()},
      );

      final data = response.data;
      if (data is Map && data['status'] == 'success') {
        return true;
      }
      return false;
    } on Failure {
      return false;
    } catch (_) {
      return false;
    }
  }
}
