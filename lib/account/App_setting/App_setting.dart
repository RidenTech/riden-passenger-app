import 'package:Riden/account/App_setting/change_password.dart';
import 'package:Riden/widgets/riden_map_view.dart';
import 'package:Riden/auth/sign_in_screen.dart';
import 'package:Riden/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:Riden/home/notification_screen.dart';

class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Map Background (Reusable component)
          Positioned.fill(child: RidenMapView(mapHeight: double.infinity)),
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
                      color: Colors.grey.shade600.withOpacity(0.82),
                      height: 1.0,
                    ),
                  ),
                ),
                _buildHeader(context),
                const Spacer(),
                _buildSettingsBottomSheet(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsBottomSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      decoration: const BoxDecoration(
        color: Color(0xFF030408),
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "App Settings",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 25),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              children: [
                _settingsTile(Icons.lock_outline, "Change Password", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ChangePasswordPhoneScreen(),
                    ),
                  );
                }),
                _settingsTile(Icons.share_outlined, "Share The App", () {}),
                _settingsTile(Icons.star_outline, "Rate The App", () {}),
                _settingsTile(
                  Icons.logout,
                  "Logout",
                  () => _showLogoutDialog(context),
                  isLast: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _settingsTile(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isLast = false,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: const Color(0xFF2979FF)),
          title: Text(
            title,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.white54),
          onTap: onTap,
        ),
        if (!isLast) const Divider(color: Colors.white12, indent: 50),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Colors.red,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 20),
                // Title
                Text(
                  'Leaving Already?',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                // Subtitle
                Text(
                  'You\'ll need to log in again to access your account',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 30),
                // Logout Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      Navigator.pop(dialogContext);
                      // Get AuthController and logout
                      final authController = Get.find<AuthController>();
                      await authController.logout();
                      // Navigate to SignInScreen and clear all previous routes
                      Get.offAll(() => const SignInScreen());
                    },
                    child: Text(
                      'Log Out',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Stay Logged In Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Colors.blue.withOpacity(0.5),
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(dialogContext),
                    child: Text(
                      'Stay Logged In',
                      style: GoogleFonts.poppins(
                        color: Colors.blue[300],
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
                
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
    );
  }
}
