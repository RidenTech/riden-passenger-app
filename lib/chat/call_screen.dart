import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Riden/widgets/shared_map_widget.dart';
import '../Booking/active_ride_screen.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // After 3 second delay, navigate to 3rd screen
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ActiveRideScreen()),
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
          // Map Background (Shared Global Map)
          Positioned.fill(
            child: SharedMapWidget(height: MediaQuery.of(context).size.height),
          ),
          _buildMapOverlay(),
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
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                    size: 20,
                                  ),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Bottom Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.45,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF030408),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // profile image
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue, width: 2),
                    ),
                    child: const CircleAvatar(
                      radius: 46,
                      backgroundImage: AssetImage("assets/images/profile.png"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Sergio Fernandez",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Calling.....",
                    style: GoogleFonts.poppins(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  // call action bar
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCallIcon(
                          Icons.more_horiz,
                          Colors.black,
                          Colors.white.withOpacity(0.8),
                        ),
                        _buildCallIcon(
                          Icons.videocam,
                          Colors.black,
                          Colors.white.withOpacity(0.8),
                        ),
                        _buildCallIcon(
                          Icons.mic_off,
                          Colors.black,
                          Colors.white.withOpacity(0.8),
                        ),
                        _buildCallIcon(
                          Icons.call_end,
                          Colors.white,
                          Colors.red,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallIcon(IconData icon, Color iconColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Icon(icon, color: iconColor, size: 24),
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
              painter: RoutePainterChat(), // reuse the math
            ),
          ),
          Positioned(
            top: 350,
            left: 90,
            child: Transform.rotate(
              angle: -0.2, // rotate right
              child: Image.asset(
                "assets/images/car.png",
                width: 40,
                height: 20,
                fit: BoxFit.contain,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 310,
            left: 60,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "5 min away",
                style: GoogleFonts.poppins(
                  color: Colors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
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
