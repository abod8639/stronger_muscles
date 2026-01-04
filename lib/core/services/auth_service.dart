import 'dart:convert';
import 'package:get/get.dart';
import '../../config/api_config.dart';
import '../../data/models/user_model.dart';
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
      
      final body = jsonDecode(response.body);
      final user = UserModel.fromJson(body['user']);
      final token = body['token'];
      
      if (token != null) {
        await StorageService.saveToken(token);
      }
      
      return user;
    } catch (e) {
      rethrow;
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

      final body = jsonDecode(response.body);
      final user = UserModel.fromJson(body['user']);
      final token = body['token'];

      if (token != null) {
        await StorageService.saveToken(token);
      }

      return user;
    } catch (e) {
      rethrow;
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

  Future<void> logout() async {
    await StorageService.deleteToken();
  }
}
