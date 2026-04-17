import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Riden/widgets/shared_map_widget.dart';
import 'driver_search_view.dart';

class RideConfirmationView extends StatelessWidget {
  const RideConfirmationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map Background (Shared Global Map - Fills entire background)
          Positioned.fill(
            child: SharedMapWidget(height: MediaQuery.of(context).size.height),
          ),

          // Top Action Buttons
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
                const SizedBox(height: 15),
                // Top Row: Greeting
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Stack(
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
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                  // Indicator
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Confirmation Text
                  Text(
                    "Confirm Pickup",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Confirm Button
                  _buildConfirmButton(context),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF7296E4), Color(0xFF174AB7)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DriverSearchView(),
                ),
              );
            },
            child: Center(
              child: Text(
                "Confirm",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
