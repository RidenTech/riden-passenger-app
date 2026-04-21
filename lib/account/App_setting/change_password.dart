import 'package:Riden/account/App_setting/verification_code.dart';
import 'package:Riden/widgets/custom_text_field.dart';
import 'package:Riden/widgets/riden_map_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Riden/home/notification_screen.dart';
import 'package:get/get.dart';

class ChangePasswordPhoneScreen extends StatefulWidget {
  const ChangePasswordPhoneScreen({super.key});

  @override
  State<ChangePasswordPhoneScreen> createState() =>
      _ChangePasswordPhoneScreenState();
}

class _ChangePasswordPhoneScreenState extends State<ChangePasswordPhoneScreen> {
  // Controller for the phone number field
  final _phoneNumberController = TextEditingController();
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
    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      body: Stack(
        children: [
          // ── Background Map Layer ─────────────────────────────────────
          Positioned.fill(child: RidenMapView(mapHeight: double.infinity)),

          // ── Header Content ──────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'RIDEN',
                    style: GoogleFonts.audiowide(
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600.withOpacity(0.8),
                      height: 1.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // White back button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                      // Notification bell with red dot
                      GestureDetector(
                        onTap: () => Get.to(() => const NotificationScreen()),
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.25),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white24,
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.notifications_none_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            Positioned(
                              right: 2,
                              top: 2,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Success Bottom Sheet ────────────────────────────────────
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              decoration: const BoxDecoration(
                color: Color(0xFF030408),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar indicator
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 50),

                  Text(
                    "Change Password",
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Enter your Phone Number to change Your Password",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 20),
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
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) => setState(() {
                              _selectedCountryName = value!;
                              _selectedCountryCode = _countryCodes.firstWhere(
                                (c) => c['name'] == value,
                              )['code']!;
                            }),
                            dropdownColor: const Color(0xFF1E1E1E),
                            icon: const SizedBox.shrink(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Action Button ──────────────────────────────────
                  _buildPrimaryActionButton(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryActionButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        // Precise Gradient based on 'About us (1).png'
        gradient: const LinearGradient(
          colors: [Color(0xFF6A91F2), Color(0xFF1D4AB6)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D4AB6).withOpacity(0.35),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VerifyOTPScreen()),
            );
          },
          child: Center(
            child: Text(
              "Send OTP",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
