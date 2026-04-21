import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Riden/home/notification_screen.dart';

class RidenBranding extends StatelessWidget {
  const RidenBranding({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'RIDEN',
        style: GoogleFonts.audiowide(
          fontSize: 28,
          fontWeight: FontWeight.w400,
          color: Colors.grey.shade600.withOpacity(0.82),
          height: 1.0,
        ),
      ),
    );
  }
}

class RidenTopBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback? onNotificationTap;
  const RidenTopBar({super.key, required this.onBack, this.onNotificationTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onBack,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
          ),
        ),
        GestureDetector(
          onTap: onNotificationTap ?? () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationScreen()),
            );
          },
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.25),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24, width: 1),
                ),
                child: const Icon(Icons.notifications_none_outlined, color: Colors.white, size: 20),
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
    );
  }
}
