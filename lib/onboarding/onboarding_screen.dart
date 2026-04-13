import 'package:Riden/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RidenOnboardingScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final String centerImage;
  final Widget? nextScreen;
  final bool isLast;
  final String rightWaveAsset;
  const RidenOnboardingScreen({
    required this.title,
    required this.subtitle,
    required this.centerImage,
    this.nextScreen,
    this.isLast = false,
    this.rightWaveAsset = 'assets/1.png',
    super.key,
  });

  @override
  State<RidenOnboardingScreen> createState() => _RidenOnboardingScreenState();
}

class _RidenOnboardingScreenState extends State<RidenOnboardingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic));

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _anim.forward();
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _onNext() {
    if (widget.isLast || widget.nextScreen == null) {
      Get.back();
    } else {
      Get.to(() => widget.nextScreen!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double imgW = size.width * 0.22;
    final double circleTop = size.height * 0.68;
    final double circleH = size.height * 0.19;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            // 1. Background
            const RidenDarkBackground(),

            // 2. Top-left floral
            Positioned(
              top: 0,
              left: 0,
              width: size.width * 0.52,
              height: size.height * 0.28,
              child: Image.asset(
                'assets/on1.1.png',
                fit: BoxFit.contain,
                alignment: Alignment.topLeft,
              ),
            ),

            // 3. Bottom-left floral
            Positioned(
              bottom: 0,
              left: 0,
              width: size.width * 2.50,
              height: size.height * 0.45,
              child: Image.asset(
                'assets/on1.3.png',
                fit: BoxFit.contain,
                alignment: Alignment.bottomLeft,
              ),
            ),

            // 4. Right-side wave
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              width: imgW,
              child: Image.asset(
                widget.rightWaveAsset,
                fit: BoxFit.fill,
                alignment: Alignment.centerRight,
              ),
            ),

            // 5. Transparent tap target over arrow circle
            Positioned(
              top: circleTop,
              right: 0,
              width: imgW,
              height: circleH,
              child: GestureDetector(
                onTap: _onNext,
                behavior: HitTestBehavior.opaque,
                child: const SizedBox.expand(),
              ),
            ),

            // 6. Main content
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Center(
                      child: Text(
                        'RIDEN',
                        style: GoogleFonts.audiowide(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: RidenColors.textPrimary,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                  // Centre illustration
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Center(
                        child: Image.asset(
                          widget.centerImage,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  // Heading + subtitle
                  FadeTransition(
                    opacity: _fade,
                    child: SlideTransition(
                      position: _slide,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          24,
                          0,
                          size.width * 0.26,
                          32,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: GoogleFonts.outfit(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                color: RidenColors.brandRed,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              widget.subtitle,
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: RidenColors.textSecondary,
                                height: 1.55,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // 7. iOS home indicator
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 134,
                  height: 5,
                  decoration: BoxDecoration(
                    color: RidenColors.homeIndicator,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── HOW TO USE THE REUSABLE CLASS ──────────

// You create your onboarding flow like this in your main.dart or routes:

//
// RidenOnboardingScreen(
//   title: "Move Your Way",
//   subtitle: "Create your own path, move freely,\nand live life on your terms.",
//   centerImage: "assets/on1.2.png",
//   nextScreen: RidenOnboardingScreen(
//     title: "Ride with Ease",
//     subtitle: "Experience smooth, stress-free \ntravel designed for comfort, freedom, and simplicity.",
//     centerImage: "assets/2.png",
//     nextScreen: RidenOnboardingScreen(
//       title: "Wherever You Go",
//       subtitle: "Stay connected, stay comfortable \n— smart travel solutions for every destination.",
//       centerImage: "assets/3.png",
//       isLast: true,
//     ),
//   ),
// ),
//

// Or you can declare three variables:
//
//  final onboarding1 = RidenOnboardingScreen(
//    title: "Move Your Way",
//    subtitle: "Create your own path, move freely,\nand live life on your terms.",
//    centerImage: "assets/on1.2.png",
//    nextScreen: onboarding2,
//  );
//
//  final onboarding2 = RidenOnboardingScreen(
//    title: "Ride with Ease",
//    subtitle: "Experience smooth, stress-free \ntravel designed for comfort, freedom, and simplicity.",
//    centerImage: "assets/2.png",
//    nextScreen: onboarding3,
//  );
//
//  final onboarding3 = RidenOnboardingScreen(
//    title: "Wherever You Go",
//    subtitle: "Stay connected, stay comfortable \n— smart travel solutions for every destination.",
//    centerImage: "assets/3.png",
//    isLast: true,
//  );
