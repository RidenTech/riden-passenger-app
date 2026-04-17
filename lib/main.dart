import 'package:Riden/splash/splash_screen.dart';
import 'package:Riden/theme/theme_controller.dart';
import 'package:Riden/controllers/navigation_controller.dart';
import 'package:Riden/services/map_cache_service.dart';
import 'package:Riden/services/global_map_service.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register controllers
  Get.put(ThemeController());
  Get.put(NavigationController());
  Get.put(MapCacheService());
  Get.put(GlobalMapService());

  // Initialize theme to DARK immediately (before runApp)
  final themeController = Get.find<ThemeController>();
  themeController.setDark();

  await MapCacheService().initializeMapCache();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    // Build dark theme configuration
    final ThemeData darkThemeData = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0A0A0A),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFF80F0F),
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0A0A0A),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
    );

    return Obx(() {
      return GetMaterialApp(
        title: 'Riden',
        debugShowCheckedModeBanner: false,
        theme: darkThemeData,
        darkTheme: darkThemeData,
        themeMode: themeController.themeMode.value,
        home: const Splash(),
      );
    });
  }
}
