import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ThemeController extends GetxController {
  final _box = Hive.box('settings');
  final _key = 'isDarkMode';

  RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load theme from Hive or default to system setting (or false)
    isDarkMode.value = _box.get(_key, defaultValue: false);
  }

  ThemeMode get themeMode =>
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(themeMode);
    _box.put(_key, isDarkMode.value);
  }
}
