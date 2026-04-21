import 'package:Riden/chat/call_screen.dart';
import 'package:Riden/chat/chat_screen.dart';
import 'package:Riden/Activity/activities.dart';
import 'package:Riden/support/submit_compalint_ticket.dart';
import 'package:Riden/support/support_files_screen.dart';
import 'package:Riden/widgets/riden_bottom_nav.dart';
import 'package:Riden/account/account_screen.dart';
import 'package:Riden/controllers/navigation_controller.dart';
import 'package:Riden/widgets/shared_map_widget.dart';
import 'package:Riden/home/notification_screen.dart';
import 'package:Riden/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class Support extends StatefulWidget {
  final VoidCallback? onClose;

  const Support({super.key, this.onClose});

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  late NavigationController _navigationController;

  final List<Map<String, dynamic>> _menuItems = [
    {'icon': Icons.phone, 'label': "Call Helpline"},
    {'icon': Icons.help_outline_rounded, 'label': 'Instant Support'},
    {'icon': Icons.receipt_long, 'label': 'Submit Complaint Ticket'},
    {'icon': Icons.file_present, 'label': 'Support Files'},
  ];

  @override
  void initState() {
    super.initState();
    _navigationController = Get.find<NavigationController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigationController.setSelectedIndex(1);
    });
  }

  void _handleMenuTap(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CallScreen()),
        );
        break;

      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ChatScreen()),
        );
        break;

      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const SubmitComplaintTicketsScreen(),
          ),
        );
        break; // ✅ FIXED

      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SupportFilesScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Map Background ───────────────────────────────
          Positioned.fill(
            child: SharedMapWidget(
              height: MediaQuery.of(context).size.height,
            ),
          ),

          // ── Top Bar ──────────────────────────────────────
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
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      GestureDetector(
                        onTap: () {
                          _navigationController.setSelectedIndex(0);
                          Get.offAll(
                            () => const HomeScreen(),
                            transition: Transition.fadeIn,
                            duration: const Duration(milliseconds: 600),
                          );
                        },
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

                      const SizedBox(width: 40),

                      // Notification
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationScreen(),
                          ),
                        ),
                        child: Stack(
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Bottom Sheet ─────────────────────────────────
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.45,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 30,
              ),
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
                  // 🔹 Drag Handle
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade600,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 🔹 Title
                  Text(
                    "Support",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Grid ───────────────────────────────
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _menuItems.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 18,
                      crossAxisSpacing: 18,
                      childAspectRatio: 2.8,
                    ),
                    itemBuilder: (context, index) {
                      final item = _menuItems[index];

                      return GestureDetector(
                        onTap: () => _handleMenuTap(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white12,
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              // Icon Box
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF2979FF),
                                      Color(0xFF1565C0),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  item['icon'],
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),

                              const SizedBox(width: 10),

                              Flexible(
                                child: Text(
                                  item['label'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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