import 'package:Riden/account/Aboutus/about_us.dart';
import 'package:Riden/account/App_setting/App_setting.dart';
import 'package:Riden/account/Complaints/copmplaints_tickets.dart';
import 'package:Riden/support/support.dart';
import 'package:Riden/auth/sign_in_screen.dart';
import 'package:Riden/controllers/auth_controller.dart';
import 'package:Riden/controllers/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/riden_bottom_nav.dart';
import '../widgets/riden_map_view.dart';
import 'payment_method/payment_method.dart';
import 'profile/my_profile.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final authController = Get.find<AuthController>();
      await authController.ensureInitialized();
      await authController.forceReloadUserData();
      if (mounted) {
        setState(() {});
        print(
          '✅ AccountScreen: Data loaded - ${authController.userFullName.value}',
        );
      }
    } catch (e) {
      print('❌ AccountScreen: Error loading data - $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;
    final topPadding = MediaQuery.of(context).padding.top;

    // Responsive sizing
    final avatarRadius = screenWidth * 0.09;
    final nameFontSize = screenWidth * 0.055;
    final menuFontSize = screenWidth * 0.035;
    final menuIconSize = screenWidth * 0.055;
    final arrowIconSize = screenWidth * 0.035;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Map Background — top 22%
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.22,
            child: RidenMapView(mapHeight: screenHeight * 0.22),
          ),

          // Top Bar with Back and Notification
          Positioned(
            top: topPadding + 10,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: menuIconSize,
                    ),
                  ),
                ),
                _buildNotificationIcon(menuIconSize),
              ],
            ),
          ),

          // Bottom Sheet — fills from ~18% down, fits content
          Positioned(
            top: screenHeight * 0.18,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF030408),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                  top: 24,
                  bottom: screenHeight * 0.13, // space for bottom nav
                ),
                child: Column(
                  children: [
                    // Avatar
                    Obx(() {
                      final authController = Get.find<AuthController>();
                      String firstName = authController.userFirstName.value;
                      String lastName = authController.userLastName.value;
                      String initials = _getInitialsFromNames(
                        firstName,
                        lastName,
                      );
                      return Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.blue[600]!,
                            width: 2.5,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: avatarRadius,
                          backgroundColor: const Color(0xFF6395FF),
                          child: Text(
                            initials,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: nameFontSize * 0.8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: screenHeight * 0.015),

                    // Name — Display from AuthController
                    Obx(() {
                      final authController = Get.find<AuthController>();
                      String firstName = authController.userFirstName.value;
                      String lastName = authController.userLastName.value;
                      final displayName =
                          '$firstName $lastName'.trim().isNotEmpty
                          ? '$firstName $lastName'.trim()
                          : "User";
                      return Text(
                        "Hi, $displayName 👋",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: nameFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }),
                    SizedBox(height: screenHeight * 0.025),

                    // Menu Container
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildMenuRow(
                              Icons.person,
                              "My Profile",
                              menuFontSize,
                              menuIconSize,
                              arrowIconSize,
                              onTap: () =>
                                  Get.to(() => const MyProfileScreen()),
                            ),
                            _buildDivider(),
                            _buildMenuRow(
                              Icons.calendar_today_rounded,
                              "Booking History",
                              menuFontSize,
                              menuIconSize,
                              arrowIconSize,
                            ),
                            _buildDivider(),
                            _buildMenuRow(
                              Icons.account_balance_wallet_rounded,
                              "Payment Methods",
                              menuFontSize,
                              menuIconSize,
                              arrowIconSize,
                              onTap: () =>
                                  Get.to(() => const PaymentMethodScreen()),
                            ),
                            _buildDivider(),
                            _buildMenuRow(
                              Icons.account_balance_wallet_outlined,
                              "In App Wallet",
                              menuFontSize,
                              menuIconSize,
                              arrowIconSize,
                            ),
                            _buildDivider(),
                            _buildMenuRow(
                              Icons.confirmation_number_rounded,
                              "Complaint Tickets",
                              menuFontSize,
                              menuIconSize,
                              arrowIconSize,
                              onTap: () =>
                                  Get.to(() => const ComplaintsTicketScreen()),
                            ),
                            _buildDivider(),
                            _buildMenuRow(
                              Icons.info_outline_rounded,
                              "About Us",
                              menuFontSize,
                              menuIconSize,
                              arrowIconSize,
                              onTap: () => Get.to(() => const AboutUs()),
                            ),
                            _buildDivider(),
                            _buildMenuRow(
                              Icons.settings_outlined,
                              "App Settings",
                              menuFontSize,
                              menuIconSize,
                              arrowIconSize,
                              onTap: () =>
                                  Get.to(() => const AppSettingsScreen()),
                            ),
                            _buildDivider(),
                            _buildMenuRow(
                              Icons.person_pin_circle_rounded,
                              "Contact Support",
                              menuFontSize,
                              menuIconSize,
                              arrowIconSize,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const Support(),
                                ),
                              ),
                            ),
                            _buildDivider(),
                            _buildMenuRow(
                              Icons.logout_rounded,
                              "Logout",
                              menuFontSize,
                              menuIconSize,
                              arrowIconSize,
                              onTap: () => _handleLogout(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Navigation Bar
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              child: Obx(() {
                final navController = Get.find<NavigationController>();
                return RidenBottomNav(
                  selectedIndex: navController.selectedNavIndex.value,
                  onItemSelected: (index) {
                    if (index == 1) {
                      // Navigate to Support
                      navController.setSelectedIndex(1);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Support()),
                      );
                    } else if (index != 3) {
                      // Navigate back to home for other tabs
                      navController.setSelectedIndex(index);
                      Navigator.pop(context);
                    }
                    // If index == 3 (Account), do nothing (already here)
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  /// Handle logout action
  Future<void> _handleLogout(BuildContext context) async {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1a1a1a),
          title: Text(
            'Logout',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: GoogleFonts.poppins(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: Colors.blue[400]),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);

                // Get AuthController and logout
                final authController = Get.find<AuthController>();
                await authController.logout();

                // Navigate to SignInScreen and clear all previous routes
                Get.offAll(() => const SignInScreen());
              },
              child: Text(
                'Logout',
                style: GoogleFonts.poppins(color: Colors.red),
              ),
            ),
          ],
        );
      },
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

  Widget _buildDivider() {
    return Container(height: 1, color: Colors.white.withOpacity(0.07));
  }

  Widget _buildMenuRow(
    IconData icon,
    String title,
    double fontSize,
    double iconSize,
    double arrowSize, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue[400], size: iconSize),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.blue[400],
              size: arrowSize,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(double iconSize) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white24, width: 1),
          ),
          child: Icon(
            Icons.notifications_none_outlined,
            color: Colors.white,
            size: iconSize,
          ),
        ),
        Positioned(
          top: 6,
          right: 6,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
