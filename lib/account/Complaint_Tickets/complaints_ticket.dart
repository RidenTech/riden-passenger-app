import 'package:Riden/account/Complaint_Tickets/complaint_against_driver.dart';
import 'package:Riden/widgets/glass_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ComplaintsTicketScreen extends StatelessWidget {
  const ComplaintsTicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Map Backdrop (Top 30%)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.18, // Extending slightly for better overlap
            child: Image.asset(
              'assets/images/map.png',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.6),
              colorBlendMode: BlendMode.darken,
            ),
          ),

          // 2. Custom Header (Logo, Back, Notifications)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Column(
                children: [ // Logo
                      Text(
                        'RIDEN',
                        style: GoogleFonts.audiowide(
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade600.withOpacity(0.82),
                          height: 1.0,
                        ),
                      ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
                        ),
                      ),
                     
                      // Notification Bell
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.25),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white24, width: 1),
                            ),
                            child: const Icon(Icons.notifications_none_outlined,
                                color: Colors.white, size: 22),
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
                  const SizedBox(height: 35),
                  // Drag indicator line
                  Container(
                    width: 50,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Bottom Sheet Content (70%)
          Positioned(
            top: screenHeight * 0.20,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        "Complaint Tickets",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 25),
                      
                      _buildSectionHeader("Today"),
                      _buildComplaintCard(
                        context,
                        bookingId: "2345",
                        description: "I am writing to formally lodge a complaint regarding a recent ride I took through your platform. The experience was disappointing and did not meet the standards I expect from your service.The driver assigned to my trip arrived late without any prior communication or apology. During the ride, the driver displayed unprofessional behavior, including speaking ru...",
                      ),
                      
                      _buildSectionHeader("Previous"),
                      _buildComplaintCard(
                        context,
                        bookingId: "2345",
                        description: "I am writing to formally lodge a complaint regarding a recent ride I took through your platform. The experience was disappointing and did not meet the standards I expect from your service.The driver assigned to my trip arrived late without any prior communication or apology. During the ride, the driver displayed unprofessional behavior, including speaking ru...",
                      ),
                      
                      _buildSectionHeader("Older"),
                      const SizedBox(height: 30), // Filler for scrolling
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 10),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildComplaintCard(BuildContext context,
      {required String bookingId, required String description}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: GlassContainer(
        borderRadius: 24,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Complaint Against Driver",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Booking ID : $bookingId",
                    style: GoogleFonts.poppins(
                      color: Colors.blue.shade200,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              description,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 12,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ComplaintAgainstDriverScreen(),
                    ),
                  );
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.chevron_right, color: Colors.white, size: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
