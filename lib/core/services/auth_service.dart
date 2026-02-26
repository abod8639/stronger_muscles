import 'package:get/get.dart';
import '../../config/api_config.dart';
import '../../data/models/user_model.dart';
import '../../data/models/user_stats_model.dart';
import '../../core/errors/failures.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService extends GetxService {
  // استخدام Get.find بدلاً من Put إذا كان قد تم تعريفه مسبقاً في الـ Bindings
  final ApiService _apiService = Get.find<ApiService>();

  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConfig.register,
        data: {'email': email, 'password': password, 'name': name},
      );

      final data = response.data;
      final Map<String, dynamic> userMap = Map<String, dynamic>.from(
        data['user'] ?? data['data'] ?? data,
      );
      
      final String? token = data['token']?.toString();
      if (token != null) {
        userMap['token'] = token;
        await StorageService.saveToken(token);
      }

      return UserModel.fromJson(userMap);
    } on Failure catch (e) {
      throw e.message;
    } catch (e) {
      throw 'حدث خطأ غير متوقع أثناء إنشاء الحساب';
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConfig.login,
        data: {'email': email, 'password': password},
      );

      final data = response.data;

      // فحص منطقي لحالة الاستجابة بناءً على هيكلة السيرفر لديك
      if (data['status'] == 'error') {
        throw Failure(
          message: data['message'] ?? 'فشل تسجيل الدخول',
          type: FailureType.auth,
        );
      }

      final Map<String, dynamic> userMap = Map<String, dynamic>.from(
        data['user'] ?? data['data'] ?? data,
      );
      
      final String? token = data['token']?.toString();
      if (token != null) {
        userMap['token'] = token;
        await StorageService.saveToken(token);
      }

      return UserModel.fromJson(userMap);
    } on Failure catch (e) {
      throw e.message;
    } catch (e) {
      throw 'حدث خطأ أثناء محاولة تسجيل الدخول';
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final token = StorageService.getToken();
      if (token == null) return null;

      final response = await _apiService.get(ApiConfig.customerProfile);
      final data = response.data;
      
      final Map<String, dynamic> userMap = Map<String, dynamic>.from(
        data['user'] ?? data['data'] ?? data,
      );

      if (userMap['token'] == null) {
        userMap['token'] = token;
      }

      return UserModel.fromJson(userMap);
    } catch (e) {
      print('❌ Get Current User Error: $e');
      return null;
    }
  }

  Future<UserModel> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    String? preferredLanguage,
    bool? notificationsEnabled,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConfig.updateProfileRoute,
        data: {
          if (name != null) 'name': name,
          if (email != null) 'email': email,
          if (phone != null) 'phone': phone,
          if (photoUrl != null) 'photo_url': photoUrl,
          if (preferredLanguage != null) 'preferred_language': preferredLanguage,
          if (notificationsEnabled != null) 'notifications_enabled': notificationsEnabled,
        },
      );

      final data = response.data;
      final Map<String, dynamic> userMap = Map<String, dynamic>.from(
        data['user'] ?? data['data'] ?? data,
      );

      final token = StorageService.getToken();
      if (token != null && userMap['token'] == null) {
        userMap['token'] = token;
      }

      return UserModel.fromJson(userMap);
    } on Failure catch (e) {
      throw e.message;
    } catch (e) {
      throw 'حدث خطأ أثناء تحديث البيانات';
    }
  }

  Future<UserModel> googleSignIn({
    required String email,
    required String name,
    String? photoUrl,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConfig.googleSignIn,
        data: {'email': email, 'name': name, 'photo_url': photoUrl},
      );

      final data = response.data;
      final Map<String, dynamic> userMap = Map<String, dynamic>.from(
        data['user'] ?? data['data'] ?? data,
      );
      
      final String? token = (data['token'] ?? data['access_token'])?.toString();
      if (token != null) {
        userMap['token'] = token;
        await StorageService.saveToken(token);
      }

      return UserModel.fromJson(userMap);
    } on Failure catch (e) {
      throw e.message;
    } catch (e) {
      throw 'حدث خطأ أثناء تسجيل الدخول عبر جوجل';
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.post(ApiConfig.logout);
    } catch (e) {
      print('❌ Logout API Error: $e');
    } finally {
      await StorageService.deleteToken();
    }
  }

  Future<UsersStatsResponse> getUsersStats() async {
    try {
      final response = await _apiService.get(ApiConfig.usersStats);
      return UsersStatsResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser() async {
    try {
      await _apiService.delete(ApiConfig.customerProfile);
      await StorageService.deleteToken();
    } catch (e) {
      rethrow;
    }
  }
}