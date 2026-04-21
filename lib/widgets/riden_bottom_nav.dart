import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RidenBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const RidenBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFF0B0C10),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color(0xFF12C5ED).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(child: _buildNavItem("Booking", Icons.receipt_long,  0)),
          Expanded(child: _buildNavItem("Support", Icons.headset_mic_outlined, 1)),
          Expanded(child: _buildNavItem("Activity", Icons.monitor_heart, 2)),
          Expanded(child: _buildNavItem("Account", Icons.person_outline_rounded, 3)),
        ],
      ),
    );
  }

  Widget _buildNavItem(String label, IconData icon, int index) {
    final bool isActive = selectedIndex == index;
    return GestureDetector(
      onTap: () => onItemSelected(index),
      child: Container(
        height: 60, 
        // Removed hardcoded width to allow flexible layout
        color: Colors.transparent, // Expand tap area
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,  
          children: [
            if (isActive)
              Positioned(
                bottom: 0,
                child: Container(
                  width: 50,
                  height: 30,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0, 1.0),
                      radius: 0.8,
                      colors: [
                        const Color(0xFF1E5197).withOpacity(0.8),
                        const Color(0xFF1E5197).withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isActive ? Colors.white : Colors.white54,
                  size: 20,
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: isActive ? Colors.white : Colors.white54,
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 3),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isActive ? 18 : 0,
                  height: 2.5,
                  decoration: BoxDecoration(
                    color: const Color(0xFF12C5ED),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: const Color(0xFF12C5ED).withOpacity(0.6),
                              blurRadius: 12,
                              spreadRadius: 6,
                            )
                          ]
                        : [],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
