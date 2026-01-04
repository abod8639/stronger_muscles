import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static const String _authBoxName = 'auth_box';
  static const String _tokenKey = 'token';
  // static const String _userKey = 'user';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_authBoxName);
  }

  static Box get _authBox => Hive.box(_authBoxName);

  // Token Management
  static Future<void> saveToken(String token) async {
    await _authBox.put(_tokenKey, token);
  }

  static String? getToken() {
    return _authBox.get(_tokenKey);
  }

  static Future<void> deleteToken() async {
    await _authBox.delete(_tokenKey);
  }
  
  static bool get hasToken => getToken() != null;

  // Generic Storage
  static Future<void> saveData(String key, dynamic value) async {
    await _authBox.put(key, value);
  }

  static dynamic getData(String key) {
    return _authBox.get(key);
  }
  
  static Future<void> clearAll() async {
    await _authBox.clear();
  }
}
