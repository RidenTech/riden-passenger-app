import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/riden_top_bar.dart';
import '../../widgets/riden_map_view.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late AuthController _authController;

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
  void initState() {
    super.initState();
    _authController = Get.find<AuthController>();

    // Initialize controllers with empty values first (to prevent null errors)
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();

    // Load user data from SharedPreferences
    _loadUserDataAndInitialize();
  }

  /// Load user data from SharedPreferences and update controllers
  Future<void> _loadUserDataAndInitialize() async {
    print('\n👤 Profile: Starting data initialization...');

    // Ensure AuthController is fully initialized
    await _authController.ensureInitialized();

    // Force reload the data from SharedPreferences
    await _authController.forceReloadUserData();

    if (mounted) {
      setState(() {
        // Update controller text with loaded data
        _fullNameController.text = _authController.userFullName.value.isNotEmpty
            ? _authController.userFullName.value
            : "User";
        _emailController.text = _authController.userEmail.value.isNotEmpty
            ? _authController.userEmail.value
            : "user@example.com";

        // Extract phone without country code
        String phone = _authController.userPhone.value;
        String countryCode = _authController.userCountryCode.value;

        // If phone includes country code, extract just the number part
        if (phone.startsWith(countryCode)) {
          phone = phone.replaceFirst(countryCode, '').trim();
        }

        _phoneController.text = phone;
        _selectedCountryCode = countryCode;
        _selectedGender = _authController.userGender.value.isNotEmpty
            ? _authController.userGender.value
            : 'Male';

        print(
          '✅ Profile loaded: ${_authController.userFullName.value} (${_authController.userEmail.value})',
        );
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

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
            child: RidenMapView(mapHeight: screenHeight * 0.20),
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
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) => setState(() {
                                  _selectedCountryName = value!;
                                  _selectedCountryCode = _countryCodes
                                      .firstWhere(
                                        (c) => c['name'] == value,
                                      )['code']!;
                                }),
                                dropdownColor: const Color(0xFF1E1E1E),
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white54,
                                  size: 16,
                                ),
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
                            .map(
                              (g) => DropdownMenuItem(value: g, child: Text(g)),
                            )
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

  /// Get user initials from full name (first letter of first name + first letter of last name)
  String _getInitials(String fullName) {
    if (fullName.isEmpty) return "U";

    List<String> names = fullName.trim().split(' ');

    if (names.length >= 2) {
      // Get first letter of first name and first letter of last name
      return (names[0][0] + names[names.length - 1][0]).toUpperCase();
    } else if (names.length == 1) {
      // If only one name, show two first letters or repeat first letter
      String name = names[0];
      return name.length >= 2
          ? name.substring(0, 2).toUpperCase()
          : (name[0] + name[0]).toUpperCase();
    }

    return "U";
  }

  /// Get initials from first name and last name separately
  String _getInitialsFromNames(String firstName, String lastName) {
    if (firstName.isEmpty && lastName.isEmpty) return "U";

    String initials = "";

    if (firstName.isNotEmpty) {
      initials += firstName[0].toUpperCase();
    }

    if (lastName.isNotEmpty) {
      initials += lastName[0].toUpperCase();
    }

    // If we only have one name part, try to use two letters from it
    if (initials.length == 1) {
      String name = firstName.isNotEmpty ? firstName : lastName;
      initials = name.length >= 2
          ? name.substring(0, 2).toUpperCase()
          : (name[0] + name[0]).toUpperCase();
    }

    return initials.isNotEmpty ? initials : "U";
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          children: [
            Obx(() {
              String firstName = _authController.userFirstName.value;
              String lastName = _authController.userLastName.value;
              String initials = _getInitialsFromNames(firstName, lastName);
              return Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue[600]!, width: 2),
                ),
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: const Color(0xFF6395FF),
                  child: Text(
                    initials,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF174AB7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() {
          String firstName = _authController.userFirstName.value;
          String lastName = _authController.userLastName.value;
          String displayName = '$firstName $lastName'.trim().isNotEmpty
              ? '$firstName $lastName'.trim()
              : "User";
          return Text(
            displayName,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          );
        }),
      ],
    );
  }
}
