import 'dart:ui';
import 'package:flutter/material.dart';
import 'conic_border_painter.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isDark;
  final Widget? icon;
  final bool hasBorder;
  final bool isBlue; // New parameter for glassy blue button
  final Future<bool> Function()? validateFields; // Validation callback

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isDark = true,
    this.icon,
    this.hasBorder = true,
    this.isBlue = false,
    this.validateFields,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  Future<void> _handlePress() async {
    // If validateFields callback is provided, validate first
    if (widget.validateFields != null) {
      final isValid = await widget.validateFields!();
      if (!isValid) {
        // Fields are invalid, don't proceed
        return;
      }
    }

    // Call the onPressed callback
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    // If isBlue, use glassy style; otherwise use original style
    if (widget.isBlue) {
      return _buildGlassyButton();
    } else {
      return _buildOriginalButton();
    }
  }

  /// Build glassy button style (for SignIn/SignUp) - matches CustomTextField styling
  Widget _buildGlassyButton() {
    return GestureDetector(
      onTapDown: (_) {
        print('🔵 [CustomButton] onTapDown triggered - _isPressed = true');
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        print('🔵 [CustomButton] onTapUp triggered - _isPressed = false');
        setState(() {
          _isPressed = false;
        });
      },
      onTapCancel: () {
        print('🔵 [CustomButton] onTapCancel triggered - _isPressed = false');
        setState(() {
          _isPressed = false;
        });
      },
      onTap: _handlePress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              offset: const Offset(-2, 4),
              blurRadius: 10,
              color: _isPressed
                  ? const Color(0xFF6395FF).withOpacity(0.3)
                  : const Color(0x0D919191),
            ),
            BoxShadow(
              offset: const Offset(-7, 17),
              blurRadius: 18,
              color: _isPressed
                  ? const Color(0xFF6395FF).withOpacity(0.2)
                  : const Color(0x0A919191),
            ),
            BoxShadow(
              offset: const Offset(-15, 37),
              blurRadius: 24,
              color: _isPressed
                  ? const Color(0xFF6395FF).withOpacity(0.15)
                  : const Color(0x08919191),
            ),
            BoxShadow(
              offset: const Offset(-27, 66),
              blurRadius: 29,
              color: _isPressed
                  ? const Color(0xFF6395FF).withOpacity(0.1)
                  : const Color(0x03919191),
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
                color: _isPressed
                    ? const Color(0xFF6395FF) // Solid blue when pressed
                    : Colors.white.withOpacity(
                        0.08,
                      ), // Slightly more opaque glassy when not pressed
                border: _isPressed
                    ? Border.all(color: const Color(0xFF6395FF), width: 2)
                    : Border.all(
                        color: Colors.white.withOpacity(0.15),
                        width: 1,
                      ),
              ),
              child: Stack(
                children: [
                  // Inset shadows simulation using gradients
                  if (!_isPressed)
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
                  if (!_isPressed)
                    Positioned.fill(
                      child: CustomPaint(painter: ConicBorderPainter()),
                    ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.icon != null) ...[
                          widget.icon!,
                          const SizedBox(width: 12),
                        ],
                        Flexible(
                          child: Text(
                            widget.text,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _isPressed ? Colors.white : Colors.white,
                              letterSpacing: _isPressed ? 0.5 : 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build original button style (for other buttons)
  Widget _buildOriginalButton() {
    return Container(
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
              color: widget.isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white,
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
                if (widget.hasBorder)
                  Positioned.fill(
                    child: CustomPaint(painter: ConicBorderPainter()),
                  ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTapDown: (_) {
                      setState(() {
                        _isPressed = true;
                      });
                    },
                    onTapUp: (_) {
                      setState(() {
                        _isPressed = false;
                      });
                    },
                    onTapCancel: () {
                      setState(() {
                        _isPressed = false;
                      });
                    },
                    onTap: _handlePress,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.icon != null) ...[
                            widget.icon!,
                            const SizedBox(width: 12),
                          ],
                          Flexible(
                            child: Text(
                              widget.text,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: widget.isDark
                                    ? Colors.white
                                    : const Color(0xFF141414),
                              ),
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
