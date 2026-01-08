import 'dart:convert';
import 'package:get/get.dart';
import '../../config/api_config.dart';
import '../../data/models/user_model.dart';
import '../../data/models/user_stats_model.dart';
import '../../core/errors/failures.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService extends GetxService {
  final ApiService _apiService = Get.put(ApiService());

  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConfig.register,
        data: {
          'email': email,
          'password': password,
          'name': name,
        },
      );
      
      print('📝 Register Response: ${response.body}');
      
      final body = jsonDecode(response.body);
      final user = UserModel.fromJson(body['user'] ?? body);
      final token = body['token'];
      
      if (token != null) {
        await StorageService.saveToken(token);
        print('✅ Token saved successfully');
      }
      
      return user;
    } on Failure catch (e) {
      print('❌ Register API Error: ${e.message}');
      throw e.message;
    } catch (e) {
      print('❌ Register Error: $e');
      throw e.toString();
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConfig.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      print('🔐 Login Response: ${response.body}');
      
      final body = jsonDecode(response.body);
      final user = UserModel.fromJson(body['user'] ?? body);
      final token = body['token'];

      if (token != null) {
        await StorageService.saveToken(token);
        print('✅ Token saved successfully');
      }

      return user;
    } on Failure catch (e) {
      print('❌ Login API Error: ${e.message}');
      throw e.message;
    } catch (e) {
      print('❌ Login Error: $e');
      throw e.toString();
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final token = StorageService.getToken();
      if (token == null) return null;

      final response = await _apiService.get(ApiConfig.me);
      final body = jsonDecode(response.body);
      return UserModel.fromJson(body);
    } catch (e) {
      return null;
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
        data: {
          'email': email,
          'name': name,
          'photo_url': photoUrl,
        },
      );

      print('🔐 Google SignIn Response: ${response.body}');
      
      final body = jsonDecode(response.body);
      final user = UserModel.fromJson(body['user'] ?? body);
      final token = body['token'];

      if (token != null) {
        await StorageService.saveToken(token);
        print('✅ Token saved successfully');
      }

      return user;
    } on Failure catch (e) {
      print('❌ Google SignIn API Error: ${e.message}');
      throw e.message;
    } catch (e) {
      print('❌ Google SignIn Error: $e');
      throw e.toString();
    }
  }

  Future<void> logout() async {
    await StorageService.deleteToken();
  }

  // جلب بيانات إحصائيات المستخدمين
  Future<UsersStatsResponse> getUsersStats() async {
    try {
      final response = await _apiService.get(ApiConfig.usersStats);
      final body = jsonDecode(response.body);
      return UsersStatsResponse.fromJson(body);
    } catch (e) {
      rethrow;
    }
  }
}
