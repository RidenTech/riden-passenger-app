import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/riden_top_bar.dart';
import '../../widgets/riden_map_view.dart';
import '../../home/home_screen.dart';
import '../../controllers/navigation_controller.dart';
import 'add_new_card.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Map Background — top 50%
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.50,
            child: RidenMapView(mapHeight: screenHeight * 0.50),
          ),

          // Branding & Top Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  const RidenBranding(),
                  const SizedBox(height: 15),
                  RidenTopBar(
                    onBack: () {
                      Get.find<NavigationController>().setSelectedIndex(0);
                      Get.offAll(
                        () => const HomeScreen(),
                        transition: Transition.fadeIn,
                        duration: const Duration(milliseconds: 600),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Bottom Sheet Container — covering 50%
          Positioned(
            top: screenHeight * 0.42,
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                child: Column(
                  children: [
                    // Handle bars
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      "Payment Methods",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 60),

                    // Methods Container
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Recent Methods ─────────────────────────────
                            Text(
                              "Recent Methods",
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF2979FF),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildPaymentButton(
                              icon: Icons.apple,
                              label: "Apple Pay",
                              width: size.width * 0.45,
                              onTap: () {},
                            ),

                            const SizedBox(height: 24),

                            // ── Other Methods ──────────────────────────────
                            Text(
                              "Other Methods",
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF2979FF),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              childAspectRatio: 2.5,
                              children: [
                                _buildPaymentButton(
                                  icon: Icons.credit_card_rounded,
                                  label: "Add Card",
                                  onTap: () => Get.to(() => const AddNewCardScreen()),
                                ),
                                _buildPaymentButton(
                                  icon: Icons.account_balance_wallet_outlined,
                                  label: "Google Pay",
                                  onTap: () {},
                                ),
                                _buildPaymentButton(
                                  icon: Icons.paypal_outlined,
                                  label: "Paypal",
                                  onTap: () {},
                                ),
                                _buildPaymentButton(
                                  icon: Icons.apple,
                                  label: "Apple Pay",
                                  onTap: () {},
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentButton({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    double? width,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.blue[300], size: 18),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
