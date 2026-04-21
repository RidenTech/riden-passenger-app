// ignore_for_file: avoid_print

import 'package:Riden/Booking/car_selection_view.dart';
import 'package:Riden/Booking/ridedetail.dart';
import 'package:Riden/widgets/shared_map_widget.dart';
import 'package:Riden/services/location_search_service.dart';
import 'package:Riden/services/map_cache_service.dart';
import 'package:Riden/services/global_map_service.dart';
import 'package:Riden/home/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'dart:async';

enum RideStep { locationRequest, carSelection, rideDetail }

class RideRequestView extends StatefulWidget {
  final VoidCallback onBack;

  const RideRequestView({super.key, required this.onBack});

  @override
  State<RideRequestView> createState() => _RideRequestViewState();
}

class _RideRequestViewState extends State<RideRequestView> {
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
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
  double? _pickupLat;
  double? _pickupLng;
  double? _destinationLat;
  double? _destinationLng;

  // Location Search Variables
  List<LocationSuggestion> _pickupSuggestions = [];
  List<LocationSuggestion> _destinationSuggestions = [];
  Timer? _pickupSearchDebounceTimer;
  Timer? _destinationSearchDebounceTimer;
  String? _sessionToken;
  bool _isPickupSearching = false;
  bool _isDestinationSearching = false;
  bool _pickupSearchPerformed = false;
  bool _destinationSearchPerformed = false;

  @override
  void initState() {
    super.initState();
    _pickupController = TextEditingController(text: _pickupLocation);
    _destinationController = TextEditingController(text: _destinationLocation);

    // Trigger rebuild on typing to show dynamic suggestions
    _pickupController.addListener(_onPickupChanged);
    _destinationController.addListener(_onDestinationChanged);

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
    _pickupSearchDebounceTimer?.cancel();
    _destinationSearchDebounceTimer?.cancel();

    // Clear route polyline and all markers when disposing
    try {
      final globalMapService = Get.find<GlobalMapService>();
      globalMapService.clearMarkers();
      globalMapService.removePolyline(const PolylineId('route'));
    } catch (e) {
      print('Note: Global map service not available during dispose');
    }

    super.dispose();
  }

  void _handleBack() {
    setState(() {
      if (_currentStep == RideStep.rideDetail) {
        _currentStep = RideStep.carSelection;
        _snapSheet(0.6);
      } else if (_currentStep == RideStep.carSelection) {
        _currentStep = RideStep.locationRequest;
        _selectedCar = null;
        _snapSheet(0.5);
      } else {
        // Clear route polyline and all markers when going back
        try {
          final globalMapService = Get.find<GlobalMapService>();
          globalMapService.clearMarkers();
          globalMapService.removePolyline(const PolylineId('route'));
        } catch (e) {
          print('Note: Global map service not available');
        }
        widget.onBack();
      }
    });
  }

  void _onPickupChanged() {
    _pickupSearchDebounceTimer?.cancel();
    final query = _pickupController.text.trim();

    if (query.isEmpty) {
      setState(() {
        _pickupSuggestions = [];
        _pickupSearchPerformed = false;
      });
      return;
    }

    _pickupSearchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      _searchPickupLocations(query);
    });
  }

  void _onDestinationChanged() {
    _destinationSearchDebounceTimer?.cancel();
    final query = _destinationController.text.trim();

    if (query.isEmpty) {
      setState(() {
        _destinationSuggestions = [];
        _destinationSearchPerformed = false;
      });
      return;
    }

    _destinationSearchDebounceTimer = Timer(
      const Duration(milliseconds: 500),
      () {
        _searchDestinationLocations(query);
      },
    );
  }

  Future<void> _searchPickupLocations(String query) async {
    if (!mounted) return;

    setState(() {
      _isPickupSearching = true;
      _pickupSearchPerformed = true;
    });

    try {
      _sessionToken ??= LocationSearchService.generateSessionToken();

      final suggestions = await LocationSearchService.searchPlaces(
        query: query,
        sessionToken: _sessionToken,
        radiusMeters: 50000,
      );

      if (mounted) {
        setState(() {
          _pickupSuggestions = suggestions;
          _isPickupSearching = false;
        });
      }
    } catch (e) {
      print('❌ Error searching pickup locations: $e');
      if (mounted) {
        setState(() {
          _isPickupSearching = false;
        });
      }
    }
  }

  Future<void> _searchDestinationLocations(String query) async {
    if (!mounted) return;

    setState(() {
      _isDestinationSearching = true;
      _destinationSearchPerformed = true;
    });

    try {
      _sessionToken ??= LocationSearchService.generateSessionToken();

      final suggestions = await LocationSearchService.searchPlaces(
        query: query,
        sessionToken: _sessionToken,
        radiusMeters: 50000,
      );

      if (mounted) {
        setState(() {
          _destinationSuggestions = suggestions;
          _isDestinationSearching = false;
        });
      }
    } catch (e) {
      print('❌ Error searching destination locations: $e');
      if (mounted) {
        setState(() {
          _isDestinationSearching = false;
        });
      }
    }
  }

  Future<void> _selectPickupLocation(LocationSuggestion suggestion) async {
    try {
      FocusScope.of(context).unfocus();
      final placeDetails = await LocationSearchService.getPlaceDetails(
        placeId: suggestion.placeId,
        sessionToken: _sessionToken,
      );

      if (placeDetails != null && mounted) {
        final coords = LocationSearchService.extractCoordinates(placeDetails);
        if (coords != null) {
          // Remove listener to prevent cascading search
          _pickupController.removeListener(_onPickupChanged);

          setState(() {
            _pickupController.text = suggestion.mainText;
            _pickupLocation = suggestion.mainText;
            _pickupSuggestions = [];
            _pickupSearchPerformed = false;
            _pickupLat = coords['latitude'];
            _pickupLng = coords['longitude'];
          });

          // Re-add listener
          _pickupController.addListener(_onPickupChanged);

          // 🎯 Zoom to pickup location
          final pickupLatLng = LatLng(_pickupLat!, _pickupLng!);
          try {
            final globalMapService = Get.find<GlobalMapService>();
            await globalMapService.animateToLocation(pickupLatLng);
            print('✅ Camera zoomed to pickup location: $_pickupLocation');
          } catch (e) {
            print('⚠️ Map service not ready yet: $e');
          }

          // Update route if destination is also set
          await _updateRoutePolyline();
        }
      }
    } catch (e) {
      print('❌ Error selecting pickup location: $e');
    }
  }

  Future<void> _selectDestinationLocation(LocationSuggestion suggestion) async {
    try {
      FocusScope.of(context).unfocus();
      final placeDetails = await LocationSearchService.getPlaceDetails(
        placeId: suggestion.placeId,
        sessionToken: _sessionToken,
      );

      if (placeDetails != null && mounted) {
        final coords = LocationSearchService.extractCoordinates(placeDetails);
        if (coords != null) {
          // Remove listener to prevent cascading search
          _destinationController.removeListener(_onDestinationChanged);

          setState(() {
            _destinationController.text = suggestion.mainText;
            _destinationLocation = suggestion.mainText;
            _destinationSuggestions = [];
            _destinationSearchPerformed = false;
            _destinationLat = coords['latitude'];
            _destinationLng = coords['longitude'];
          });

          // Re-add listener
          _destinationController.addListener(_onDestinationChanged);

          // 🎯 Zoom to destination location or show bounds if pickup is set
          try {
            final globalMapService = Get.find<GlobalMapService>();
            final destinationLatLng = LatLng(
              _destinationLat!,
              _destinationLng!,
            );

            // If pickup is also set, show bounds with both locations
            if (_pickupLat != null && _pickupLng != null) {
              final pickupLatLng = LatLng(_pickupLat!, _pickupLng!);
              await globalMapService.animateToBounds(
                pickupLatLng,
                destinationLatLng,
              );
              print('✅ Camera zoomed to show both pickup and destination');
            } else {
              // Only destination is set
              await globalMapService.animateToLocation(destinationLatLng);
              print(
                '✅ Camera zoomed to destination location: $_destinationLocation',
              );
            }
          } catch (e) {
            print('⚠️ Map service not ready yet: $e');
          }

          // Update route if pickup is also set
          await _updateRoutePolyline();
        }
      }
    } catch (e) {
      print('❌ Error selecting destination location: $e');
    }
  }

  /// Draw route polyline between pickup and destination
  Future<void> _updateRoutePolyline() async {
    if (_pickupLat == null ||
        _pickupLng == null ||
        _destinationLat == null ||
        _destinationLng == null) {
      return; // Both locations must be set
    }

    try {
      final globalMapService = Get.find<GlobalMapService>();

      // Clear all existing markers and polylines to start fresh
      globalMapService.clearMarkers();
      globalMapService.removePolyline(const PolylineId('route'));

      // Create blue route polyline
      final routePolyline = Polyline(
        polylineId: const PolylineId('route'),
        points: [
          LatLng(_pickupLat!, _pickupLng!),
          LatLng(_destinationLat!, _destinationLng!),
        ],
        color: const Color(0xFF6395FF), // Blue color
        width: 5,
        geodesic: true,
      );

      // Create markers for pickup and destination with custom images
      final pickupMarker = Marker(
        markerId: const MarkerId('pickup_location'),
        position: LatLng(_pickupLat!, _pickupLng!),
        infoWindow: InfoWindow(title: 'Pickup: $_pickupLocation'),
        icon: await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(48, 48)),
          'assets/images/pointer.png',
        ),
      );

      final destinationMarker = Marker(
        markerId: const MarkerId('destination_location'),
        position: LatLng(_destinationLat!, _destinationLng!),
        infoWindow: InfoWindow(title: 'Destination: $_destinationLocation'),
        icon: await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(48, 48)),
          'assets/images/destination.png',
        ),
      );

      // Add polyline and markers to global map service
      globalMapService.addPolyline(routePolyline);
      globalMapService.addMarker(pickupMarker);
      globalMapService.addMarker(destinationMarker);

      // 🎯 Animate camera to show both locations
      globalMapService.animateToBounds(
        LatLng(_pickupLat!, _pickupLng!),
        LatLng(_destinationLat!, _destinationLng!),
      );

      print('✅ Route polyline created between pickup and destination');
      print('📍 Markers added: Pickup and Destination only');
      print('📍 Pickup: ($_pickupLocation) - $_pickupLat, $_pickupLng');
      print(
        '📍 Destination: ($_destinationLocation) - $_destinationLat, $_destinationLng',
      );
    } catch (e) {
      print('❌ Error creating route polyline: $e');
    }
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
          // Map Section (Full Page Background - Shared Global Map)
          Positioned.fill(
            child: SharedMapWidget(height: MediaQuery.of(context).size.height),
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
                                onTap: _handleBack,
                                child: Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const NotificationScreen()),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.25),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white24,
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.notifications_none_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
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
    // Show ride detail view
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
                  _currentStep == RideStep.carSelection
                      ? "Choose Your Car"
                      : "Where to ?",
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

                if (_currentStep == RideStep.locationRequest)
                  ..._buildLocationRequestContent(),

                if (_currentStep == RideStep.carSelection)
                  CarSelectionView(
                    sheetPosition: _sheetPosition,
                    onCarSelected: (selectedCar) {
                      setState(() {
                        _selectedCar = selectedCar;
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
              text: _currentStep == RideStep.carSelection
                  ? (_selectedCar != null ? "Continue" : "Select a Car")
                  : "Request Ride",
              onPressed: () {
                setState(() {
                  if (_currentStep == RideStep.locationRequest) {
                    _currentStep = RideStep.carSelection;
                    _snapSheet(0.6);
                  } else if (_currentStep == RideStep.carSelection &&
                      _selectedCar != null) {
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

      // PICKUP SECTION
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: _buildLocationCard(
          icon: Icons.gps_fixed_rounded,
          title: "Pickup",
          hintText: "Enter your pickup location",
          controller: _pickupController,
          focusNode: _pickupFocusNode,
        ),
      ),

      // Pickup Suggestions (Directly below pickup field)
      if (_pickupController.text.isNotEmpty) const SizedBox(height: 12),
      if (_pickupController.text.isNotEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isPickupSearching)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue.withOpacity(0.7),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Searching...',
                        style: GoogleFonts.poppins(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              else if (_pickupSuggestions.isNotEmpty) ...[
                Text(
                  'Pickup Suggestions',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                ..._pickupSuggestions.map((suggestion) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () => _selectPickupLocation(suggestion),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.blue,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    suggestion.mainText,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (suggestion.secondaryText.isNotEmpty)
                                    Text(
                                      suggestion.secondaryText,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white60,
                                        fontSize: 11,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ] else if (_pickupController.text.isNotEmpty &&
                  !_isPickupSearching &&
                  _pickupSearchPerformed)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'No pickup locations found',
                    style: GoogleFonts.poppins(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),

      const SizedBox(height: 24),

      // DESTINATION SECTION
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: _buildLocationCard(
          icon: Icons.location_on_rounded,
          title: "Where to go?",
          hintText: "Enter your destination location",
          controller: _destinationController,
          focusNode: _destinationFocusNode,
        ),
      ),

      // Destination Suggestions (Directly below destination field)
      if (_destinationController.text.isNotEmpty) const SizedBox(height: 12),
      if (_destinationController.text.isNotEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isDestinationSearching)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.orange.withOpacity(0.7),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Searching...',
                        style: GoogleFonts.poppins(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              else if (_destinationSuggestions.isNotEmpty) ...[
                Text(
                  'Destination Suggestions',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                ..._destinationSuggestions.map((suggestion) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () => _selectDestinationLocation(suggestion),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.orange,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    suggestion.mainText,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (suggestion.secondaryText.isNotEmpty)
                                    Text(
                                      suggestion.secondaryText,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white60,
                                        fontSize: 11,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ] else if (_destinationController.text.isNotEmpty &&
                  !_isDestinationSearching &&
                  _destinationSearchPerformed)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'No destination locations found',
                    style: GoogleFonts.poppins(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                  ),
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
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white54,
              size: 18,
            ),
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
                          _onPickupChanged();
                        } else {
                          _destinationLocation = value;
                          _onDestinationChanged();
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
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
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

  const ConfirmRideButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

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
