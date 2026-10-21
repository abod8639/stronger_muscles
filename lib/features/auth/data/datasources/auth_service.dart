import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/core/config/api_config.dart';
import 'package:stronger_muscles/core/errors/errors.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/core/services/storage_service.dart';
import 'package:stronger_muscles/features/profile/data/models/user_model.dart';

part 'auth_service.g.dart';

@Riverpod(keepAlive: true)
AuthService authService(AuthServiceRef ref) {
  return AuthService(ref.watch(apiServiceProvider));
}

/// Standalone top-level function designed to run in a background isolate via [compute]
/// to prevent UI thread freezing during JSON deserialization and validation.
UserModel parseUserFromResponse(dynamic rawData) {
  if (rawData == null) {
    throw const ParsingException(message: 'لم يتم استلام أية بيانات من الخادم');
  }

  Map<String, dynamic> dataMap;
  if (rawData is String) {
    try {
      final decoded = jsonDecode(rawData);
      if (decoded is Map<String, dynamic>) {
        dataMap = decoded;
      } else if (decoded is Map) {
        dataMap = Map<String, dynamic>.from(decoded);
      } else {
        throw const ParsingException(message: 'هيكل الاستجابة غير صالح');
      }
    } catch (e) {
      if (e is ParsingException) rethrow;
      throw ParsingException(
        message: 'فشل في تحليل صيغة JSON المستلمة',
        originalError: e,
      );
    }
  } else if (rawData is Map<String, dynamic>) {
    dataMap = rawData;
  } else if (rawData is Map) {
    dataMap = Map<String, dynamic>.from(rawData);
  } else {
    throw const ParsingException(message: 'نوع استجابة الخادم غير متوقع');
  }

  // Check explicit API error status
  final status = dataMap['status']?.toString().toLowerCase();
  if (status == 'error' || status == 'fail') {
    final msg = dataMap['message']?.toString() ?? 'فشلت عملية المصادقة';
    throw AuthException(message: msg);
  }

  // Safe extraction of nested user object
  final dynamic rawUser = dataMap['user'] ?? dataMap['data'];
  final Map<String, dynamic> userMap = rawUser is Map
      ? Map<String, dynamic>.from(rawUser)
      : Map<String, dynamic>.from(dataMap);

  // Safe token extraction
  final String? token =
      (dataMap['token'] ?? dataMap['access_token'] ?? userMap['token'])?.toString();
  if (token != null && token.isNotEmpty) {
    userMap['token'] = token;
  }

  // Robust safe fallback map to prevent TypeError and NullPointer
  final safeMap = <String, dynamic>{
    'id': userMap['id'] is int
        ? userMap['id']
        : int.tryParse(userMap['id']?.toString() ?? '') ?? 0,
    'email': userMap['email']?.toString() ?? '',
    'name': userMap['name']?.toString() ?? '',
    'phone': userMap['phone']?.toString(),
    'photo_url': userMap['photo_url']?.toString() ?? userMap['photoUrl']?.toString(),
    'default_address_id': userMap['default_address_id']?.toString(),
    'preferred_language': userMap['preferred_language']?.toString() ?? 'ar',
    'notifications_enabled': userMap['notifications_enabled'] ?? true,
    'is_active': userMap['is_active'] ?? true,
    'token': userMap['token']?.toString(),
    'role': userMap['role']?.toString(),
  };

  return UserModel.fromJson(safeMap);
}

class AuthService {
  final ApiService _apiService;
  final Duration _authTimeout = const Duration(seconds: 20);

  AuthService(this._apiService);

  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
    CancelToken? cancelToken,
  }) async {
    final response = await _apiService.post(
      ApiConfig.register,
      data: {'email': email, 'password': password, 'name': name},
      cancelToken: cancelToken,
      timeout: _authTimeout,
    );

    // Compute-isolated parsing to eliminate UI freezing
    final userModel = await compute(parseUserFromResponse, response.data);

    if (userModel.token != null && userModel.token!.isNotEmpty) {
      await StorageService.saveToken(userModel.token!);
    }

    return userModel;
  }

  Future<UserModel> login({
    required String email,
    required String password,
    CancelToken? cancelToken,
  }) async {
    final response = await _apiService.post(
      ApiConfig.login,
      data: {'email': email, 'password': password},
      cancelToken: cancelToken,
      timeout: _authTimeout,
    );

    final userModel = await compute(parseUserFromResponse, response.data);

    if (userModel.token != null && userModel.token!.isNotEmpty) {
      await StorageService.saveToken(userModel.token!);
    }

    return userModel;
  }

  Future<UserModel?> getCurrentUser({CancelToken? cancelToken}) async {
    final token = StorageService.getToken();
    if (token == null) return null;

    final response = await _apiService.get(
      ApiConfig.customerProfile,
      cancelToken: cancelToken,
      timeout: _authTimeout,
    );

    final userModel = await compute(parseUserFromResponse, response.data);
    return userModel;
  }

  Future<UserModel> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    String? preferredLanguage,
    bool? notificationsEnabled,
    CancelToken? cancelToken,
  }) async {
    final response = await _apiService.post(
      ApiConfig.updateProfileRoute,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
        'photoUrl': photoUrl,
        'preferredLanguage': preferredLanguage,
        'notificationsEnabled': notificationsEnabled,
      },
      cancelToken: cancelToken,
      timeout: _authTimeout,
    );

    final userModel = await compute(parseUserFromResponse, response.data);
    return userModel;
  }

  Future<UserModel> googleSignIn({
    required String email,
    required String name,
    String? photoUrl,
    CancelToken? cancelToken,
  }) async {
    final response = await _apiService.post(
      ApiConfig.googleSignIn,
      data: {'email': email, 'name': name, 'photo_url': photoUrl},
      cancelToken: cancelToken,
      timeout: _authTimeout,
    );

    final userModel = await compute(parseUserFromResponse, response.data);

    if (userModel.token != null && userModel.token!.isNotEmpty) {
      await StorageService.saveToken(userModel.token!);
    }

    return userModel;
  }

  Future<void> logout({CancelToken? cancelToken}) async {
    try {
      await _apiService.post(
        ApiConfig.logout,
        cancelToken: cancelToken,
        timeout: const Duration(seconds: 10),
      );
    } catch (_) {
      // Ignore network errors on logout to allow local cleanup
    } finally {
      await StorageService.deleteToken();
    }
  }
}
