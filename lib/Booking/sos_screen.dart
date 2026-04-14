import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SosScreen extends StatelessWidget {
  const SosScreen({super.key});

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
          
          // Bottom Sheet Overlay
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.35, // Approx ~35%, leaving ~65% covered by Map
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 35, 24, 20),
              decoration: const BoxDecoration(
                color: Color(0xFF030408),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              ),
              child: Column(
                 children: [
                   Text("Are You Safe ?", style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                   const SizedBox(height: 35),
                   
                   // Action Buttons Row
                   Row(
                     children: [
                       Expanded(child: _buildActionCard(Icons.call_rounded, "Call Emergency")),
                       const SizedBox(width: 16),
                       Expanded(child: _buildActionCard(Icons.share_rounded, "Share Ride Details")),
                     ],
                   ),
                   const Spacer(),
                   
                   // Cancel Button
                   SizedBox(
                     width: double.infinity,
                     height: 55,
                     child: ElevatedButton(
                       style: ElevatedButton.styleFrom(
                         backgroundColor: const Color.fromRGBO(255, 58, 58, 0.7),
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                         elevation: 0,
                       ),
                       onPressed: () => Navigator.pop(context),
                       child: Text("Cancel", style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                     )
                   ),
                   SizedBox(height: MediaQuery.of(context).padding.bottom + 5),
                 ]
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2), // Matching opacity 20%
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: Colors.blue[600], borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.85), fontSize: 11, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
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
