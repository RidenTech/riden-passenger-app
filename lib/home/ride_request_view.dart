import 'dart:ui';
import 'package:Riden/home/car_selection_view.dart';
import 'package:Riden/home/ridedetail.dart'; // New import
import 'package:Riden/widgets/conic_border_painter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_text_field.dart';

enum RideStep { locationRequest, carSelection, rideDetail }

class RideRequestView extends StatefulWidget {
  final VoidCallback onBack;

  const RideRequestView({super.key, required this.onBack});

  @override
  State<RideRequestView> createState() => _RideRequestViewState();
}

class _RideRequestViewState extends State<RideRequestView> {
  final DraggableScrollableController _sheetController = DraggableScrollableController();
  double _sheetPosition = 0.5;
  RideStep _currentStep = RideStep.locationRequest;
  
  // Data State
  CarOption? _selectedCar;
  String _pickupLocation = "Home - 2972 Westheimer Rd.";
  String _destinationLocation = "Office - 1901 Thorridge Cir.";

  @override
  void initState() {
    super.initState();
    _sheetController.addListener(() {
      setState(() {
        _sheetPosition = _sheetController.size;
      });
    });
  }

  void _handleBack() {
    setState(() {
      if (_currentStep == RideStep.rideDetail) {
        _currentStep = RideStep.carSelection;
        _snapSheet(0.5);
      } else if (_currentStep == RideStep.carSelection) {
        _currentStep = RideStep.locationRequest;
        _snapSheet(0.5);
      } else {
        widget.onBack();
      }
    });
  }

  void _snapSheet(double targetSize) {
    if (_sheetController.isAttached) {
      _sheetController.animateTo(
        targetSize,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Map Section (Full Page Background)
        Positioned.fill(
          child: Container(
            color: Colors.black,
            child: Image.asset(
              "assets/images/map.png",
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.6),
            ),
          ),
        ),

        // Top Overlay: Back and Bell
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _handleBack,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24, width: 1),
                      ),
                      child: const Icon(Icons.notifications_none_outlined, color: Colors.white, size: 22),
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
        ),

        // Bottom Sheet
        DraggableScrollableSheet(
          controller: _sheetController,
          initialChildSize: 0.5,
          minChildSize: 0.45,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFF030408),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: _buildSheetContent(scrollController),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSheetContent(ScrollController scrollController) {
    if (_currentStep == RideStep.rideDetail && _selectedCar != null) {
      return RideDetailView(
        selectedCar: _selectedCar!,
        pickupLocation: _pickupLocation,
        destinationLocation: _destinationLocation,
        onBack: _handleBack,
        scrollController: scrollController,
      );
    }

    return SingleChildScrollView(
      controller: scrollController,
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 12),
          // Indicator
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _currentStep == RideStep.carSelection ? "Choose Your Car" : "Where to ?",
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 25),

          if (_currentStep == RideStep.locationRequest) ..._buildLocationRequestContent(),
          if (_currentStep == RideStep.carSelection) 
            CarSelectionView(
              sheetPosition: _sheetPosition,
              onCarSelected: (carName) {
                // In a real app, map the name back to a CarOption
                // For now, we'll create a default one
                setState(() {
                  _selectedCar = CarOption(
                    name: carName,
                    image: _getCarImage(carName),
                    time: "4 min",
                    price: "C\$ 70.00",
                    description: _getCarDesc(carName),
                  );
                });
              },
            ),

          const SizedBox(height: 20),

          // Action Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConfirmRideButton(
              text: _currentStep == RideStep.carSelection ? "Choose Your Car" : "Confirm",
              onPressed: () {
                setState(() {
                  if (_currentStep == RideStep.locationRequest) {
                    _currentStep = RideStep.carSelection;
                    _snapSheet(0.5);
                  } else if (_currentStep == RideStep.carSelection) {
                    // If no car selected explicitly, use default
                    _selectedCar ??= CarOption(
                      name: "Riden SUV",
                      image: "assets/images/suv_car.png",
                      time: "4 min",
                      price: "C\$ 70.00",
                      description: "SUV with AC",
                    );
                    _currentStep = RideStep.rideDetail;
                    _snapSheet(0.6);
                  }
                });
              },
            ),
          ),
          SizedBox(height: 20 + MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  String _getCarImage(String name) {
    if (name.contains("SUV")) return "assets/images/suv_car.png";
    if (name.contains("Van")) return "assets/images/van_car.png";
    if (name.contains("Standard")) return "assets/images/standard_car.png";
    if (name.contains("Premium")) return "assets/images/premium_car.png";
    if (name.contains("Wheel")) return "assets/images/wheelchair_car.png";
    return "assets/images/car.png";
  }

  String _getCarDesc(String name) {
    if (name.contains("SUV")) return "SUV with AC";
    if (name.contains("Van")) return "Van with AC";
    return "Sedan with AC";
  }

  List<Widget> _buildLocationRequestContent() {
    return [
      // Pickup Options Row
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Expanded(
              child: _buildOptionButton(
                icon: Icons.access_time_filled_rounded,
                label: "Pickup Now",
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildOptionButton(
                icon: Icons.person_rounded,
                label: "For Me",
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 30),

      // Location Cards
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            _buildLocationCard(
              icon: Icons.gps_fixed_rounded,
              title: "Pickup",
              subtitle: "Enter your pickup location",
            ),
            const SizedBox(height: 16),
            _buildLocationCard(
              icon: Icons.location_on_rounded,
              title: "Where to go?",
              subtitle: "Enter your destination location",
            ),
          ],
        ),
      ),

      // Suggestion List (Visible when dragged up)
      if (_sheetPosition > 0.6) ...[
        const SizedBox(height: 30),
        ...List.generate(3, (index) => _buildSuggestionItem(
          "Coffee shop",
          "1901 Thorridge Cir. Shiloh, Hawaii 81063",
        )),
      ],
      const SizedBox(height: 40),
    ];
  }

  Widget _buildOptionButton({required IconData icon, required String label}) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(child: CustomPaint(painter: ConicBorderPainter())),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.white54, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard({required IconData icon, required String title, required String subtitle}) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: ConicBorderPainter())),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.black, size: 15),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, color: Colors.white, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ConfirmRideButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ConfirmRideButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF7296E4), Color(0xFF174AB7)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF174AB7).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: ConicBorderPainter(),
                  ),
                ),
                Center(
                  child: Text(
                    text,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
