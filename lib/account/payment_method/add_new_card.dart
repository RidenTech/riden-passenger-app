import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/riden_top_bar.dart';
import '../../widgets/riden_map_view.dart';

class AddNewCardScreen extends StatefulWidget {
  const AddNewCardScreen({super.key});

  @override
  State<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  final _cardNumberController = TextEditingController();
  final _nameController = TextEditingController();
  final _cvvController = TextEditingController();
  final _expiryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Map Background — top 45%
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.45,
            child: RidenMapView(mapHeight: screenHeight * 0.45),
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

          // Bottom Sheet Container — covering 55%
          Positioned(
            top: screenHeight * 0.40,
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
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
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
                        "Add New Card",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Card Number
                      CustomTextField(
                        label: 'Card Number',
                        hintText: 'Enter Your Card Number',
                        controller: _cardNumberController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),

                      // Card Holder Name
                      CustomTextField(
                        label: 'Card Holder Name',
                        hintText: 'Enter Card Holder Name',
                        controller: _nameController,
                      ),
                      const SizedBox(height: 16),

                      // CVV and Expiry row
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: 'CVV',
                              hintText: 'Enter Your CVV',
                              controller: _cvvController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomTextField(
                              label: 'Expiry Date',
                              hintText: '00/00/0000',
                              controller: _expiryController,
                              suffixIcon: const Icon(
                                Icons.calendar_month,
                                color: Color(0xFF7296E4),
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),

                      // Submit Button
                      PrimaryButton(
                        text: 'Submit',
                        onPressed: () {
                          Get.back();
                          Get.snackbar(
                            "Success",
                            "New card added successfully",
                            backgroundColor: Colors.blue.withOpacity(0.7),
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                            margin: const EdgeInsets.all(20),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
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
}
