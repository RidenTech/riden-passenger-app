import 'dart:ui';
import 'package:flutter/material.dart';
import 'conic_border_painter.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final String? label;
  final bool obscureText;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final EdgeInsetsGeometry? contentPadding;

  const CustomTextField({
    super.key,
    this.hintText,
    this.label,
    this.obscureText = false,
    this.controller,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              label!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ],
        Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              const BoxShadow(
                offset: Offset(-2, 4),
                blurRadius: 10,
                color: Color(0x0D919191),
              ),
              const BoxShadow(
                offset: Offset(-7, 17),
                blurRadius: 18,
                color: Color(0x0A919191),
              ),
              const BoxShadow(
                offset: Offset(-15, 37),
                blurRadius: 24,
                color: Color(0x08919191),
              ),
              const BoxShadow(
                offset: Offset(-27, 66),
                blurRadius: 29,
                color: Color(0x03919191),
              ),
              const BoxShadow(
                offset: Offset(-42, 103),
                blurRadius: 31,
                color: Color(0x00919191),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white.withOpacity(0.05),
                ),
                child: Stack(
                  children: [
                    // Inset shadows simulation using gradients
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
                    Positioned.fill(
                      child: CustomPaint(painter: ConicBorderPainter()),
                    ),
                    TextField(
                      controller: controller,
                      obscureText: obscureText,
                      keyboardType: keyboardType,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 14,
                        ),
                        contentPadding:
                            contentPadding ??
                            const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                        border: InputBorder.none,
                        prefixIcon: prefixIcon,
                        suffixIcon: suffixIcon,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomDropdownField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final dynamic value;
  final List<DropdownMenuItem<dynamic>> items;
  final void Function(dynamic)? onChanged;

  const CustomDropdownField({
    super.key,
    this.label,
    this.hintText,
    this.value,
    required this.items,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              label!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ],
        Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              const BoxShadow(
                offset: Offset(-2, 4),
                blurRadius: 10,
                color: Color(0x0D919191),
              ),
              const BoxShadow(
                offset: Offset(-7, 17),
                blurRadius: 18,
                color: Color(0x0A919191),
              ),
              const BoxShadow(
                offset: Offset(-15, 37),
                blurRadius: 24,
                color: Color(0x08919191),
              ),
              const BoxShadow(
                offset: Offset(-27, 66),
                blurRadius: 29,
                color: Color(0x03919191),
              ),
              const BoxShadow(
                offset: Offset(-42, 103),
                blurRadius: 31,
                color: Color(0x00919191),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white.withOpacity(0.05),
                ),
                child: Stack(
                  children: [
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
                    Positioned.fill(
                      child: CustomPaint(painter: ConicBorderPainter()),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<dynamic>(
                          value: value,
                          hint: hintText != null
                              ? Text(
                                  hintText!,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 14,
                                  ),
                                )
                              : null,
                          items: items,
                          onChanged: onChanged,
                          dropdownColor: const Color(0xFF1E1E1E),
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white54,
                          ),
                          isExpanded: true,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
