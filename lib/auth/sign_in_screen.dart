// ignore_for_file: deprecated_member_use

import 'package:Riden/auth/sign_up_screen.dart';
import 'package:Riden/controllers/auth_controller.dart';
import 'package:Riden/home/home_screen.dart';
import 'package:Riden/widgets/background_image.dart';
import 'package:Riden/widgets/custom_button.dart';
import 'package:Riden/widgets/custom_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  late AuthController authController;

  @override
  void initState() {
    super.initState();
    print('✅ SignInScreen initState called');
    authController = Get.put(AuthController());
    print('✅ AuthController initialized');
  }

  @override
  Widget build(BuildContext context) {
    print('🔵 SignInScreen build called');
    return BackgroundImage(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(height: 24),
              // Logo & Subtitle
              Center(
                child: Column(
                  children: [
                    Text(
                      'RIDEN',
                      style: GoogleFonts.audiowide(
                        fontSize: 45,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Input Fields
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      label: 'Email or Phone Number',
                      hintText: 'Enter your email/phone here',
                      controller: _emailController,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Password',
                      hintText: 'Enter your password',
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.white54,
                          size: 20,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Forget Password?',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Sign In Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: CustomButton(
                  text: 'Sign In',
                  isBlue: true,
                  validateFields: _validateFields,
                  onPressed: () {
                    if (!authController.isLoading.value) {
                      _handleLogin();
                    }
                  },
                ),
              ),
              const SizedBox(height: 24),
              // Divider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.white.withOpacity(0.3)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'or',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Colors.white.withOpacity(0.3)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Social Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    CustomButton(
                      text: 'Continue with Google',
                      isDark: false,
                      hasBorder: false,
                      icon: Image.asset('assets/images/google.png', width: 20),
                      onPressed: () {},
                    ),
                    const SizedBox(height: 12),
                    CustomButton(
                      text: 'Continue with Apple',
                      isDark: false,
                      hasBorder: false,
                      icon: Image.asset('assets/images/apple.png', width: 22),
                      onPressed: () {},
                    ),
                    const SizedBox(height: 12),
                    CustomButton(
                      text: 'Continue with Phone',
                      isDark: false,
                      hasBorder: false,
                      icon: Image.asset('assets/images/phone.png', width: 20),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Footer
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    children: [
                      TextSpan(
                        text: 'Sign Up',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Get.to(() => const SignUpScreen()),
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF6395FF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    // Validate email
    if (_emailController.text.isEmpty) {
      Get.snackbar('Error', 'Email is required');
      return;
    }
    // Validate password
    if (_passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Password is required');
      return;
    }
    if (_passwordController.text.length < 8) {
      Get.snackbar('Error', 'Password must be at least 8 characters');
      return;
    }

    // Call login with proper credentials
    final success = await authController.login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (success) {
      Get.offAll(() => const HomeScreen());
    }
  }

  /// Validate fields and return true if valid
  Future<bool> _validateFields() async {
    if (_emailController.text.isEmpty) {
      Get.snackbar('Error', 'Email is required');
      return false;
    }
    if (_passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Password is required');
      return false;
    }
    if (_passwordController.text.length < 8) {
      Get.snackbar('Error', 'Password must be at least 8 characters');
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
