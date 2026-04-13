import 'package:Riden/auth/sign_up_screen.dart';
import 'package:Riden/splash/splash_screen.dart';
import 'package:Riden/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  // Inject the ThemeController for GetX
  Get.put(ThemeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Obx(() {
      return GetMaterialApp(
        title: 'Riden',
        debugShowCheckedModeBanner: false,
        // Correct theme setup for Flutter 3.x+
        theme: ThemeData(
          brightness: Brightness.light,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFF80F0F),
            brightness: Brightness.light, // Fix: matches ThemeData.brightness
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFF80F0F),
            brightness: Brightness.dark, // Fix: matches ThemeData.brightness
          ),
        ),
        themeMode:
            themeController.themeMode.value, // Default dark, user-controlled
        home:  Splash(),
      );
    });
  }
}
