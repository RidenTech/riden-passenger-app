import 'package:Riden/auth/sign_in_screen.dart';
import 'package:Riden/home/home_screen.dart';
import 'package:Riden/widgets/background_image.dart';
import 'package:Riden/widgets/custom_button.dart';
import 'package:Riden/widgets/custom_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _firstNameController = TextEditingController();
  final _genderController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;

  String _selectedCountryName = 'Pakistan'; // Default: Pakistan
  String _selectedCountryCode = '+92';
  String? _selectedGender;
  final List<Map<String, String>> _countryCodes = [
    {'code': '+1', 'flag': '🇨🇦', 'name': 'Canada'},
    {'code': '+92', 'flag': '🇵🇰', 'name': 'Pakistan'},
    {'code': '+44', 'flag': '🇬🇧', 'name': 'UK'},
    {'code': '+1', 'flag': '🇺🇸', 'name': 'USA'},
    {'code': '+91', 'flag': '🇮🇳', 'name': 'India'},
  ];

  @override
  Widget build(BuildContext context) {
    return BackgroundImage(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const Spacer(flex: 3),

                        // Logo & Title
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'RIDEN',
                                style: GoogleFonts.audiowide(
                                  fontSize: 45,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF819ABE),
                                  height: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(flex: 3),

                        // Form Fields
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField(
                                label: 'First  Name',
                                hintText: 'Enter Your First Name',
                                controller: _firstNameController,
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                label: 'Last  Name',
                                hintText: 'Enter Your Last Name', 
                                controller: _lastNameController,
                              ),
                              const SizedBox(height: 16),
                              CustomDropdownField(
                                label: 'Gender ',
                                hintText: 'Select Your Gender', 
                                value: _selectedGender,
                                items: ['Male', 'Female', 'Other']
                                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                                    .toList(),
                                onChanged: (v) => setState(() => _selectedGender = v),
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                label: 'Phone Number',
                                hintText: 'Enter your phone number here',
                                controller: _phoneNumberController,
                                prefixIcon: SizedBox(
                                  width: 75,
                                  child: Center(
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _selectedCountryName,
                                        items: _countryCodes.map((country) {
                                          return DropdownMenuItem<String>(
                                            value: country['name'],
                                            child: Text(
                                              '${country['flag']} ${country['code']}',
                                              style: const TextStyle(color: Colors.white, fontSize: 13),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) => setState(() {
                                          _selectedCountryName = value!;
                                          _selectedCountryCode = _countryCodes.firstWhere((c) => c['name'] == value)['code']!;
                                        }),
                                        dropdownColor: const Color(0xFF1E1E1E),
                                        icon: const SizedBox.shrink(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                               CustomTextField(
                                label: 'Email',
                                hintText: 'Enter your email here',
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
                                    _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                    color: Colors.white54,
                                    size: 20,
                                  ),
                                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                ),
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                label: 'Confirm Password',
                                hintText: 'Retype your password',
                                controller: _confirmPasswordController,
                                obscureText: _obscurePassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                    color: Colors.white54,
                                    size: 20,
                                  ),
                                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                ),
                              ),
                            ],
                          ),
                        ), const SizedBox(height: 16),

                        const Spacer(flex: 2),

                        // Sign Up Button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: CustomButton(
                            text: 'Sign Up',
                            onPressed: () => Get.offAll(() => const HomeScreen()),
                          ),
                        ),

                        const Spacer(flex: 2),

                        // Footer
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
                              children: [
                                TextSpan(
                                  text: 'Sign In',
                                  recognizer: TapGestureRecognizer()..onTap = () => Get.to(() => const SignInScreen()),
                                  style: GoogleFonts.poppins(
                                    color: Color(0xFF6395FF),
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
            },
          ),
        ),
      ),
    );
  }
}
