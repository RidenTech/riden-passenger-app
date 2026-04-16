import 'package:Riden/account/App_setting/password_changed.dart';
import 'package:Riden/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Ensure this path matches your p

class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({super.key});

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ── Background Map ──────────────────────────────────────────
          Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: Image.asset(
                "assets/images/map.png", // Ensure asset is in pubspec.yaml
                fit: BoxFit.cover,
              ),
            ),
          ),

          // ── Top Navigation Bar ──────────────────────────────────────
          _buildHeader(context),

          // ── Bottom Content Sheet ────────────────────────────────────
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
                  // Handle bar
                  Container(
                    width: 50,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 40),

                  Text(
                    "Set New Password",
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Using your CustomTextField widget
                  CustomTextField(
                    controller: _passController,
                    hintText: "Enter your password",
                    obscureText: true,
                    suffixIcon: const Icon(
                      Icons.visibility_off_outlined,
                      color: Colors.white54,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    controller: _confirmPassController,
                    hintText: "Retype your password",
                    obscureText: true,
                    suffixIcon: const Icon(
                      Icons.visibility_off_outlined,
                      color: Colors.white54,
                      size: 20,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ── Action Button ───────────────────────────────────
                  _buildChangePasswordButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20,
                child: Icon(Icons.arrow_back, color: Colors.black, size: 20),
              ),
            ),
            Text(
              'RIDEN',
              style: GoogleFonts.audiowide(
                fontSize: 24,
                color: Colors.white.withOpacity(0.15),
                letterSpacing: 2,
              ),
            ),
            Stack(
              children: [
                const Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                  size: 28,
                ),
                Positioned(
                  right: 4,
                  top: 4,
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
          ],
        ),
      ),
    );
  }

  Widget _buildChangePasswordButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF6B92F2), Color(0xFF1E49B6)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E49B6).withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Logic to transition to Password Success Screen
             Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PasswordSuccessScreen()),
            );
          },
          child: Center(
            child: Text(
              "Change Password",
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
