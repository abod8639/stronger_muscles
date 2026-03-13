import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_controller.g.dart';

const String _themeStorageKey = 'isDarkMode';
const bool _defaultThemeIsDark = true;

@riverpod
class ThemeController extends _$ThemeController {
  late final Box _box;

  @override
  bool build() {
    _box = Hive.box('settings');
    return _box.get(_themeStorageKey, defaultValue: _defaultThemeIsDark);
  }

  ThemeMode get themeMode => state ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    state = !state;
    _box.put(_themeStorageKey, state);
  }
}
