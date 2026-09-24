import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/config/api_config.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/core/services/api_service.dart';

final pushNotificationServiceProvider = Provider<PushNotificationService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return PushNotificationService(apiService);
});

class PushNotificationService {
  final ApiService _apiService;

  PushNotificationService(this._apiService);

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
