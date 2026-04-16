import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FaqsScreen extends StatefulWidget {
  const FaqsScreen({super.key});

  @override
  State<FaqsScreen> createState() => _FaqsScreenState();
}

class _FaqsScreenState extends State<FaqsScreen> {
  int? _expandedIndex;

  final List<Map<String, String>> _faqs = [
    {
      'question': 'How do I book a ride?',
      'answer':
          'Open the app, enter your destination in the search bar, choose your ride type, and tap "Confirm Booking". A nearby driver will be assigned to you shortly.',
    },
    {
      'question': 'How do I cancel a booking?',
      'answer':
          'Go to your active booking screen and tap "Cancel Ride". Please note that cancellations after the driver has been assigned may incur a small fee depending on timing.',
    },
    {
      'question': 'What payment methods are accepted?',
      'answer':
          'We accept cash, credit/debit cards, and digital wallets. You can manage your payment methods from the Profile > Payment section.',
    },
    {
      'question': 'How do I contact my driver?',
      'answer':
          'Once a driver is assigned, you will see a "Call" and "Message" button on the booking screen. You can use either to get in touch with your driver directly.',
    },
    {
      'question': 'What should I do if I lost an item?',
      'answer':
          'Go to Activity, find the relevant trip, and tap "Report Lost Item". Our support team will contact the driver on your behalf and assist you in recovering your belongings.',
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
                      // Back button
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
                      // Notification bell
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.25),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white24, width: 1),
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
              height: MediaQuery.of(context).size.height * 0.62,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: const BoxDecoration(
                color: Color(0xFF0D0D0D),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  // Drag indicator
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    "FAQ'S",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── FAQ Accordion List ──────────────────────────────
                  Expanded(
                    child: ListView.separated(
                      itemCount: _faqs.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final isExpanded = _expandedIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _expandedIndex =
                                  isExpanded ? null : index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                              color: isExpanded
                                  ? const Color(0xFF1A1A2E)
                                  : const Color(0xFF1C1C1C),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isExpanded
                                    ? Colors.blue.withOpacity(0.4)
                                    : Colors.white12,
                                width: 1,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                // Question Row
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Q : ${_faqs[index]['question']}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    AnimatedRotation(
                                      turns: isExpanded ? 0.5 : 0,
                                      duration: const Duration(
                                          milliseconds: 300),
                                      child: const Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.white54,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),

                                // Answer (shown when expanded)
                                if (isExpanded) ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    height: 1,
                                    color: Colors.white12,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _faqs[index]['answer']!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white60,
                                      height: 1.6,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
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