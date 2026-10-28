import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stronger_muscles/core/config/api_config.dart';
import 'package:stronger_muscles/core/errors/exceptions.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/auth/data/models/user_model.dart';

/// Top-level compute isolate parser to prevent UI thread stuttering during JSON parsing.
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

  return UserModel.fromJson(userMap);
}

/// Abstract contract for remote authentication data source.
abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> googleSignIn();

  Future<UserModel?> getCurrentUser();

  Future<UserModel> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    String? preferredLanguage,
    bool? notificationsEnabled,
  });

  Future<void> logout();
}

/// Production implementation of [AuthRemoteDataSource] utilizing [ApiService] and [Dio].
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService _apiService;
  final GoogleSignIn? _googleSignInInstance;
  final Duration _authTimeout;

  AuthRemoteDataSourceImpl({
    required ApiService apiService,
    GoogleSignIn? googleSignIn,
    Duration authTimeout = const Duration(seconds: 20),
  })  : _apiService = apiService,
        _googleSignInInstance = googleSignIn,
        _authTimeout = authTimeout;

  GoogleSignIn get _googleSignIn => _googleSignInInstance ?? GoogleSignIn.instance;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiService.post(
      ApiConfig.login,
      data: {'email': email, 'password': password},
      timeout: _authTimeout,
    );

    return await compute(parseUserFromResponse, response.data);
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _apiService.post(
      ApiConfig.register,
      data: {'name': name, 'email': email, 'password': password},
      timeout: _authTimeout,
    );

    return await compute(parseUserFromResponse, response.data);
  }

  @override
  Future<UserModel> googleSignIn() async {
    try {
      try {
        await _googleSignIn.initialize();
      } catch (_) {
        // Safe to ignore if already initialized in this process
      }

      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final response = await _apiService.post(
        ApiConfig.googleSignIn,
        data: {
          'email': googleUser.email,
          'name': googleUser.displayName ?? '',
          'photo_url': googleUser.photoUrl,
        },
        timeout: _authTimeout,
      );

      return await compute(parseUserFromResponse, response.data);
    } on DioException {
      rethrow;
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException(message: 'فشلت عملية تسجيل الدخول باستخدام Google: $e');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final response = await _apiService.get(
      ApiConfig.customerProfile,
      timeout: _authTimeout,
    );

    return await compute(parseUserFromResponse, response.data);
  }

  @override
  Future<UserModel> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    String? preferredLanguage,
    bool? notificationsEnabled,
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
      timeout: _authTimeout,
    );

    return await compute(parseUserFromResponse, response.data);
  }

  @override
  Future<void> logout() async {
    await _apiService.post(
      ApiConfig.logout,
      timeout: const Duration(seconds: 10),
    );
  }
}
