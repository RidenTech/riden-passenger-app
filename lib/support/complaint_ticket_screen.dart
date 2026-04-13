import 'package:Riden/support/complaint_view_screen.dart';
import 'package:Riden/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class ComplaintTicketScreen extends StatelessWidget {
  const ComplaintTicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data
    final complaints = [
      {
        "section": "Today",
        "tickets": [
          {
            "type": "Complaint Type",
            "bookingId": "2345",
            "desc":
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text.",
          },
        ],
      },
      {
        "section": "Yesterday",
        "tickets": [
          {
            "type": "Complaint Type",
            "bookingId": "2346",
            "desc":
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text.",
          },
        ],
      },
      {
        "section": "May, 27 2023",
        "tickets": [
          {
            "type": "Complaint Type",
            "bookingId": "2348",
            "desc":
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text.",
          },
          {
            "type": "Complaint Type",
            "bookingId": "2349",
            "desc":
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text.",
          },
        ],
      },
    ];

    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            RidenDarkBackground(),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 19,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 22,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          "Complaint Tickets",
                          style: GoogleFonts.audiowide(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 19),
                    // Sections
                    ...complaints.map(
                      (section) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            section['section'] as String,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15.1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...(section['tickets'] as List).map((ticket) {
                            return ComplaintTicketRow(
                              type: ticket['type'],
                              bookingId: ticket['bookingId'],
                              desc: ticket['desc'],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ComplaintViewScreen(),
                                  ),
                                );
                              },
                            );
                          }),
                          const SizedBox(height: 16),
                        ],
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

class ComplaintTicketRow extends StatelessWidget {
  final String type;
  final String bookingId;
  final String desc;
  final VoidCallback onTap;

  const ComplaintTicketRow({
    required this.type,
    required this.bookingId,
    required this.desc,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 7),
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 11),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          type,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.4,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.21),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Booking ID : $bookingId",
                            style: GoogleFonts.poppins(
                              color: Colors.black87,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 7),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white70,
                          size: 15,
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Text(
                      desc,
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 13.7,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
