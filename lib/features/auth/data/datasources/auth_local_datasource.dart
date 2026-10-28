import 'package:stronger_muscles/core/services/storage_service.dart';

/// Abstract contract for local session and token caching.
abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  String? getToken();
  Future<void> deleteToken();
  bool hasToken();
}

/// Production implementation of [AuthLocalDataSource] delegating to [StorageService].
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl();

  @override
  Future<void> saveToken(String token) async {
    await StorageService.saveToken(token);
  }

  @override
  String? getToken() {
    return StorageService.getToken();
  }

  @override
  Future<void> deleteToken() async {
    await StorageService.deleteToken();
  }

  @override
  bool hasToken() {
    return StorageService.hasToken;
  }
}
