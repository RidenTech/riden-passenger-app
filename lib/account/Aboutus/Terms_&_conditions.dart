import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  GoogleMapController? _mapController;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(24.8607, 67.0011),
    zoom: 13,
  );

  static const String _darkMapStyle = '''[
    {"elementType":"geometry","stylers":[{"color":"#1a1a1a"}]},
    {"elementType":"labels.icon","stylers":[{"visibility":"off"}]},
    {"elementType":"labels.text.fill","stylers":[{"color":"#555555"}]},
    {"elementType":"labels.text.stroke","stylers":[{"color":"#1a1a1a"}]},
    {"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#2c2c2c"}]},
    {"featureType":"poi","stylers":[{"visibility":"off"}]},
    {"featureType":"road","elementType":"geometry","stylers":[{"color":"#2c2c2c"}]},
    {"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#212121"}]},
    {"featureType":"transit","stylers":[{"visibility":"off"}]},
    {"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]}
  ]''';

  static const List<_Section> _sections = [
    _Section(
      title: null,
      body:
          'By accessing or using this application ("App"), you agree to be bound by these Terms of Use. If you do not agree with these terms, you must not use the App.',
    ),
    _Section(
      title: '1. Service Description',
      body:
          'The App provides a platform that connects users seeking transportation services with independent drivers. The App does not itself provide transportation services and is not a transportation carrier. All rides are fulfilled by third-party drivers who operate independently.',
    ),
    _Section(
      title: '2. User Responsibilities',
      body:
          'Users agree to provide accurate information, behave respectfully toward drivers, and comply with all applicable laws and regulations while using the App. Any misuse of the platform may result in suspension or termination of access.',
    ),
    _Section(
      title: '3. Driver Responsibility',
      body:
          'Drivers are solely responsible for the transportation services they provide, including compliance with local laws, vehicle safety, licensing, and insurance requirements.',
    ),
    _Section(
      title: '4. Limitation of Liability',
      body:
          'To the maximum extent permitted by law, the App and its owners shall not be liable for any direct, indirect, incidental, or consequential damages arising from:\n  • Use of the App\n  • Delays, cancellations, or service interruptions\n  • Conduct of drivers or other users\n\nAll services are provided on an "as is" and "as available" basis.',
    ),
    _Section(
      title: '5. Availability of Service',
      body:
          'We do not guarantee uninterrupted or error-free operation of the App. Features and services may be modified, suspended, or discontinued at any time without prior notice.',
    ),
    _Section(
      title: '6. Payments & Pricing',
      body:
          'Fares are calculated based on distance, time, and other applicable factors. Prices may vary due to demand, traffic conditions, or other external factors. By confirming a ride, you agree to the displayed fare or fare estimate.',
    ),
    _Section(
      title: '7. Privacy',
      body:
          'Your use of the App is also governed by our Privacy Policy, which outlines how we collect, use, and protect your personal information.',
    ),
    _Section(
      title: '8. Changes to Terms',
      body:
          'We reserve the right to update or modify these Terms at any time. Continued use of the App following any changes constitutes acceptance of those changes.',
    ),
    _Section(
      title: '9. Contact',
      body:
          'For any questions regarding these Terms, please contact support through the App.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Stack(
        children: [
          // ── Map (20%) ──────────────────────────────────────────
          SizedBox(
            height: screenHeight * 0.22,
            child: GoogleMap(
              initialCameraPosition: _initialPosition,
              onMapCreated: (controller) {
                _mapController = controller;
                controller.setMapStyle(_darkMapStyle);
              },
              myLocationEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: false,
            ),
          ),

          // ── App Bar Overlay ────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.black,
                        size: 18,
                      ),
                    ),
                  ),
                  const Text(
                    'RIDEN',
                    style: TextStyle(
                      color: Color(0x99FFFFFF),
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 5,
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
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
          ),

          // ── Bottom Sheet (80%) ─────────────────────────────────
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight * 0.83,
              decoration: const BoxDecoration(
                color: Color(0xFF111111),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  // Drag handle
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFF444444),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Title
                  const Text(
                    'Terms & Conditions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Content card
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF252525),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(18),
                          itemCount: _sections.length,
                          itemBuilder: (context, index) {
                            final section = _sections[index];
                            return _SectionWidget(section: section);
                          },
                        ),
                      ),
                    ),
                  ),

                  // Accept button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2979FF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'I Agree',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
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
}

// ─────────────────────────────────────────────────────────────────────────────
// Section model
// ─────────────────────────────────────────────────────────────────────────────
class _Section {
  final String? title;
  final String body;

  const _Section({this.title, required this.body});
}

// ─────────────────────────────────────────────────────────────────────────────
// Section widget
// ─────────────────────────────────────────────────────────────────────────────
class _SectionWidget extends StatelessWidget {
  final _Section section;

  const _SectionWidget({required this.section});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section.title != null) ...[
            Text(
              section.title!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
          ],
          Text(
            section.body,
            style: const TextStyle(
              color: Color(0xFFCCCCCC),
              fontSize: 13,
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }
}