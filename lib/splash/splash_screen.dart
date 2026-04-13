import 'package:Riden/auth/sign_in_screen.dart';
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

    // Navigate to SignInScreen after a delay
    Future.delayed(const Duration(milliseconds: 2000), () {
      Get.off(
        () => const SignInScreen(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 200),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const BackgroundImage(
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(right: 50,top: 50  ),
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
