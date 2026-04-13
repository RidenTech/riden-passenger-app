import 'dart:ui';
import 'package:flutter/material.dart';
import 'conic_border_painter.dart';
import 'custom_text_field.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isDark;
  final Widget? icon;
  final bool hasBorder;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isDark = true,
    this.icon,
    this.hasBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          const BoxShadow(offset: Offset(-2, 4), blurRadius: 10, color: Color(0x0D919191)),
          const BoxShadow(offset: Offset(-7, 17), blurRadius: 18, color: Color(0x0A919191)),
          const BoxShadow(offset: Offset(-15, 37), blurRadius: 24, color: Color(0x08919191)),
          const BoxShadow(offset: Offset(-27, 66), blurRadius: 29, color: Color(0x03919191)),
          const BoxShadow(offset: Offset(-42, 103), blurRadius: 31, color: Color(0x00919191)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isDark ? Colors.white.withOpacity(0.1) : Colors.white,
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
                if (hasBorder)
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
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white : const Color(0xFF141414),
                            ),
                          ),
                          if (isDark && icon == null) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                          ]
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
