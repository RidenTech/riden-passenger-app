import 'package:Riden/home/ride_request_view.dart';
import 'package:Riden/widgets/background_image.dart';
import 'package:Riden/widgets/riden_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0;
  bool _showRideSelection = false;
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundImage(
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.5),
        body: Stack(
          children: [
            // Main Home Content (Wrapped in SafeArea)
            if (!_showRideSelection)
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
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Good Evening",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  const Text("👋", style: TextStyle(fontSize: 13)),
                                ],
                              ),
                              Text(
                                "Jackson Morgan",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F1115),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white.withOpacity(0.12), width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.30),
                              blurRadius: 15,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_rounded, color: Colors.white, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                                decoration: InputDecoration(
                                  hintText: "Where are you going?",
                                  hintStyle: GoogleFonts.poppins(color: Colors.white54, fontSize: 14),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showRideSelection = true;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                child: const Icon(Icons.arrow_forward_rounded, color: Colors.black, size: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Recent Destinations Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Recent destinations",
                            style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "See all >",
                            style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.6), fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Destination Cards (Local Scroll)
                    SizedBox(
                      height: 180, // Fixed height for local scroll area
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        physics: const BouncingScrollPhysics(),
                        children: [
                          _buildDestinationCard(
                            icon: Icons.work_outline,
                            title: "Office",
                            subtitle: "2972 Westheimer Rd.",
                            time: "12 min",
                            price: "14.20",
                            dotColor: Colors.blue,
                          ),
                          const SizedBox(height: 8),
                          _buildDestinationCard(
                            icon: Icons.coffee_outlined,
                            title: "Coffee shop",
                            subtitle: "1901 Thorridge Cir.",
                            time: "8 min",
                            price: "10.50",
                            dotColor: Colors.orange,
                          ),
                          const SizedBox(height: 8),
                          _buildDestinationCard(
                            icon: Icons.home_outlined,
                            title: "Home",
                            subtitle: "Home",
                            time: "15 min",
                            price: "9.80",
                            dotColor: Colors.green,
                          ),
                        ],
                      ),
                    ),

                    // Map Image Section (Flexible with Dual Fade)
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(color: Colors.transparent),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          child: Stack(
                            children: [
                              ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.transparent, Colors.black, Colors.black, Colors.transparent],
                                    stops: [0.0, 0.15, 0.8, 1.0],
                                  ).createShader(bounds);
                                },
                                blendMode: BlendMode.dstIn,
                                child: Image.asset(
                                  "assets/images/map.png",
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Location Icon - Repositioned for Nav Overlap
                              Positioned(
                                bottom: 100,
                                right: 20,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color:  Colors.grey.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.white10),
                                  ),
                                  child: const Icon(Icons.my_location_rounded, color: Colors.white, size: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Floating Custom Bottom Navigation Bar
            if (!_showRideSelection)
              Positioned(
                bottom: 10,
                left: 24,
                right: 24,
                child: RidenBottomNav(
                  selectedIndex: _selectedNavIndex,
                  onItemSelected: (index) {
                    setState(() {
                      _selectedNavIndex = index;
                    });
                  },
                ),
              ),

            // Ride Selection View Overlay (Full-screen, non-SafeArea mapped)
            if (_showRideSelection)
              Positioned.fill(
                child: RideRequestView(
                  onBack: () {
                    setState(() {
                      _showRideSelection = false;
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDestinationCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required String price,
    required Color dotColor,
  }) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF111318),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Stack(
        children: [
          // Top-left accent glow
          Positioned(
            top: -20,
            left: -15,
            child: Container(
              width: 30,  
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E5197).withOpacity(0.6),
                    blurRadius: 35,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      time,
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      "\$$price",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 15),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
