import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FaqsScreen extends StatefulWidget {
  const FaqsScreen({super.key});

  @override
  State<FaqsScreen> createState() => _FaqsScreenState();
}

class _FaqsScreenState extends State<FaqsScreen> {
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

  final List<_FaqItem> _faqs = [
    _FaqItem(
      question: 'Q: How do I book a ride?',
      answer:
          'Open the app, enter your destination, choose a ride type, and confirm your booking. A driver will be assigned and will arrive at your location shortly.',
    ),
    _FaqItem(
      question: 'Q: How is the fare calculated?',
      answer:
          'Fares are calculated based on distance, time, and applicable demand factors. You will see a fare estimate before confirming your ride. By confirming, you agree to the displayed fare.',
    ),
    _FaqItem(
      question: 'Q: Can I cancel a ride after booking?',
      answer:
          'Yes, you can cancel a ride after booking. Cancellation fees may apply depending on how much time has passed since the driver accepted your request. Check the cancellation policy in the app for details.',
    ),
    _FaqItem(
      question: 'Q: How do I contact my driver?',
      answer:
          'After a driver is assigned, you can contact them directly through the in-app call or message feature available on the booking screen.',
    ),
    _FaqItem(
      question: 'Q: What payment methods are accepted?',
      answer:
          'RIDEN accepts cash, debit/credit cards, and select digital wallets. You can manage your payment methods from the Payment section in your profile.',
    ),
  ];

  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Stack(
        children: [
          // ── Map (45%) ──────────────────────────────────────────
          SizedBox(
            height: screenHeight * 0.45,
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

          // ── Bottom Sheet (55%) ─────────────────────────────────
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight * 0.60,
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
                    "FAQ'S",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // FAQ list
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _faqs.length,
                      itemBuilder: (context, index) {
                        return _FaqCard(
                          item: _faqs[index],
                          isExpanded: _expandedIndex == index,
                          onTap: () {
                            setState(() {
                              _expandedIndex =
                                  _expandedIndex == index ? null : index;
                            });
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),
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
// FAQ Item model
// ─────────────────────────────────────────────────────────────────────────────
class _FaqItem {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});
}

// ─────────────────────────────────────────────────────────────────────────────
// FAQ Card widget
// ─────────────────────────────────────────────────────────────────────────────
class _FaqCard extends StatelessWidget {
  final _FaqItem item;
  final bool isExpanded;
  final VoidCallback onTap;

  const _FaqCard({
    required this.item,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF252525),
          borderRadius: BorderRadius.circular(14),
          border: isExpanded
              ? Border.all(color: const Color(0xFF2979FF).withOpacity(0.4), width: 1)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.question,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF888888),
                    size: 22,
                  ),
                ],
              ),
            ),

            // Answer (animated)
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                child: Text(
                  item.answer,
                  style: const TextStyle(
                    color: Color(0xFFAAAAAA),
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
          ],
        ),
      ),
    );
  }
}