import 'dart:ui';
import 'package:Riden/Booking/car_selection_view.dart';
import 'package:Riden/Booking/ridedetail.dart'; // New import
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
  late TextEditingController _pickupController;
  late TextEditingController _destinationController;
  final FocusNode _pickupFocusNode = FocusNode();
  final FocusNode _destinationFocusNode = FocusNode();
  String _pickupLocation = "Home - 2972 Westheimer Rd.";
  String _destinationLocation = "Office - 1901 Thorridge Cir.";

  @override
  void initState() {
    super.initState();
    _pickupController = TextEditingController(text: _pickupLocation);
    _destinationController = TextEditingController(text: _destinationLocation);
    
    // Trigger rebuild on typing to show dynamic suggestions
    _pickupController.addListener(() => setState(() {}));
    _destinationController.addListener(() => setState(() {}));

    // Auto-expand sheet on focus (Limited to 70%)
    _pickupFocusNode.addListener(() {
      if (_pickupFocusNode.hasFocus) _snapSheet(0.7);
    });
    _destinationFocusNode.addListener(() {
      if (_destinationFocusNode.hasFocus) _snapSheet(0.7);
    });

    _sheetController.addListener(() {
      setState(() {
        _sheetPosition = _sheetController.size;
      });
    });
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    _pickupFocusNode.dispose();
    _destinationFocusNode.dispose();
    super.dispose();
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
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: Stack(
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

          // Bottom Sheet
          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: 0.5,
            minChildSize: 0.45,
            maxChildSize: 0.7,
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
      ),
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

    return Stack(
      children: [
        Positioned.fill(
          child: SingleChildScrollView(
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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

          // Action Button Space
          SizedBox(height: 100 + MediaQuery.of(context).padding.bottom),
        ],
      ),
    ),
  ),
  Positioned(
    left: 0,
    right: 0,
    bottom: 0,
    child: Container(
      color: const Color(0xFF030408),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 10,
        bottom: 20 + MediaQuery.of(context).padding.bottom,
      ),
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
  ),
],
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
              hintText: "Enter your pickup location",
              controller: _pickupController,
              focusNode: _pickupFocusNode,
            ),
            const SizedBox(height: 16),
            _buildLocationCard(
              icon: Icons.location_on_rounded,
              title: "Where to go?",
              hintText: "Enter your destination location",
              controller: _destinationController,
              focusNode: _destinationFocusNode,
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),

      // Dynamic Suggestions (Only show when typing)
      if (_pickupController.text.isNotEmpty || _destinationController.text.isNotEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSuggestionCard(
                icon: Icons.work_outline,
                title: "Office",
                subtitle: "2972 Westheimer Rd. Westheimer ...",
                time: "12 min",
                price: "14.20",
                dotColor: Colors.blue,
              ),
              const SizedBox(height: 12),
              _buildSuggestionCard(
                icon: Icons.coffee_outlined,
                title: "Coffee shop",
                subtitle: "1901 Thorridge Cir. Shiloh, Hawai ...",
                time: "8 min",
                price: "10.50",
                dotColor: Colors.orange,
              ),
            ],
          ),
        ),

      const SizedBox(height: 40),
    ];
  }

  Widget _buildOptionButton({required IconData icon, required String label}) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.white54, size: 18),
              ],
            ),
          ),
    );
  }

  Widget _buildLocationCard({
    required IconData icon, 
    required String title, 
    required String hintText,
    required TextEditingController controller,
    required FocusNode focusNode,
  }) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
      ),
      child: Padding(
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
                        style: GoogleFonts.poppins(
                          color: Colors.white, 
                          fontSize: 10, 
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextField(
                        controller: controller,
                        focusNode: focusNode,
                        onChanged: (value) {
                          setState(() {
                            if (title == "Pickup") {
                              _pickupLocation = value;
                            } else {
                              _destinationLocation = value;
                            }
                          });
                        },
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.8), 
                          fontSize: 12,
                        ),
                        decoration: InputDecoration(
                          hintText: hintText,
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.white30, 
                            fontSize: 12,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildSuggestionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required String price,
    required Color dotColor,
  }) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF111318).withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            left: -15,
            child: Container(
              width: 30,  
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E5197).withOpacity(0.6),
                    blurRadius: 35,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      time,
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      "\$$price",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 15),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 12,
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
