import 'package:Riden/account/App_setting/set%20_new_password.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Riden/widgets/riden_map_view.dart';

class VerifyOTPScreen extends StatefulWidget {
  const VerifyOTPScreen({super.key});

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  // Controllers for each digit to handle focus and input
  final List<TextEditingController> _controllers = List.generate(
    5,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(5, (_) => FocusNode());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Map Layer
          Positioned.fill(child: RidenMapView(mapHeight: double.infinity)),

          _buildTopBar(context),

          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomSheet(
              title: "Enter Verification Code",
              subtitle: "Code has been send to ***** ***412",
              content: [
                const SizedBox(height: 10),
                // OTP Input Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(5, (index) => _buildOTPBox(index)),
                ),
                const SizedBox(height: 30),

                // Resend Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive code? ",
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {}, // Handle Resend
                      child: Text(
                        "Resend again",
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF3B67D5),
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Primary Action Button
                _buildVerifyButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOTPBox(int index) {
    return Container(
      width: 55,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF0F1A2E).withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF3B67D5).withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: Center(
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          decoration: const InputDecoration(
            counterText: "",
            border: InputBorder.none,
          ),
          onChanged: (value) {
            if (value.isNotEmpty && index < 4) {
              _focusNodes[index + 1].requestFocus();
            } else if (value.isEmpty && index > 0) {
              _focusNodes[index - 1].requestFocus();
            }
          },
        ),
      ),
    );
  }

  Widget _buildVerifyButton() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF6B92F2), Color(0xFF1E49B6)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E49B6).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
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
              MaterialPageRoute(builder: (_) => const SetNewPasswordScreen()),
            );
            // Navigate to Set New Password screen
          },
          child: Center(
            child: Text(
              "Verify OTP",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper for Header Styling
  Widget _buildTopBar(BuildContext context) {
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
                radius: 18,
                child: Icon(Icons.arrow_back, color: Colors.black, size: 18),
              ),
            ),
            Text(
              'RIDEN',
              style: GoogleFonts.audiowide(
                fontSize: 24,
                color: Colors.white.withOpacity(0.2),
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

  Widget _buildBottomSheet({
    required String title,
    required String subtitle,
    required List<Widget> content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 25),
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
            title,
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70),
          ),
          const SizedBox(height: 35),
          ...content,
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
