import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  static const List<Map<String, String>> _sections = [
    {
      'title': '1. Service Description',
      'body':
          'The App provides a platform that connects users seeking transportation services with independent drivers. The App does not itself provide transportation services and is not a transportation carrier. All rides are fulfilled by third-party drivers who operate independently.',
    },
    {
      'title': '2. User Responsibilities',
      'body':
          'Users agree to provide accurate information, behave respectfully toward drivers, and comply with all applicable laws and regulations while using the App. Any misuse of the platform may result in suspension or termination of access.',
    },
    {
      'title': '3. Driver Responsibility',
      'body':
          'Drivers are solely responsible for the transportation services they provide, including compliance with local laws, vehicle safety, licensing, and insurance requirements.',
    },
    {
      'title': '4. Limitation of Liability',
      'body':
          'To the maximum extent permitted by law, the App and its owners shall not be liable for any direct, indirect, incidental, or consequential damages arising from:\n\n• Use of the App\n• Delays, cancellations, or service interruptions\n• Conduct of drivers or other users\n\nAll services are provided on an "as is" and "as available" basis.',
    },
    {
      'title': '5. Availability of Service',
      'body':
          'We do not guarantee uninterrupted or error-free operation of the App. Features and services may be modified, suspended, or discontinued at any time without prior notice.',
    },
    {
      'title': '6. Payments & Pricing',
      'body':
          'Fares are calculated based on distance, time, and other applicable factors. Prices may vary due to demand, traffic conditions, or other external factors. By confirming a ride, you agree to the displayed fare or fare estimate.',
    },
    {
      'title': '7. Privacy',
      'body':
          'Your use of the App is also governed by our Privacy Policy, which outlines how we collect, use, and protect your personal information.',
    },
    {
      'title': '8. Changes to Terms',
      'body':
          'We reserve the right to update or modify these Terms at any time. Continued use of the App following any changes constitutes acceptance of those changes.',
    },
    {
      'title': '9. Contact',
      'body':
          'For any questions regarding these Terms, please contact support through the App.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Map Background ───────────────────────────────────────────
          Positioned.fill(
            child: Container(
              color: Colors.black,
              child: Image.asset(
                "assets/images/map.png",
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(0.6),
              ),
            ),
          ),

          // ── Top Bar ──────────────────────────────────────────────────
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

          // ── Bottom Sheet ─────────────────────────────────────────────
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.68,
              decoration: const BoxDecoration(
                color: Color(0xFF0D0D0D),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Drag indicator
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  Text(
                    "Terms & Conditions",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Scrollable Content Container ────────────────────
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white12, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Intro text
                            Text(
                              'By accessing or using this application ("App"), you agree to be bound by these Terms of Use. If you do not agree with these terms, you must not use the App.',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.white60,
                                height: 1.7,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(height: 1, color: Colors.white10),
                            const SizedBox(height: 20),

                            // Sections
                            ..._sections.map(
                              (s) => _buildSection(s['title']!, s['body']!),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String body) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 4,
              height: 16,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2979FF), Color(0xFF1565C0)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          body,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.white60,
            height: 1.7,
          ),
        ),
      ],
    ),
  );
}
