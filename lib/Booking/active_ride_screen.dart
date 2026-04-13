import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ride_complete_screen.dart';
import 'sos_screen.dart';

class ActiveRideScreen extends StatefulWidget {
  const ActiveRideScreen({super.key});

  @override
  State<ActiveRideScreen> createState() => _ActiveRideScreenState();
}

class _ActiveRideScreenState extends State<ActiveRideScreen> {
  double _sheetPosition = 0.35;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RideCompleteScreen()),
        );
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
          _buildMapOverlay(),
          // Top Action Buttons
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24, width: 1),
                    ),
                    child: const Icon(Icons.notifications_none_outlined, color: Colors.white, size: 22),
                  ),
                ],
              ),
            ),
          ),
          
          // Dynamic SOS Button on bottom right tracking the sheet position
          Positioned(
            right: 20,
            bottom: (_sheetPosition * MediaQuery.of(context).size.height) + 20,
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SosScreen())),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                    color: const Color(0xFFE53935), // Red
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.redAccent.withOpacity(0.5), width: 2),
                  ),
                  child: const Icon(Icons.shield_outlined, color: Colors.white, size: 20),
                ),
                const SizedBox(height: 4),
                Text("SOS", style: GoogleFonts.poppins(color: const Color(0xFFE53935), fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
            ),
          ),

          // Draggable Bottom Sheet
          NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              setState(() {
                _sheetPosition = notification.extent;
              });
              return true;
            },
            child: DraggableScrollableSheet(
              initialChildSize: 0.35,
              minChildSize: 0.35,
              maxChildSize: 0.85,
              builder: (context, scrollController) {
                return Container(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  decoration: const BoxDecoration(
                    color: Color(0xFF030408),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController, // Allow scrolling the sheet
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
                        const SizedBox(height: 20),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Active Ride", style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                            Text("5 mins away from destination", style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        if (_sheetPosition <= 0.4) ...[
                          // Collapsed state profile info
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 26,
                                backgroundImage: AssetImage("assets/images/r.png"), 
                                backgroundColor: Colors.white,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Sergio Fernandez", style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                                    Text("Driver", style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13)),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text("C\$70", style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                  Text("Price", style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13)),
                                ],
                              ),
                            ],
                          ),
                        ] else ...[
                          // Expanded State
                          // 1. Profile Container
                          _buildInfoContainer(
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
                                      Text("Sergio Fernandez", style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                                      Text("Driver", style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // 2. Destination Container
                          _buildInfoContainer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Destination", style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 16),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        const SizedBox(height: 5),
                                        Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                                        const SizedBox(height: 4),
                                        ...List.generate(7, (index) => Container(
                                          width: 2, height: 4, margin: const EdgeInsets.only(bottom: 4), color: Colors.white54
                                        )),
                                        const Icon(Icons.near_me, color: Colors.blue, size: 16),
                                      ],
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Home", style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                          Text("2972 Westheimer Rd. Santa Ana, Illinois 85486", style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12)),
                                          const SizedBox(height: 24),
                                          Text("Coffee Shop", style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                          Text("1901 Thornridge Cir. Shiloh, Hawaii 81063", style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // 3. Ride Details Container
                          _buildInfoContainer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Ride Details", style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                    Text("Booking ID : 2345", style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12)),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Text("Riden SUV(SI 984-ZWRT)", style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.9), fontSize: 14, fontWeight: FontWeight.w600)),
                                const Divider(color: Colors.white24, height: 30),
                                _buildRideDetailRow("Total Distance", "9.8 km"),
                                const Divider(color: Colors.white24, height: 30),
                                _buildRideDetailRow("Total Fare", "C\$70"),
                                const Divider(color: Colors.white24, height: 30),
                                _buildRideDetailRow("Discount", "C\$0"),
                                const Divider(color: Colors.white24, height: 30),
                                _buildRideDetailRow("Payment Method", "Wallet"),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // 4. Add Tips Section
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Add Tips", style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: ["10%", "15%", "20%", "25%"].map((t) => _buildTipButton(t)).toList(),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {},
                            child: Text("Enter Custom Amount", style: GoogleFonts.poppins(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.w600)),
                          ),
                        ],
                        
                        SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
      ),
      child: child,
    );
  }

  Widget _buildRideDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.9), fontSize: 13, fontWeight: FontWeight.w500)),
        Text(value, style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.9), fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildTipButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
      ),
      child: Text(text, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildMapOverlay() {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
             top: 360,
             left: 100,
             child: CustomPaint(
                size: const Size(200, 100),
                painter: RoutePainterChat(), 
             ),
          ),
          Positioned(
            top: 395,
            left: 135,
            child: Transform.rotate(
              angle: -0.2, // rotate right
              child: Image.asset("assets/images/car.png", width: 40, height: 20, fit: BoxFit.contain, color: Colors.white),
            ),
          ),
          Positioned(
            top: 350,
            left: 90,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Positioned(
            top: 440,
            left: 280,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoutePainterChat extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    
    Path path = Path();
    path.moveTo(0, 0); 
    path.lineTo(size.width * 0.9, size.height * 0.3);
    path.lineTo(size.width * 0.9, size.height * 0.8);
    path.lineTo(size.width - 15, size.height);
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
