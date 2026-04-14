import 'dart:ui';
import 'package:flutter/material.dart';
import 'conic_border_painter.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double height;
  final Widget? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height = 54,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(offset: Offset(-2, 4), blurRadius: 10, spreadRadius: 0, color: Color(0x0D919191)),
          BoxShadow(offset: Offset(-7, 17), blurRadius: 18, spreadRadius: 0, color: Color(0x0A919191)),
          BoxShadow(offset: Offset(-15, 37), blurRadius: 24, spreadRadius: 0, color: Color(0x08919191)),
          BoxShadow(offset: Offset(-27, 66), blurRadius: 29, spreadRadius: 0, color: Color(0x03919191)),
          BoxShadow(offset: Offset(-42, 103), blurRadius: 31, spreadRadius: 0, color: Color(0x00919191)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF7296E4),
                  Color(0xFF174AB7),
                ],
                stops: [0.0, 0.9999],
              ),
            ),
            child: Stack(
              children: [
                // Inset shadows simulation
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.25),
                          Colors.transparent,
                          Colors.transparent,
                          Colors.white.withOpacity(0.25),
                        ],
                        stops: const [0.0, 0.1, 0.9, 1.0],
                      ),
                    ),
                  ),
                ),
                // Conic Border
                Positioned.fill(
                  child: CustomPaint(
                    painter: ConicBorderPainter(),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: onPressed,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (icon != null) ...[
                            icon!,
                            const SizedBox(width: 12),
                          ],
                          Text(
                            text,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontFamily: 'Montserrat',
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
        ),
      ),
    );
  }
}
