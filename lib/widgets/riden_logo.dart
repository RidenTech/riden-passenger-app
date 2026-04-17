import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RidenLogo extends StatelessWidget {
  final double fontSize;
  final Color? color;

  const RidenLogo({
    super.key,
    this.fontSize = 28,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'RIDEN',
      style: GoogleFonts.audiowide(
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        color: color ?? Colors.white.withOpacity(0.9),
        letterSpacing: 2.0,
      ),
    );
  }
}
