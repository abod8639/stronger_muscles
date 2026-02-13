import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

const String _themeStorageKey = 'isDarkMode';
const bool _defaultThemeIsDark = true;

class ThemeController extends GetxController {
  final _box = Hive.box('settings');

  RxBool isDarkMode = _defaultThemeIsDark.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = _box.get(
      _themeStorageKey,
      defaultValue: _defaultThemeIsDark,
    );
  }

  ThemeMode get themeMode =>
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(themeMode);
    _box.put(_themeStorageKey, isDarkMode.value);
  }
}
