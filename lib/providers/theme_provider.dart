import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/hive_init.dart';

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.light) {
    _loadFromHive();
  }

  void _loadFromHive() {
    final box = HiveInit.settingsBox;
    final isDark = box.get('isDarkMode', defaultValue: false) as bool;
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void toggle() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    HiveInit.settingsBox.put('isDarkMode', state == ThemeMode.dark);
  }
}
