// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';

// ─────────────── LIGHT THEME COLORS ────────────────
class AppColors {
  static const gradientColors = [
    Color(0xFFF9F6F5),
    Color(0xFFECC9B3),
    Color(0xFFD6DFDF),
    Color(0xFFA7C5C9),
    Color(0xFFE1F3F5),
  ];
  static const gradientStops = [0.0, 0.23, 0.52, 0.73, 1.0];
  static const primaryRed = Color(0xFFFF161F);
  static const textDark = Color(0xFF141414);
  static const divider = Colors.black26;
  static const glassWhite = Colors.white;

  static Color glassShadow = Colors.white.withOpacity(0.2);
}

// ─────────────── DARK THEME COLORS ────────────────
class AppColorsDark {
  static const gradientColors = [
    Color(0xFF2B3146),
    Color(0xFF242B40),
    Color(0xFF1C2438),
    Color(0xFF162033),
    Color(0xFF10192D),
    Color(0xFF0D1528),
    Color(0xFF0A1124),
  ];
  static const gradientStops = [0.0, 0.18, 0.38, 0.58, 0.76, 0.9, 1.0];
  static const primaryRed = Color(0xFFFF161F);
  static const textDark = Colors.white;
  static const divider = Colors.white24;
  static const glassWhite = Colors.white;
}

// ─────────────── RIDEN CUSTOM DARK PALETTE ────────────────
abstract class RidenColors {
  static const Color backgroundBase = Color(0xFF18192B);
  static const Color backgroundTopLeft = Color(0xFF3C3441);
  static const Color backgroundTopRight = Color(0xFF1B1C2E);
  static const Color warmCopper = Color(0xFF734337);
  static const Color warmCopperDeep = Color(0xFF62412E);
  static const Color warmCopperLight = Color(0xFF69403A);
  static const Color tealSlate = Color(0xFF3A5F72);
  static const Color tealSlateLight = Color(0xFF547483);
  static const Color tealSlateDark = Color(0xFF2B4F65);
  static const Color centerBlend = Color(0xFF3A4C55);
  static const Color centerBlendLight = Color(0xFF627070);

  static const Color brandRed = Color(0xFFEA4242);
  static const Color brandRedGlow = Color(0x80EA4242);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFBDBDBD);
  static const Color textHint = Color(0xFF757575);

  static const Color glassSurface = Color(0x993A3F48);
  static const Color glassBorder = Color(0x33FFFFFF);

  static const Color divider = Color(0x22FFFFFF);
  static const Color homeIndicator = Color(0x55FFFFFF);
  static const Color shadowDark = Color(0x40000000);

  // ── 30% opaque gradient for bottom sheet backgrounds ────────────────────
  static const List<Color> customGradientColors = [
    Color(0x4D12C5ED), // 30% opacity cyan
    Color(0x4DC2B324), // 30% opacity gold
    Color(0x4DFF4004), // 30% opacity orange-red
    Color(0x4DFFFFFF), // 30% opacity white
  ];
  static const List<double> customGradientStops = [0.0, 0.35, 0.70, 1.0];
  static const LinearGradient customGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: customGradientColors,
    stops: customGradientStops,
  );
}

// ─────────────── RIDEN DARK BACKGROUND WIDGET ────────────────
class RidenDarkBackground extends StatelessWidget {
  const RidenDarkBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Gradient background blobs
        Positioned.fill(
          child: CustomPaint(painter: _DarkGradientPainter()),
        ),

        // 2. Frosted glass blur layer
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
            child: Container(
              decoration: BoxDecoration(
                // semi-transparent white glass tint
                color: Colors.white.withOpacity(0.06),
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withOpacity(0.18),
                    width: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DarkGradientPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Base: dark navy
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()..color = const Color(0xFF1A1B2E),
    );

    // Warm copper/brown glow — top-left
    _blob(
      canvas,
      center: Offset(w * 0.15, h * 0.30),
      rx: w * 0.70,
      ry: h * 0.50,
      color: const Color(0xFF8B4A35), // warm copper
      alpha: 170,
    );

    // Slightly deeper copper lower-left
    _blob(
      canvas,
      center: Offset(w * 0.05, h * 0.55),
      rx: w * 0.50,
      ry: h * 0.35,
      color: const Color(0xFF6B3828),
      alpha: 130,
    );

    // Teal/slate glow — bottom-right
    _blob(
      canvas,
      center: Offset(w * 0.82, h * 0.68),
      rx: w * 0.70,
      ry: h * 0.52,
      color: const Color(0xFF2E6B72), // teal slate
      alpha: 165,
    );

    // Lighter teal highlight
    _blob(
      canvas,
      center: Offset(w * 0.90, h * 0.50),
      rx: w * 0.40,
      ry: h * 0.30,
      color: const Color(0xFF3D8A8F),
      alpha: 110,
    );

    // Center neutral blend
    _blob(
      canvas,
      center: Offset(w * 0.50, h * 0.50),
      rx: w * 0.55,
      ry: h * 0.40,
      color: const Color(0xFF3A4555),
      alpha: 80,
    );
  }

  void _blob(
    Canvas canvas, {
    required Offset center,
    required double rx,
    required double ry,
    required Color color,
    required int alpha,
  }) {
    final solidColor = Color.fromARGB(
      alpha,
      color.red,
      color.green,
      color.blue,
    );
    final clearColor = Color.fromARGB(0, color.red, color.green, color.blue);

    final paint = Paint()
      ..shader = RadialGradient(colors: solidColor == clearColor ? [solidColor, clearColor] : [solidColor, clearColor]).createShader(
        Rect.fromCenter(center: center, width: rx * 2, height: ry * 2),
      );

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(1.0, ry / rx);
    canvas.translate(-center.dx, -center.dy);
    canvas.drawCircle(center, rx, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_DarkGradientPainter _) => false;
}
