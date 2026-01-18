import 'dart:convert';
import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/address_model.dart';
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
        includeAuth: false,
        data: {
          'email': email,
          'password': password,
          'name': name,
        },
      );
      
      print('📝 Register Response: ${response.body}');
      
      final body = jsonDecode(response.body);
      final Map<String, dynamic> userMap = Map<String, dynamic>.from(body['user'] ?? body['data'] ?? body);
      final String? token = body['token']?.toString();

      if (token != null) {
        userMap['token'] = token;
        await StorageService.saveToken(token);
        print('✅ Token saved successfully');
      }
      
      return UserModel.fromJson(userMap);
    } on Failure catch (e) {
      print('❌ Register API Error: ${e.message}');
      throw e.message;
    } catch (e) {
      print('❌ Register Error: $e');
      throw 'حدث خطأ أثناء إنشاء الحساب: ${e.toString()}';
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConfig.login,
        includeAuth: false,
        data: {
          'email': email,
          'password': password,
        },
      );

      print('🔐 Login Response: ${response.body}');
      
      final body = jsonDecode(response.body);
      
      if (body['status'] == 'error' || (body['status'] == 'success' && body['user'] == null && body['token'] == null)) {
         throw Failure(message: body['message'] ?? 'فشل تسجيل الدخول', type: FailureType.auth);
      }

      final Map<String, dynamic> userMap = Map<String, dynamic>.from(body['user'] ?? body['data'] ?? body);
      final String? token = body['token']?.toString();

      if (token != null) {
        userMap['token'] = token;
        await StorageService.saveToken(token);
        print('✅ Token saved successfully');
      }
    
      return UserModel.fromJson(userMap);
    } on Failure catch (e) {
      print('❌ Login API Error: ${e.message}');
      throw e.message;
    } catch (e) {
      print('❌ Login Error: $e');
      throw 'حدث خطأ أثناء محاولة تسجيل الدخول: ${e.toString()}';
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final token = StorageService.getToken();
      if (token == null) return null;

      final response = await _apiService.get(ApiConfig.customerProfile);
      print('👤 Get Current User Response: ${response.body}');
      
      final body = jsonDecode(response.body);
      final Map<String, dynamic> userMap = Map<String, dynamic>.from(body['user'] ?? body['data'] ?? body);
      
      // Inject existing token into the model if not present in response
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
    List<AddressModel>? addresses,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConfig.updateProfileRoute,
        data: {
          if (name != null) 'name': name,
          if (email != null) 'email': email,
          if (phone != null) 'phone': phone,
          if (photoUrl != null) 'photo_url': photoUrl,
          if (addresses != null) 'addresses': addresses.map((e) => e.toJson()).toList(),
        },
      );

      print('📝 Update Profile Response: ${response.body}');
      
      final body = jsonDecode(response.body);
      final Map<String, dynamic> userMap = Map<String, dynamic>.from(body['user'] ?? body['data'] ?? body);
      
      // Keep existing token
      final token = StorageService.getToken();
      if (token != null && userMap['token'] == null) {
        userMap['token'] = token;
      }
      
      return UserModel.fromJson(userMap);
    } on Failure catch (e) {
      print('❌ Update Profile API Error: ${e.message}');
      throw e.message;
    } catch (e) {
      print('❌ Update Profile Error: $e');
      throw 'حدث خطأ أثناء تحديث البيانات: ${e.toString()}';
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
        includeAuth: false,
        data: {
          'email': email,
          'name': name,
          'photo_url': photoUrl,
        },
      );

      print('🔐 Google SignIn Response: ${response.body}');
      
      final body = jsonDecode(response.body);
      final Map<String, dynamic> userMap = Map<String, dynamic>.from(body['user'] ?? body['data'] ?? body);
      final String? token = body['token']?.toString();

      if (token != null) {
        userMap['token'] = token;
        await StorageService.saveToken(token);
        print('✅ Token saved successfully');
      }

      return UserModel.fromJson(userMap);
    } on Failure catch (e) {
      print('❌ Google SignIn API Error: ${e.message}');
      throw e.message;
    } catch (e) {
      print('❌ Google SignIn Error: $e');
      throw 'حدث خطأ أثناء تسجيل الدخول عبر جوجل: ${e.toString()}';
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

  Future<void> deleteUser() async {
    try {
      await _apiService.delete(ApiConfig.customerProfile);
      await StorageService.deleteToken();
    } catch (e) {
      rethrow;
    }
  }


}
