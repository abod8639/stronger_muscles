import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/core/services/storage_service.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('storage_service_test_');
    Hive.init(tempDir.path);
    await Hive.openBox('auth_box');
  });

  setUp(() async {
    await Hive.box('auth_box').clear();
  });

  tearDownAll(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('StorageService Token Operations', () {
    test('hasToken returns false when no token is saved', () {
      expect(StorageService.getToken(), isNull);
      expect(StorageService.hasToken, isFalse);
    });

    test('saveToken persists token and hasToken becomes true', () async {
      await StorageService.saveToken('jwt-sample-token-12345');
      expect(StorageService.getToken(), 'jwt-sample-token-12345');
      expect(StorageService.hasToken, isTrue);
    });

    test('deleteToken clears stored token', () async {
      await StorageService.saveToken('token-to-delete');
      expect(StorageService.hasToken, isTrue);

      await StorageService.deleteToken();
      expect(StorageService.getToken(), isNull);
      expect(StorageService.hasToken, isFalse);
    });
  });

  group('StorageService Generic Key-Value Operations', () {
    test('saveData and getData support primitive types and maps', () async {
      await StorageService.saveData('username', 'dexter');
      await StorageService.saveData('age', 28);
      await StorageService.saveData('is_active', true);
      await StorageService.saveData('settings', {'notifications': true, 'theme': 'dark'});

      expect(StorageService.getData('username'), 'dexter');
      expect(StorageService.getData('age'), 28);
      expect(StorageService.getData('is_active'), true);
      expect(StorageService.getData('settings'), {'notifications': true, 'theme': 'dark'});
    });

    test('clearAll wipes all data from the auth box', () async {
      await StorageService.saveToken('active-token');
      await StorageService.saveData('cached_user_id', 99);

      expect(StorageService.hasToken, isTrue);
      expect(StorageService.getData('cached_user_id'), 99);

      await StorageService.clearAll();

      expect(StorageService.hasToken, isFalse);
      expect(StorageService.getToken(), isNull);
      expect(StorageService.getData('cached_user_id'), isNull);
    });
  });
}
