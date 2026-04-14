import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../chat/chat_screen.dart';
import '../chat/call_screen.dart';
import 'active_ride_screen.dart';

class DriverSearchView extends StatefulWidget {
  const DriverSearchView({super.key});

  @override
  State<DriverSearchView> createState() => _DriverSearchViewState();
}

class _DriverSearchViewState extends State<DriverSearchView> {
  bool _isDriverFound = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Simulate finding a driver after 3 secondsw 
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isDriverFound = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Map Background
          Positioned.fill(
            child: Image.asset(
              "assets/images/map.png",
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.6),
            ),
          ),

          // Searching Overlay (Only visible when not found)
          if (!_isDriverFound) _buildSearchingOverlay(),

          // Top Action Buttons
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
                // Top Row: Greeting
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.arrow_back,
                                      color: Colors.black, size: 20),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.25),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white24, width: 1),
                            ),
                            child: const Icon(Icons.notifications_none_outlined,
                                color: Colors.white, size: 20),
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

          // Bottom Sheet
          if (!_isDriverFound)
            _buildSearchingSheet()
          else
            _buildFoundSheet(),
        ],
      ),
    );
  }

  Widget _buildSearchingOverlay() {
    return Positioned(
      top: 130,
      left: 0,
      right: 0,
      child: Column(
        children: [
          // Searching Flow Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Searching", style: GoogleFonts.poppins(color: Colors.blue, fontSize: 13, fontWeight: FontWeight.w600)),
              Container(width: 40, height: 1, color: Colors.blue, margin: const EdgeInsets.symmetric(horizontal: 8)),
              Text("Matching", style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13)),
              Container(width: 40, height: 1, color: Colors.white24, margin: const EdgeInsets.symmetric(horizontal: 8)),
              Text("Confirming", style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            "Finding Closest Driver",
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "This may take few second",
            style: GoogleFonts.poppins(color: Colors.white54, fontSize: 14),
          ),
          const SizedBox(height: 50),
          // Radar Image
          Image.asset("assets/images/location.png", width: 300, height: 300, fit: BoxFit.contain, errorBuilder: (context, error, stackTrace) => const Icon(Icons.radar, color: Colors.blue, size: 100)),
        ],
      ),
    );
  }

  Widget _buildSearchingSheet() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        decoration: const BoxDecoration(
          color: Color(0xFF030408),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Searching For Driver",
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            _buildCancelButton("Cancel Ride"),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 10),
          ],
        ),
      ),
    );
  }

  Widget _buildFoundSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.40,
      minChildSize: 0.40,
      maxChildSize: 0.7,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF030408),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Indicator
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Car Arriving", 
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "5 mins away", 
                      style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      // Driver Card
                      _buildDriverCard(),
                      const SizedBox(height: 24),
                      
                      // Key Stats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem("C\$70", "Price"),
                          _buildStatItem("SL 984-ZWRT", "Licence Plate No"),
                          _buildStatItem("4 Seats", "Seats"),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Additional details revealed on drag up
                      _buildDestinationCard(),
                      const SizedBox(height: 20),
                      _buildRideDetailsCard(),
                      const SizedBox(height: 20),
                      _buildShareButton(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              // Triple Action Buttons Row
              Padding(
                padding: EdgeInsets.fromLTRB(24, 10, 24, MediaQuery.of(context).padding.bottom + 10),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        text: "Confirm",
                        color: Colors.blue,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ActiveRideScreen())),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildActionButton(
                        text: "Change Driver",
                        color: Colors.white.withOpacity(0.2),
                        onTap: () {
                          setState(() {
                            _isDriverFound = false;
                            // Reset timer to simulate a new search
                            _timer?.cancel();
                            _timer = Timer(const Duration(seconds: 3), () {
                              if (mounted) {
                                setState(() {
                                  _isDriverFound = true;
                                });
                              }
                            });
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildActionButton(
                        text: "Cancel Ride",
                        color: const Color(0xFFC43535),
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDriverCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundImage: AssetImage("assets/images/profile.png"), 
            backgroundColor: Colors.white24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sergio Fernandez", 
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                ),
                Text(
                  "Driver", 
                  style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          _buildIconButton(
            Icons.chat_bubble_rounded, 
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen())),
          ),
          const SizedBox(width: 12),
          _buildIconButton(
            Icons.phone_rounded,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CallScreen())),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue[600],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildDestinationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Location  ",
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
                child: Column(
                  children: [
                    const SizedBox(height: 6),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Vertical Dotted Line
                    Column(
                      children: List.generate(
                        11,
                        (index) => Container(
                          width: 2,
                          height: 4,
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 1),
                    const Icon(Icons.near_me_rounded,
                        color: Colors.blue, size: 27 ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Home",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "2972 Westheimer Rd. Santa Ana, Illinois 85486",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(color: Colors.white54, fontSize: 11),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      "Coffee Shop",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "1901 Thorridge Cir. Shiloh, Hawaii 81063",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(color: Colors.white54, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRideDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Expanded(
                 child: Text(
                   "Ride Details", 
                   maxLines: 1,
                   overflow: TextOverflow.ellipsis,
                   style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                 ),
               ),
               const SizedBox(width: 8),
               Text(
                 "Booking ID : 2345", 
                 style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12),
               ),
            ],
          ),
          const SizedBox(height: 20),
          Text("Riden SUV(SL 984-ZWRT)", style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
          const Divider(color: Colors.white24, height: 30),
          _buildDetailRow("Total Distance", "9.8 km"),
          const Divider(color: Colors.white24, height: 30),
          _buildDetailRow("Total Fare", "C\$70"),
          const Divider(color: Colors.white24, height: 30),
          _buildDetailRow("Discount", "C\$0"),
          const Divider(color: Colors.white24, height: 30),
          _buildDetailRow("Payment Method", "Wallet"),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title, 
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value, 
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildActionButton({required String text, required Color color, required VoidCallback onTap}) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        border: color == Colors.white.withOpacity(0.2) 
          ? Border.all(color: Colors.white.withOpacity(0.15), width: 1)
          : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: Colors.white, 
                fontSize: 12, 
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShareButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
            child: const Icon(Icons.share, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 16),
          Text("Share Ride Details", style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildCancelButton(String text) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFC43535), 
        borderRadius: BorderRadius.circular(14),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String val, String title) {
    return Column(
      children: [
        Text(
          val, 
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          title, 
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }
}
