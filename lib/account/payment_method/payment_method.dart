import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/riden_top_bar.dart';
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
                    const SizedBox(height: 30),

                    // Methods Container
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            _buildMethodsSection(
                              title: "Primary Methods",
                              iconPath: "assets/images/visa.png", // Fallback to icon if missing
                              cardName: "Visa",
                              cardNumber: "******234",
                              isPrimary: true,
                            ),
                            const Divider(color: Colors.white10, height: 1),
                            _buildMethodsSection(
                              title: "Other Methods",
                              iconPath: "assets/images/mastercard.png",
                              cardName: "Master Card",
                              cardNumber: "******234",
                              isPrimary: false,
                            ),
                            const SizedBox(height: 40),

                            // Add New Method Button
                            Align(
                              alignment: Alignment.centerRight,
                              child: PrimaryButton(
                                width: 200,
                                text: 'Add New Method',
                                icon: const Icon(Icons.add, color: Colors.white, size: 18),
                                onPressed: () => Get.to(() => const AddNewCardScreen()),
                              ),
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

  Widget _buildMethodsSection({
    required String title,
    required String iconPath,
    required String cardName,
    required String cardNumber,
    required bool isPrimary,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: isPrimary 
            ? const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
            : const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 50,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: title.contains("Primary") 
                    ? const Text("VISA", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 10))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
                          const SizedBox(width: 2),
                          Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle)),
                        ],
                      ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cardName,
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      cardNumber,
                      style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_vert, color: Colors.white54),
            ],
          ),
        ],
      ),
    );
  }
}
