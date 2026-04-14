import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/riden_top_bar.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final _fullNameController = TextEditingController(text: "Haris Mehmood");
  final _emailController = TextEditingController(text: "haris@riden.tech");
  final _phoneController = TextEditingController(text: "3123456789");
  
  String _selectedCountryName = 'Pakistan';
  String _selectedCountryCode = '+92';
  String? _selectedGender = 'Male';

  final List<Map<String, String>> _countryCodes = [
    {'code': '+1', 'flag': '🇨🇦', 'name': 'Canada'},
    {'code': '+92', 'flag': '🇵🇰', 'name': 'Pakistan'},
    {'code': '+44', 'flag': '🇬🇧', 'name': 'UK'},
    {'code': '+1', 'flag': '🇺🇸', 'name': 'USA'},
    {'code': '+91', 'flag': '🇮🇳', 'name': 'India'},
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Map Background — top 20%
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.20,
            child: Image.asset(
              "assets/images/map.png",
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.6),
            ),
          ),

          // Branding & Top Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  const RidenBranding(),
                  const SizedBox(height: 15),
                  RidenTopBar(onBack: () => Navigator.pop(context)),
                ],
              ),
            ),
          ),

          // Bottom Sheet Container — covering ~80%
          Positioned(
            top: screenHeight * 0.16,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF030408),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 30),
                  child: Column(
                    children: [
                      // Profile Header
                      _buildProfileHeader(),
                      const SizedBox(height: 30),

                      // Form Fields
                      CustomTextField(
                        label: 'Full Name',
                        hintText: 'Enter your full name',
                        controller: _fullNameController,
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        label: 'Email',
                        hintText: 'Enter your email',
                        controller: _emailController,
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        label: 'Phone Number',
                        hintText: 'Enter your phone number',
                        controller: _phoneController,
                        prefixIcon: SizedBox(
                          width: 85,
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
                                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54, size: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      CustomDropdownField(
                        label: 'Gender',
                        hintText: 'Select gender',
                        value: _selectedGender,
                        items: ['Male', 'Female', 'Other']
                            .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedGender = v),
                      ),
                      const SizedBox(height: 40),

                      // Update Button
                      PrimaryButton(
                        text: 'Update',
                        onPressed: () {
                          Get.back();
                          Get.snackbar(
                            "Success",
                            "Profile updated successfully",
                            backgroundColor: Colors.green.withOpacity(0.7),
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                            margin: const EdgeInsets.all(20),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue[600]!, width: 2),
              ),
              child: const CircleAvatar(
                radius: 45,
                backgroundImage: AssetImage("assets/images/profile.png"),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF174AB7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          "Jackson Morgan",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "jackson@riden.tech",
          style: GoogleFonts.poppins(
            color: Colors.white54,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
