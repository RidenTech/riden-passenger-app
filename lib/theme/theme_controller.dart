import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ThemeController extends GetxController {
  /// App-controlled theme mode.
  ///
  /// Default is dark, per product requirement.
  final Rx<ThemeMode> themeMode = ThemeMode.dark.obs;

  bool get isDark => themeMode.value == ThemeMode.dark;

  void setDark() {
    themeMode.value = ThemeMode.dark;
    Get.changeThemeMode(ThemeMode.dark);
  }

  void setLight() {
    themeMode.value = ThemeMode.light;
    Get.changeThemeMode(ThemeMode.light);
  }

  void setSystem() {
    themeMode.value = ThemeMode.system;
    Get.changeThemeMode(ThemeMode.system);
  }
}
