import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'car_selection_view.dart';
import 'ride_confirmation_view.dart';

class RideDetailView extends StatefulWidget {
  final CarOption selectedCar;
  final String pickupLocation;
  final String destinationLocation;
  final VoidCallback onBack;
  final ScrollController scrollController;

  const RideDetailView({
    super.key,
    required this.selectedCar,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.onBack,
    required this.scrollController,
  });

  @override
  State<RideDetailView> createState() => _RideDetailViewState();
}

class _RideDetailViewState extends State<RideDetailView> {
  String _selectedPaymentMethod = "Visa **** 1234";
  final List<String> _paymentMethods = [
    "Visa **** 1234",
    "Mastercard **** 5678",
    "Apple Pay",
    "Cash",
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: SingleChildScrollView(
            controller: widget.scrollController,
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
            "Request Ride",
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 25),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                // Location Cards
                _buildSectionHeader("Ride Details"),
                const SizedBox(height: 12),
                _buildLocationDetailCard(
                  icon: Icons.gps_fixed_rounded,
                  title: "Pickup Location",
                  address: widget.pickupLocation,
                  iconColor: Colors.black,
                ),
                const SizedBox(height: 12),
                _buildLocationDetailCard(
                  icon: Icons.location_on_rounded,
                  title: "Destination Location",
                  address: widget.destinationLocation,
                  iconColor: Colors.black,
                ),
                const SizedBox(height: 24),

                // Car Detailed Card
                _buildSectionHeader("Car Details"),
                const SizedBox(height: 12),
                _buildCarDetailCard(),
                const SizedBox(height: 24),

                // Payment Card
                _buildSectionHeader("Payment Method"),
                const SizedBox(height: 12),
                _buildPaymentCard(),
                const SizedBox(height: 24),

                // Discount Card
                _buildSectionHeader("Discount & Promo"),
                const SizedBox(height: 12),
                _buildDiscountCard(),
                const SizedBox(height: 40),

                // Final Button Area
                SizedBox(height: 100 + MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
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
            child: _buildRequestRideButton(),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildLocationDetailCard({
    required IconData icon,
    required String title,
    required String address,
    required Color iconColor,
  }) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(icon, color: iconColor, size: 16),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.black54,
                    fontSize: 10,
                  ),
                ),
                Text(
                  address,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarDetailCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Image.asset(
            widget.selectedCar.image,
            width: 80,
            height: 50,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.car_repair, color: Colors.white, size: 40),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.selectedCar.name,
                  style: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.9),
                    fontSize: 16,
                    
                  ),
                ),
                Text(
                  widget.selectedCar.description,
                  style: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            widget.selectedCar.price,
            style: GoogleFonts.poppins(
              color: Colors.black.withOpacity(0.9),
              fontSize: 18,
              fontWeight: FontWeight.w600  ,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard() {
    return Container(
      height: 45,   
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.payment_rounded, color: Colors.black, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedPaymentMethod,
                dropdownColor: Colors.white,  
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                style: GoogleFonts.poppins(color: Colors.black , fontSize: 14),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPaymentMethod = newValue!;
                  });
                },
                items: _paymentMethods.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountCard() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.confirmation_number_outlined, color: Colors.black, size: 18),
          const SizedBox(width: 16),
          Text(
            "Add promo code",
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 14),
        ],
      ),
    );
  }

  Widget _buildRequestRideButton() {
    return Container(
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        gradient: const LinearGradient(
          colors: [Color(0xFF7296E4), Color(0xFF174AB7)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RideConfirmationView(),
                ),
              );
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Request Ride",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
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
