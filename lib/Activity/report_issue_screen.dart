import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Riden/widgets/shared_map_widget.dart';
import 'package:Riden/home/notification_screen.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  int? _selectedIssue = 0;

  final List<String> _issues = const [
    'Driver was rude',
    'Vehicle was not clean',
    'Driver was late',
    'Payment issue',
    'Wrong route taken',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final cMq = mq.copyWith(
      textScaler: TextScaler.linear(mq.textScaler.scale(1.0).clamp(0.8, 1.15)),
    );
    final screenHeight = cMq.size.height;

    return MediaQuery(
      data: cMq,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            // ── Fixed header ─────────────────────────────────────
            Container(
              color: Colors.transparent,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
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
              ),
            ),

            // ── Map (45% of screen height) ───────────────────────
            SizedBox(
              height: screenHeight * 0.38,
              child: const SharedMapWidget(),
            ),

            // ── Bottom content ───────────────────────────────────
            Expanded(
              child: Container(
                color: Colors.black,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // Title
                    Center(
                      child: Text(
                        'Report Issue',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Choose Issue Type label
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Choose Issue Type',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Issues container
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF2C2C2E),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0xFF919191)
                                      .withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(-2, 4)),
                              BoxShadow(
                                  color: const Color(0xFF919191)
                                      .withOpacity(0.04),
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _issues.length,
                              separatorBuilder: (_, __) => Divider(
                                color: Colors.white.withOpacity(0.08),
                                height: 1,
                                indent: 16,
                                endIndent: 16,
                              ),
                              itemBuilder: (context, i) {
                                final selected = _selectedIssue == i;
                                return InkWell(
                                  onTap: () =>
                                      setState(() => _selectedIssue = i),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 13),
                                    child: Row(
                                      children: [
                                        // Radio circle
                                        Container(
                                          width: 22,
                                          height: 22,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: const Color(0xFF4C8EFF)
                                                  .withOpacity(
                                                      selected ? 1.0 : 0.55),
                                              width: 2,
                                            ),
                                            color: selected
                                                ? const Color(0xFF4C8EFF)
                                                    .withOpacity(0.15)
                                                : Colors.transparent,
                                          ),
                                          child: selected
                                              ? const Center(
                                                  child: CircleAvatar(
                                                    radius: 5,
                                                    backgroundColor:
                                                        Color(0xFF4C8EFF),
                                                  ),
                                                )
                                              : null,
                                        ),
                                        const SizedBox(width: 14),
                                        Text(
                                          _issues[i],
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: selected
                                                ? FontWeight.w500
                                                : FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Submit button
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          16, 16, 16, cMq.padding.bottom + 16),
                      child: GestureDetector(
                        onTap: () {
                          if (_selectedIssue != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Issue reported: ${_issues[_selectedIssue!]}',
                                  style: GoogleFonts.poppins(fontSize: 13),
                                ),
                                backgroundColor: const Color(0xFF135ABA),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 54,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFF7BACED),
                                Color(0xFF135ABA),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0xFF919191)
                                      .withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(-2, 4)),
                              BoxShadow(
                                  color: const Color(0xFF919191)
                                      .withOpacity(0.04),
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
                              'Submit Issue',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
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
      ),
    );
  }
}