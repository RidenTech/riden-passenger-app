import 'package:Riden/auth/sign_in_screen.dart';
import 'package:Riden/controllers/auth_controller.dart';
import 'package:Riden/home/home_screen.dart';
import 'package:Riden/widgets/background_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  late AuthController _authController;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    // Initialize AuthController
    try {
      _authController = Get.find<AuthController>();
    } catch (e) {
      _authController = Get.put(AuthController());
    }

    // Ensure AuthController is initialized, then navigate
    Future.delayed(const Duration(milliseconds: 500), () async {
      print('🔄 Splash: Ensuring AuthController is fully initialized...');

      // Ensure AuthController is fully initialized before checking login state
      await _authController.ensureInitialized();

      // Debug: Print all SharedPreferences data
      await _authController.debugPrintSharedPreferences();

      // Check if user is already logged in
      bool isLoggedIn = await _authController.isUserLoggedIn();

      if (isLoggedIn) {
        print('✅ Splash: User already logged in, navigating to HomeScreen');
        print('   Email: ${_authController.userEmail.value}');
        print('   Name: ${_authController.userFullName.value}');
        Get.off(
          () => const HomeScreen(),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 200),
        );
      } else {
        print('❌ Splash: User not logged in, navigating to SignInScreen');
        Get.off(
          () => const SignInScreen(),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 200),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const BackgroundImage(
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(right: 50, top: 50),
          child: Image(
            image: AssetImage('assets/images/RIDEN.png'),
            width: 300,
            height: 300,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
