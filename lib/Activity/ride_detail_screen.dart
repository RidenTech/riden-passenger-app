import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Riden/widgets/shared_map_widget.dart';
import 'package:Riden/home/notification_screen.dart';
import 'report_issue_screen.dart';

class ActivityRideDetailScreen extends StatefulWidget {
  const ActivityRideDetailScreen({super.key});

  @override
  State<ActivityRideDetailScreen> createState() =>
      _ActivityRideDetailScreenState();
}

class _ActivityRideDetailScreenState extends State<ActivityRideDetailScreen> {
  int _userRating = 4;

  // Matches activities.dart card background
  static const Color _cardBg = Color(0xFF2C2C2E);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final cMq = mq.copyWith(
      textScaler: TextScaler.linear(mq.textScaler.scale(1.0).clamp(0.8, 1.15)),
    );

    return MediaQuery(
      data: cMq,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            // ── Fixed top: header + date ──────────────────────────
            _buildTopBar(cMq),

            // ── Map strip (35% of screen) ─────────────────────────
            SizedBox(
              height: cMq.size.height * 0.27,
              child: const SharedMapWidget(),
            ),

            // ── Scrollable bottom sheet ───────────────────────────
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(0)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Destination ──────────────────────────
                      _destinationCard(),
                      const SizedBox(height: 12),

                      // ── Ride Details ──────────────────────────
                      _rideDetailsCard(),
                      const SizedBox(height: 20),

                      // ── Driver Details ────────────────────────
                      _sectionTitle('Driver Details'),
                      const SizedBox(height: 10),
                      _driverCard(),
                      const SizedBox(height: 20),

                      // ── Ratings & Reviews ─────────────────────
                      _sectionTitle('Ratings & Reviews'),
                      const SizedBox(height: 10),
                      _ratingsCard(),
                      const SizedBox(height: 28),

                      // ── Download Receipt button ───────────────
                      _gradientButton(
                        label: 'Download Receipt',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Receipt downloaded.')),
                          );
                        },
                      ),
                      const SizedBox(height: 12),

                      // ── Report an Issue button ────────────────
                      _gradientButton(
                        label: 'Report an Issue',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ReportIssueScreen()),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Top bar: RIDEN + back + bell + date title ──────────────────────────

  Widget _buildTopBar(MediaQueryData cMq) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // RIDEN row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    'RIDEN',
                    style: GoogleFonts.audiowide(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade500.withOpacity(0.85),
                    ),
                  ),
                  // Back
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Builder(builder: (ctx) {
                      return GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back,
                              color: Colors.black, size: 18),
                        ),
                      );
                    }),
                  ),
                  // Bell
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
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
                  ),
                ],
              ),
            ),

            // Date title
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Text(
                '12th April, 2026',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Cards ──────────────────────────────────────────────────────────────

  Widget _destinationCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Destination',
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 14),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // dot-dash-icon column
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                    ),
                    ...List.generate(
                      6,
                      (_) => Container(
                        width: 2,
                        height: 4,
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        color: Colors.white38,
                      ),
                    ),
                    const Icon(Icons.near_me,
                        color: Color(0xFF6EAFFF), size: 16),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Home',
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                      Text('2972 Westheimer Rd. Santa Ana, Illinois 85486',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              color: Colors.white54, fontSize: 11)),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Divider(
                            color: Colors.white.withOpacity(0.12),
                            height: 1),
                      ),
                      Text('Coffee Shop',
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                      Text('1901 Thornridge Cir. Shiloh, Hawaii 81063',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              color: Colors.white54, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _rideDetailsCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ride Details',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              Text('Booking ID : 2345',
                  style: GoogleFonts.poppins(
                      color: Colors.white54, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 10),
          Text('Riden SUV(SI 984-ZWRT)',
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          _rowDivider(),
          _detailRow('Total Distance', '9.8 km'),
          _rowDivider(),
          _detailRow('Total Fare', 'C\$70'),
          _rowDivider(),
          _detailRow('Discount', 'C\$0'),
          _rowDivider(),
          _detailRow('Payment Method', 'Wallet'),
        ],
      ),
    );
  }

  Widget _driverCard() {
    return _card(
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white.withOpacity(0.1),
            child: const Icon(Icons.person, color: Colors.white70, size: 26),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sergio Fernandez',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              Text('Driver',
                  style: GoogleFonts.poppins(
                      color: Colors.white54, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ratingsCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Rating',
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (i) {
              return GestureDetector(
                onTap: () => setState(() => _userRating = i + 1),
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(
                    i < _userRating ? Icons.star : Icons.star_border,
                    color: i < _userRating
                        ? const Color(0xFF4C8EFF)
                        : Colors.white38,
                    size: 28,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 14),
          Text('Reviews',
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            '"The Ride was good overall but there are something like music the driver was playing was too loud. I want to gave 5 stars but that one factor holds me from doing it other than everything was top notch. Never had an amazing experience like that"',
            style: GoogleFonts.poppins(
                color: Colors.white70, fontSize: 12, height: 1.6),
          ),
        ],
      ),
    );
  }

  // ── Shared helpers ─────────────────────────────────────────────────────

  Widget _card({required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: child,
      );

  Widget _sectionTitle(String t) => Text(
        t,
        style: GoogleFonts.poppins(
            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
      );

  Widget _detailRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
            Text(value,
                style: GoogleFonts.poppins(
                    color: Colors.white70, fontSize: 13)),
          ],
        ),
      );

  Widget _rowDivider() =>
      Divider(color: Colors.white.withOpacity(0.08), height: 1, thickness: 1);

  Widget _gradientButton({
    required String label,
    required VoidCallback onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF7BACED), Color(0xFF135ABA)],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xFF919191).withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(-2, 4)),
              BoxShadow(
                  color: const Color(0xFF919191).withOpacity(0.04),
                  blurRadius: 18,
                  offset: const Offset(-7, 17)),
              BoxShadow(
                  color: Colors.white.withOpacity(0.25),
                  blurRadius: 4,
                  offset: const Offset(0, 4)),
              BoxShadow(
                  color: Colors.white.withOpacity(0.25),
                  blurRadius: 4,
                  offset: const Offset(0, -5)),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
}