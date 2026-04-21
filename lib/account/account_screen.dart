import 'package:Riden/account/Aboutus/about_us.dart';
import 'package:Riden/account/App_setting/App_setting.dart';
import 'package:Riden/account/Complaints/copmplaints_tickets.dart';
import 'package:Riden/home/home_screen.dart';
import 'package:Riden/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/riden_map_view.dart';
import 'payment_method/payment_method.dart';
import 'profile/my_profile.dart';
import 'package:Riden/home/notification_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Gradient-border wrapper
// ─────────────────────────────────────────────────────────────────────────────
class _GradientBorderBox extends StatelessWidget {
  final Widget child;
  final Color fillColor;
  final double borderRadius;

  const _GradientBorderBox({
    required this.child,
    required this.fillColor,
    this.borderRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: SweepGradient(
          center: Alignment.bottomLeft,
          startAngle: 0,
          endAngle: 6.2832,
          colors: const [
            Color(0x80F9F9F9),
            Color(0x809C9C9C),
            Color(0x599C9C9C),
            Color(0x80FFFFFF),
            Color(0x80FFFFFF),
            Color(0x599C9C9C),
            Color(0xFFF9F9F9),
            Color(0x80FFFFFF),
            Color(0x80F9F9F9),
            Color(0x809C9C9C),
          ],
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: const EdgeInsets.all(1),
      child: Container(
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(borderRadius - 1),
        ),
        child: child,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AccountScreen
// ─────────────────────────────────────────────────────────────────────────────
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
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('❌ AccountScreen: Error loading data - $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;

    // Responsive sizing
    final avatarRadius = screenWidth * 0.09;
    final nameFontSize = screenWidth * 0.055;
    final menuFontSize = screenWidth * 0.035;
    final menuIconSize = screenWidth * 0.052;
    final arrowIconSize = screenWidth * 0.035;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ── 40% Map background ────────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.40,
            child: RidenMapView(mapHeight: screenHeight * 0.40),
          ),

          // ── RIDEN Text ──────────────────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'RIDEN',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.audiowide(
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600.withValues(alpha: 0.82),
                  height: 1.0,
                ),
              ),
            ),
          ),

          // ── Draggable bottom sheet ─────────────────────────────────────────
          DraggableScrollableSheet(
            initialChildSize: 0.62,
            minChildSize: 0.60,
            maxChildSize: 0.90,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF030408),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(36),
                  ),
                ),
                child: CustomScrollView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // ── Drag handle ───────────────────────────────────
                          Padding(
                            padding: const EdgeInsets.only(top: 14, bottom: 6),
                            child: Container(
                              width: 48,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.30),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // ── "Account" heading ─────────────────────────────
                          Text(
                            'Account',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: screenWidth * 0.062,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 35),

                          // ── Profile card ──────────────────────────────────
                          Obx(() {
                            final auth = Get.find<AuthController>();
                            final firstName = auth.userFirstName.value;
                            final lastName = auth.userLastName.value;
                            final displayName =
                                '$firstName $lastName'.trim().isNotEmpty
                                ? '$firstName $lastName'.trim()
                                : 'User';
                            final initials =
                                _getInitialsFromNames(firstName, lastName);

                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.07, 
                              ),

                              child: Column(
                                children: [
                                  // ── Blue banner card ──
                                  _GradientBorderBox(
                                    fillColor: const Color(0xFF79A6F7),
                                    borderRadius: 16,
                                    child: SizedBox(
                                      height: 72,
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 22),
                                          // Name
                                          Expanded(
                                            child: Text(
                                              displayName,
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: nameFontSize * 0.95,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          // Avatar with blue ring
                                          Transform.translate(
                                            offset: const Offset(4, 0),
                                            child: Container(
                                              padding: const EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFF4B8CFF,
                                                  ),
                                                  width: 2.5,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: const Color(
                                                      0xFF4B8CFF,
                                                    ).withValues(alpha: 0.40),
                                                    blurRadius: 14,
                                                    spreadRadius: 2,
                                                  ),
                                                ],
                                              ),
                                              child: CircleAvatar(
                                                radius: avatarRadius * 0.9,
                                                backgroundColor: const Color(
                                                  0xFF6395FF,
                                                ),
                                                child: Text(
                                                  initials,
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize:
                                                        nameFontSize * 0.75,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: screenHeight * 0.050),

                                  // ── Name + rating ──
                                  Text(
                                    displayName,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: menuFontSize * 1.15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '4.2',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white70,
                                          fontSize: menuFontSize,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      ...List.generate(5, (i) {
                                        if (i < 4) {
                                          return const Icon(
                                            Icons.star_rounded,
                                            color: Color(0xFF4B8CFF),
                                            size: 16,
                                          );
                                        } else {
                                          return const Icon(
                                            Icons.star_half_rounded,
                                            color: Color(0xFF4B8CFF),
                                            size: 16,
                                          );
                                        }
                                      }),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),

                          SizedBox(height: screenHeight * 0.015  ),
  
                          // ── 2×2 Grid Buttons ──────────────────────────────
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.06,
                              vertical: screenHeight  * 0.008,
                            ),
                            child: GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisSpacing: screenWidth * 0.03,
                              mainAxisSpacing: screenWidth * 0.03,
                              childAspectRatio: 2.4,
                              children: [
                                _buildGridButton(
                                  icon: Icons.person_outline_rounded,
                                  label: 'Account',
                                  menuFontSize: menuFontSize,
                                  menuIconSize: menuIconSize,
                                  onTap:
                                      () => Get.to(() => const MyProfileScreen()),
                                ),
                                _buildGridButton(
                                  icon: Icons.info_outline_rounded,
                                  label: 'About us',
                                  menuFontSize: menuFontSize,
                                  menuIconSize: menuIconSize,
                                  onTap: () => Get.to(() => const AboutUs()),
                                ),
                                _buildGridButton(
                                  icon: Icons.payment_rounded ,
                                  label: 'Payment Method',
                                  menuFontSize: menuFontSize,
                                  menuIconSize: menuIconSize,
                                  onTap:
                                      () =>
                                          Get.to(
                                            () =>
                                                const PaymentMethodScreen(),
                                          ),
                                ),
                                _buildGridButton(
                                  icon: Icons.report_problem_outlined,
                                  label: 'Complaint',
                                  menuFontSize: menuFontSize,
                                  menuIconSize: menuIconSize,
                                  onTap:
                                      () => Get.to(
                                        () => const ComplaintsTicketScreen(),
                                      ),
                                ),
                              ],  
                            ),
                          ),  

                          SizedBox(height: screenWidth * 0.0002),

                          // ── Settings button (full-width) ──────────────────
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05,
                            ),
                            child: _buildSettingsButton(
                              menuFontSize: menuFontSize,
                              menuIconSize: menuIconSize,
                              arrowIconSize: arrowIconSize,
                              onTap: () => Get.to(() => const AppSettingsScreen()),
                            ),
                          ),

                          SizedBox(height: screenWidth * 0.06),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // ── Top overlay buttons (back + notification) ─────────────────────
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: 50, // Pushed down below RIDEN text
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () {
                      // Navigate to HomeScreen with a black screen transition
                      Navigator.pushAndRemoveUntil(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: Container(
                                color: Colors.black,
                                child: child,
                              ),
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 500),
                        ),
                        (route) => false,
                      );
                    },
                    child: _GradientBorderBox(
                      fillColor: Colors.white,
                      borderRadius: 50,
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                  // Notification bell
                  GestureDetector(
                    onTap: () => Get.to(() => const NotificationScreen()),
                    child: _GradientBorderBox(
                      fillColor: Colors.black.withValues(alpha: 0.35),
                      borderRadius: 50,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.notifications_none_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _getInitialsFromNames(String firstName, String lastName) {
    if (firstName.isEmpty && lastName.isEmpty) return 'U';
    String initials = '';
    if (firstName.isNotEmpty) initials += firstName[0].toUpperCase();
    if (lastName.isNotEmpty) initials += lastName[0].toUpperCase();
    if (initials.length == 1) {
      final name = firstName.isNotEmpty ? firstName : lastName;
      initials = name.length >= 2
          ? name.substring(0, 2).toUpperCase()
          : (name[0] + name[0]).toUpperCase();
    }
    return initials.isNotEmpty ? initials : 'U';
  }

  // ── Grid tile ──────────────────────────────────────────────────────────────
  Widget _buildGridButton({
    required IconData icon,
    required String label,
    required double menuFontSize,
    required double menuIconSize,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.22),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.blue[300], size: 15 ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),  
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Full-width Settings button ─────────────────────────────────────────────
  Widget _buildSettingsButton({
    required double menuFontSize,
    required double menuIconSize,
    required double arrowIconSize,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2), 
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14 , vertical: 19),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.22),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.settings_outlined,
                  color: Colors.blue[300],
                  size: 15,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  'Settings',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14  ,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.blue[300],
                size: arrowIconSize,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
