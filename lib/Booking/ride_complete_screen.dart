import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'rate_driver_screen.dart';

class RideCompleteScreen extends StatefulWidget {
  const RideCompleteScreen({super.key});

  @override
  State<RideCompleteScreen> createState() => _RideCompleteScreenState();
}

class _RideCompleteScreenState extends State<RideCompleteScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // After 2 seconds, push to Rate Driver Screen
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RateDriverScreen()),
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
          // Map Background (covering ~80%)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height * 0.3,
            child: Image.asset(
              "assets/images/map.png",
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.6),
            ),
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
          
          // Bottom Area (~35% black overlay)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.40,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF030408),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              ),
              child: Column(
                 mainAxisAlignment: MainAxisAlignment.end,
                 children: [
                   Center(
                     child: Image.asset(
                       "assets/images/complete.png",
                       width: 120,
                       height: 120,
                       errorBuilder: (context, error, stackTrace) {
                         return Container(
                           width: 120,
                           height: 120,
                           decoration: BoxDecoration(
                             color: Colors.white.withOpacity(0.2),
                             borderRadius: BorderRadius.circular(20),
                             border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
                           ),
                           child: const Icon(Icons.check, color: Colors.blue, size: 60),
                         );
                       },
                     ),
                   ),
                   const SizedBox(height: 24),
                   Text("Your Ride Is Completed", style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                   const SizedBox(height: 16),
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 40),
                     child: Text(
                       "Thanks For Choosing Us. Hope You Have A Great Day Ahead Of You!",
                       textAlign: TextAlign.center,
                       style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13, height: 1.5),
                     ),
                   ),
                   SizedBox(height: MediaQuery.of(context).padding.bottom + 40),
                 ]
              ),
            ),
          ),
        ],
      ),
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
