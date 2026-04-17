import 'package:flutter/material.dart';
import 'dart:math' as math;

class ConicBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(16));
    
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final center = Offset(size.width * 0.2051, size.height * 0.8891);
    const startAngle = 102.75 * math.pi / 180;

    paint.shader = SweepGradient(
      center: Alignment(
        (center.dx / size.width) * 2 - 1,
        (center.dy / size.height) * 2 - 1,
      ),
      startAngle: startAngle,
      colors: const [
        Color(0x80F9F9F9),
        Color(0x809C9C9C),
        Color(0x599C9C9C),
        Color(0x80FFFFFF),
        Color(0x80FFFFFF),
        Color(0x599C9C9C),
        Color(0xFFF9F9F9),
        Color(0x80FFFFFF),
        Color(0x80F9F9F9),
        Color(0x809C9C9C),
      ],
      stops: [0.0, 0.12, 0.18, 0.26, 0.39, 0.61, 0.66, 0.88, 0.99, 1.0],
    ).createShader(rect);

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
