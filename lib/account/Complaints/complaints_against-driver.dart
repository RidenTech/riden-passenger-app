import 'package:Riden/widgets/glass_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ComplaintAgainstDriverScreen extends StatefulWidget {
  const ComplaintAgainstDriverScreen({super.key});

  @override
  State<ComplaintAgainstDriverScreen> createState() =>
      _ComplaintAgainstDriverScreenState();
}

class _ComplaintAgainstDriverScreenState
    extends State<ComplaintAgainstDriverScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

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

          // 3. Chat Area
          Positioned(
            top: screenHeight * 0.20,
            left: 0,
            right: 0,
            bottom: 80, // Space for input field
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    "Complaint Against Driver",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildSenderLabel("You"),
                      _buildMessageBubble(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "I am writing to formally lodge a complaint regarding a recent ride I took through your platform. The experience was disappointing and did not meet the standards I expect from your service.The driver assigned to my trip arrived late without any prior communication or apology. During the ride, the driver displayed unprofessional behavior, including speaking rud... more",
                              style: GoogleFonts.poppins(
                                  color: Colors.white, fontSize: 12, height: 1.5),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                _buildImagePlaceholder("assets/images/car1.png"),
                                const SizedBox(width: 10),
                                _buildImagePlaceholder("assets/images/white_mercedes.png"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildSenderLabel("Support"),
                      _buildMessageBubble(
                        child: Text(
                          "Thank you for contacting us. We’re sorry to hear about your experience. To help us investigate this matter further, could you please provide additional details such as the date and time of the ride, driver’s name, and any specific incidents you would like to review? We appreciate your cooperation and look forward to resolving this issue.",
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 12, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 4. Input Field
          Positioned(
            bottom: 20,
            left: 24,
            right: 24,
            child: GlassContainer(
              borderRadius: 16,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  // Attachment Icon
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue.withOpacity(0.5)),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.blue, size: 20),
                  ),
                  const SizedBox(width: 12),
                  // Text Input
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Type your message",
                        hintStyle: GoogleFonts.poppins(
                            color: Colors.white54, fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  // Send Icon
                  const Icon(Icons.send_rounded, color: Colors.blue, size: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSenderLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: label == "You" ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white54,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble({required Widget child}) {
    return GlassContainer(
      borderRadius: 16,
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }

  Widget _buildImagePlaceholder(String imagePath) {
    return Container(
      width: 120,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
