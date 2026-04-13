// bookings_bottom_sheet.dart
// ignore_for_file: deprecated_member_use
//
// Place at: lib/bookings/bookingride_loading.dart

import 'dart:ui';

import 'package:Riden/theme/app_colors.dart';
import 'package:flutter/material.dart'; // RidenDarkBackground & RidenColors

class BookingsBottomSheet extends StatelessWidget {
  final ScrollController scrollController;

  const BookingsBottomSheet({super.key, required this.scrollController});

  static const List<Map<String, String>> _locations = [
    {
      'title': 'Office',
      'address': '2972 Westheimer Rd, Santa Ana, Illinois 85486',
    },
    {
      'title': 'Coffee shop',
      'address': '1901 Thornridge Cir, Shiloh, Hawaii 81063',
    },
    {
      'title': 'Shopping center',
      'address': '4140 Parker Rd, Allentown, New Mexico 31134',
    },
    {
      'title': 'Office',
      'address': '2972 Westheimer Rd, Santa Ana, Illinois 85486',
    },
    {
      'title': 'Coffee shop',
      'address': '1901 Thornridge Cir, Shiloh, Hawaii 81063',
    },
    {
      'title': 'Shopping center',
      'address': '4140 Parker Rd, Allentown, New Mexico 31134',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(28),
        topRight: Radius.circular(28),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── 1. RidenDarkBackground gradient ──────────────────────────────
          const RidenDarkBackground(),

          // ── 2. Frosted glass blur over gradient ───────────────────────────
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              // Tinted dark glass — tweak opacity to taste (0.30–0.50)
              color: const Color(0xFF151826).withOpacity(0.45),
            ),
          ),

          // ── 3. Top border glow ────────────────────────────────────────────
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.10),
                  width: 1,
                ),
              ),
            ),
          ),

          // ── 4. Content ────────────────────────────────────────────────────
          // Wrap in Theme to strip any inherited Divider color (kills yellow lines)
          Theme(
            data: Theme.of(context).copyWith(
              dividerTheme: const DividerThemeData(color: Colors.transparent),
              dividerColor: Colors.transparent,
            ),
            child: Column(
              children: [
                // Drag handle
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.28),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Pickup + Destination card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const _LocationCard(),
                ),

                const SizedBox(height: 4),

                // Location list — NO separatorBuilder, padding handles spacing
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: _locations.length,
                    itemBuilder: (ctx, i) {
                      final loc = _locations[i];
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Red dot
                                Container(
                                  width: 11,
                                  height: 11,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE53935),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        loc['title']!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14.5,
                                          letterSpacing: 0.1,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        loc['address']!,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.50),
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Clean single-pixel separator — only between items, not after last
                          if (i < _locations.length - 1)
                            Container(
                              margin: const EdgeInsets.only(left: 25),
                              height: 1,
                              color: Colors.white.withOpacity(0.09),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Pickup + Destination card ────────────────────────────────────────────────
class _LocationCard extends StatelessWidget {
  const _LocationCard();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.82),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.55), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.28),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Pickup row
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.directions_walk_rounded,
                        size: 20,
                        color: Color(0xFF3A3A4A),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pickup',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.40),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            '2972 Westheimer Rd, Santa Ana, Illinois 85486',
                            style: TextStyle(
                              color: Color(0xFF141420),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Internal card divider — use Container not Divider widget
              Padding(
                padding: const EdgeInsets.fromLTRB(62, 10, 14, 10),
                child: Container(
                  height: 1,
                  color: Colors.grey.withOpacity(0.15),
                ),
              ),

              // Destination row
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.location_on_rounded,
                        size: 20,
                        color: Color(0xFFE53935),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Where to go?',
                        style: TextStyle(
                          color: Color(0xFFB0B0BA),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // MAP button
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF252535),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.08),
                          width: 1,
                        ),
                      ),
                      child: const Text(
                        'MAP',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
