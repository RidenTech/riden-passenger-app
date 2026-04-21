import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Riden/account/account_screen.dart';
import 'package:Riden/home/home_screen.dart';
import 'package:Riden/support/support.dart';
import 'package:Riden/widgets/riden_bottom_nav.dart';
import 'package:Riden/widgets/shared_map_widget.dart';
import 'package:Riden/Activity/ride_detail_screen.dart';
import 'package:Riden/home/notification_screen.dart';
import 'package:Riden/controllers/navigation_controller.dart';
import 'package:get/get.dart';

enum ActivityTab { all, active, completed, cancelled }

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key, this.initialTab = ActivityTab.all});

  final ActivityTab initialTab;

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  late final PageController _pageController;
  late ActivityTab _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
    _pageController = PageController(initialPage: _selectedTab.index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(ActivityTab tab) {
    if (_selectedTab == tab) return;
    setState(() => _selectedTab = tab);
    _pageController.animateToPage(
      tab.index,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  void _onBottomNavTap(int index) {
    if (index == 2) return;
    if (index == 0) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      return;
    }
    if (index == 1) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const Support()));
      return;
    }
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const AccountScreen()));
  }

  double get _mapHeightFactor =>
      _selectedTab == ActivityTab.all ? 0.20 : 0.40;

  @override
  Widget build(BuildContext context) {
    // Clamp system font scale to max 1.15 so large phone fonts never break layout
    final mq = MediaQuery.of(context);
    final clampedMq = mq.copyWith(
      textScaler:
          TextScaler.linear(mq.textScaler.scale(1.0).clamp(0.8, 1.15)),
    );

    return MediaQuery(
      data: clampedMq,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned.fill(
              child:
                  SharedMapWidget(height: clampedMq.size.height),
            ),
            _buildTopDarkOverlay(clampedMq),
            SafeArea(child: _buildHeader()),
            DraggableScrollableSheet(
              initialChildSize: 1 - _mapHeightFactor,
              minChildSize: 0.52,
              maxChildSize: 0.95,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF030408),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(34),
                      topRight: Radius.circular(34),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        width: 42,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white30,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Activities',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildTabs(),
                      const SizedBox(height: 12),
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() =>
                                _selectedTab = ActivityTab.values[index]);
                          },
                          children: ActivityTab.values.map((tab) {
                            return _ActivityTabContent(
                              tab: tab,
                              onCardTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                       ActivityRideDetailScreen(),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  clampedMq.size.width * 0.05,
                  0,
                  clampedMq.size.width * 0.05,
                  clampedMq.padding.bottom + 8,
                ),
                child: const SizedBox.shrink(), // Removed bottom nav - now locked on home screen
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              'RIDEN',
              style: GoogleFonts.audiowide(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade600.withOpacity(0.82),
                height: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                                onTap: () {
                                  Get.find<NavigationController>().setSelectedIndex(0);
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
              // Spacer for alignment
              const SizedBox(width: 36, height: 36),
              // Notification bell — fixed size
              Stack(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NotificationScreen()),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.25),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white24),
                          ),
                          child: const Icon(
                            Icons.notifications_none_outlined,
                            color: Colors.white,
                            size: 18,
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopDarkOverlay(MediaQueryData mq) {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      height: mq.size.height * (_mapHeightFactor + 0.08),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.45),
              Colors.black.withOpacity(0.10),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: ActivityTab.values.map((tab) {
          final bool isSelected = _selectedTab == tab;
          return Flexible(
            child: GestureDetector(
              onTap: () => _onTabTapped(tab),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected
                          ? const Color(0xFF4CA4FF)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  _labelForTab(tab),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: isSelected
                        ? const Color(0xFF8DC6FF)
                        : Colors.white,
                    fontSize: 11.5,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _labelForTab(ActivityTab tab) {
    switch (tab) {
      case ActivityTab.all:
        return 'All Rides';
      case ActivityTab.active:
        return 'Active';
      case ActivityTab.completed:
        return 'Completed';
      case ActivityTab.cancelled:
        return 'Canceled';
    }
  }
}

// ── Tab Content ──────────────────────────────────────────────────────────────

class _ActivityTabContent extends StatelessWidget {
  const _ActivityTabContent({
    required this.tab,
    required this.onCardTap,
  });

  final ActivityTab tab;
  final VoidCallback onCardTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 130),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _RideActivityCard(
            status: _topStatus(tab),
            statusColor: _statusColor(_topStatus(tab)),
            showAction: true,
            onActionTap: onCardTap,
          ),
          const SizedBox(height: 22),
          if (tab == ActivityTab.all) ...[
            Text(
              'Yesterday',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            const _RideActivityCard(
              status: 'Canceled',
              statusColor: Colors.red,
              showAction: false,
            ),
          ],
        ],
      ),
    );
  }

  String _topStatus(ActivityTab tab) {
    switch (tab) {
      case ActivityTab.active:
        return 'Active';
      case ActivityTab.completed:
      case ActivityTab.all:
        return 'Completed';
      case ActivityTab.cancelled:
        return 'Canceled';
    }
  }

  Color _statusColor(String status) {
    if (status == 'Canceled') return Colors.red;
    if (status == 'Active') return const Color(0xFF5FB5FF);
    return const Color(0xFF53F0B8);
  }
}

// ── Ride Card ────────────────────────────────────────────────────────────────

class _RideActivityCard extends StatelessWidget {
  const _RideActivityCard({
    required this.status,
    required this.statusColor,
    required this.showAction,
    this.onActionTap,
  });

  final String status;
  final Color statusColor;
  final bool showAction;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.32),
            Colors.white.withOpacity(0.21),
            Colors.white.withOpacity(0.24),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Status badge + price ──────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: statusColor, width: 1.4),
                  ),
                  child: Text(
                    status,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '\$45.00',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF8BC5FF),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ── Date ─────────────────────────────────────────────
          Text(
            '12th April, 2026',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: Colors.white.withOpacity(0.24)),
          const SizedBox(height: 12),

          // ── Route ─────────────────────────────────────────────
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Dot-line column
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                    ...List.generate(
                      6,
                      (_) => Container(
                        width: 2,
                        height: 4,
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        color: Colors.white70,
                      ),
                    ),
                    const Icon(Icons.near_me,
                        color: Color(0xFF6EAFFF), size: 18),
                  ],
                ),
                const SizedBox(width: 14),

                // Location texts
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pickup row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Office',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '04:30pm',
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '2972 Westheimer Rd. Santa Ana, Illinois 85486',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          color: Colors.white54,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Drop-off row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Coffee shop',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '06:30pm',
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '1901 Thornridge Cir. Shiloh, Hawaii 81063',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          color: Colors.white54,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Action button ─────────────────────────────────────
          if (showAction) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: onActionTap,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.white30),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7AAAF8), Color(0xFF386BCB)],
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}