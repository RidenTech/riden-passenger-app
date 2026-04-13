// sign_up_choice_screen.dart
// ignore_for_file: use_super_parameters, deprecated_member_use

import 'dart:ui';

import 'package:Riden/auth/sign_up_screen.dart';
import 'package:Riden/theme/app_colors.dart';
import 'package:Riden/widgets/glass_field.dart';
import 'package:Riden/widgets/riden_logo.dart'; // ← new import
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class SignUpChoiceScreen extends StatelessWidget {
  const SignUpChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const RidenDarkBackground(),
          SafeArea(
            child: SizedBox.expand(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),

                  // ── Illustration ─────────────────────────────────────────
                  Center(
                    child: SizedBox(
                      height: 208,
                      width: 310,
                      child: Image.asset(
                        'assets/images/signup_dark.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── RIDEN glassy text logo ────────────────────────────────
                  // Replaces riden_text.png asset.
                  // RidenLogo is reusable — also used on splash screen.
                  const RidenLogo(fontSize: 60),

                  const SizedBox(height: 32),

                  // ── Sign-up buttons ──────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        _SignUpIconButton(
                          asset: 'assets/images/email.png',
                          text: 'Sign up with email',
                          onTap: () => Get.to(
                            () => const SignUpScreen(),
                            transition: Transition.fadeIn,
                            duration: const Duration(milliseconds: 150),
                          ),
                        ),
                        const SizedBox(height: 9),
                        _SignUpIconButton(
                          asset: 'assets/images/google.png',
                          text: 'Sign up with Google',
                          onTap: () => Get.to(
                            () => const SignUpScreen(),
                            transition: Transition.fadeIn,
                            duration: const Duration(milliseconds: 150),
                          ),
                        ),
                        const SizedBox(height: 9),
                        _SignUpIconButton(
                          icon: Icons.phone_outlined,
                          text: 'Sign up with Phone',
                          onTap: () => Get.to(
                            () => const SignUpScreen(),
                            transition: Transition.fadeIn,
                            duration: const Duration(milliseconds: 150),
                          ),
                        ),
                        const SizedBox(height: 9),
                        _SignUpIconButton(
                          asset: 'assets/images/apple.png',
                          text: 'Sign up with Apple',
                          onTap: () => Get.to(
                            () => const SignUpScreen(),
                            transition: Transition.fadeIn,
                            duration: const Duration(milliseconds: 150),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SIGN-UP ICON BUTTON  — GlassField pill button
// ─────────────────────────────────────────────────────────────────────────────
class _SignUpIconButton extends StatelessWidget {
  final String? asset;
  final IconData? icon;
  final String text;
  final VoidCallback onTap;

  const _SignUpIconButton({
    this.asset,
    this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        height: 52,
        borderRadius: 30,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (asset != null)
              Image.asset(
                asset!,
                width: 24,
                height: 24,
                color: Colors.white,
              )
            else
              Icon(icon, size: 24, color: Colors.white),
            const SizedBox(width: 14),
            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}