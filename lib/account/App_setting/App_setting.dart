import 'package:Riden/account/App_setting/change_password.dart';
import 'package:Riden/widgets/riden_map_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                _settingsTile(Icons.logout, "Logout", () {}, isLast: true),
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
          Text(
            'RIDEN',
            style: GoogleFonts.audiowide(
              fontSize: 22,
              color: Colors.grey.withOpacity(0.8),
            ),
          ),
          const Icon(Icons.notifications_none, color: Colors.white),
        ],
      ),
    );
  }
}
