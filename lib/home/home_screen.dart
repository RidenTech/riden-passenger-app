// ignore_for_file: deprecated_member_use, avoid_print

import 'package:Riden/Booking/ride_request_view.dart';
import 'package:Riden/widgets/background_image.dart';
import 'package:Riden/widgets/riden_bottom_nav.dart';
import 'package:Riden/account/account_screen.dart';
import 'package:Riden/support/support.dart';
import 'package:Riden/controllers/auth_controller.dart';
import 'package:Riden/controllers/navigation_controller.dart';
import 'package:Riden/services/location_search_service.dart';
import 'package:Riden/services/map_cache_service.dart';
import 'package:Riden/services/global_map_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showRideSelection = false;
  final TextEditingController _searchController = TextEditingController();
  late AuthController _authController;
  late NavigationController _navigationController;

  late GoogleMapController _mapController;
  LatLng? _currentLocation;
  final Set<Marker> _markers = {};
  bool _isLoadingLocation = true;

  // Google Places API Variables
  List<LocationSuggestion> _filteredLocations = [];
  Timer? _searchDebounceTimer;
  String? _sessionToken;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Initialize AuthController
    try {
      _authController = Get.find<AuthController>();
    } catch (e) {
      _authController = Get.put(AuthController());
    }
    // Initialize NavigationController
    _navigationController = Get.find<NavigationController>();

    // Ensure AuthController is fully initialized before loading data
    _initializeAndLoadData();

    _initializeLocation();
    _searchController.addListener(_onSearchChanged);
  }

  /// Wait for AuthController initialization and load user data
  Future<void> _initializeAndLoadData() async {
    print('\n🏠 HomeScreen: Starting initialization...');

    // Ensure AuthController is fully initialized
    await _authController.ensureInitialized();

    // Force reload the data from SharedPreferences
    await _authController.forceReloadUserData();

    if (mounted) {
      setState(() {});
      print(
        '✅ HomeScreen - User data loaded: ${_authController.userFullName.value} (${_authController.userEmail.value})',
      );
    }
  }

  /// Initialize location from cache service (prevents redundant API calls)
  Future<void> _initializeLocation() async {
    try {
      final mapCache = MapCacheService();
      final globalMapService = Get.find<GlobalMapService>();

      // Initialize cache if not already done
      if (!mapCache.isLocationInitialized) {
        print('🗺️ Initializing map cache for home screen');
        await mapCache.initializeMapCache();
      }

      _currentLocation = mapCache.cachedLocation;
      _markers.addAll(mapCache.cachedMarkers);

      // Update Global Map Service
      if (_currentLocation != null) {
        globalMapService.updateLocation(_currentLocation!);
      }
      for (var marker in _markers) {
        globalMapService.addMarker(marker);
      }

      // Set dark map style for all screens
      if (mapCache.cachedMapStyle != null) {
        globalMapService.setMapStyle(mapCache.cachedMapStyle!);
      }

      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });

        // Animate camera after a small delay to ensure map is ready
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted && _currentLocation != null) {
          _mapController.animateCamera(
            CameraUpdate.newLatLng(_currentLocation!),
          );
        }
      }
    } catch (e) {
      print('❌ Error initializing location: $e');
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  Future<BitmapDescriptor> createPointerMarker() async {
    try {
      return await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(64, 64)),
        'assets/images/pointer.png',
      );
    } catch (e) {
      print('❌ Error loading custom pointer: $e');
      // Fallback to default marker
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    }
  }

  Future<void> addUserMarker() async {
    if (_currentLocation == null) return;

    final markerIcon = await createPointerMarker();

    _markers.clear();
    _markers.add(
      Marker(
        markerId: const MarkerId('user_location'),
        position: _currentLocation!,
        icon: markerIcon,
        infoWindow: const InfoWindow(title: 'Your Location'),
      ),
    );
  }

  Future<void> loadMapStyle() async {
    try {
      final globalMapService = Get.find<GlobalMapService>();
      // Use the dark map style from GlobalMapService (same for all screens)
      final String style = globalMapService.mapStyle.value;
      if (mounted) {
        await _mapController.setMapStyle(style);
        print('✅ Dark theme applied to home screen map from GlobalMapService');
      }
    } catch (e) {
      print('❌ Error loading map style: $e');
      // Fallback: Try loading from JSON file
      try {
        final String style = await DefaultAssetBundle.of(
          context,
        ).loadString('assets/map_style_dark.json');
        if (mounted) {
          await _mapController.setMapStyle(style);
          print('✅ Dark theme applied from JSON file');
        }
      } catch (fileError) {
        print('❌ Error loading JSON file: $fileError');
      }
    }
  }

  // Calculate distance between two coordinates (in km)
  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const double R = 6371; // Earth radius in km
    final double dLat = ((lat2 - lat1) * pi) / 180;
    final double dLng = ((lng2 - lng1) * pi) / 180;
    final double a =
        (sin(dLat / 2) * sin(dLat / 2)) +
        (cos((lat1 * pi) / 180) *
            cos((lat2 * pi) / 180) *
            sin(dLng / 2) *
            sin(dLng / 2));
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  // Handle search input with debouncing
  void _onSearchChanged() {
    _searchDebounceTimer?.cancel();

    final query = _searchController.text.trim();

    if (query.isEmpty) {
      setState(() {
        _filteredLocations = [];
      });
      return;
    }

    // Debounce: wait 500ms before making API call
    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      _searchLocations(query);
    });
  }

  /// Search locations using Google Places API
  Future<void> _searchLocations(String query) async {
    if (!mounted) return;

    setState(() {
      _isSearching = true;
    });

    try {
      // Generate session token if not exists (reduces costs)
      _sessionToken ??= LocationSearchService.generateSessionToken();

      // Search for locations using Google Places API
      final suggestions = await LocationSearchService.searchPlaces(
        query: query,
        sessionToken: _sessionToken,
        latitude: _currentLocation?.latitude,
        longitude: _currentLocation?.longitude,
        radiusMeters: 50000, // 50km radius
      );

      if (mounted) {
        setState(() {
          _filteredLocations = suggestions;
          _isSearching = false;
        });

        print('✅ API Search Complete: Found ${suggestions.length} suggestions');
      }
    } catch (e) {
      print('❌ Error searching locations: $e');
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    }
  }

  /// Select a location from suggestions and fetch detailed information
  Future<void> selectLocation(LocationSuggestion suggestion) async {
    print('📍 Location Selected: ${suggestion.mainText}');

    setState(() {
      _isSearching = true;
    });

    try {
      // Fetch detailed information about the selected place
      final placeDetails = await LocationSearchService.getPlaceDetails(
        placeId: suggestion.placeId,
        sessionToken: _sessionToken,
      );

      if (placeDetails != null && mounted) {
        // Extract coordinates
        final coords = LocationSearchService.extractCoordinates(placeDetails);
        final address = LocationSearchService.extractFormattedAddress(
          placeDetails,
        );

        if (coords != null) {
          print(
            '📍 Got coordinates: ${coords['latitude']}, ${coords['longitude']}',
          );

          // Close suggestions and clear search bar
          setState(() {
            _filteredLocations = [];
            _searchController.clear();
          });

          // Add marker for selected location with custom pointer
          await addSelectedLocationMarker(
            suggestion.mainText,
            address ?? suggestion.secondaryText,
            coords['latitude']!,
            coords['longitude']!,
          );
        }
      }
    } catch (e) {
      print('❌ Error selecting location: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    }
  }

  Future<void> addSelectedLocationMarker(
    String name,
    String address,
    double lat,
    double lng,
  ) async {
    final selectedLatLng = LatLng(lat, lng);
    final globalMapService = Get.find<GlobalMapService>();

    try {
      // Load custom pointer marker
      final markerIcon = await createPointerMarker();

      // Add marker for selected location with custom pointer
      final marker = Marker(
        markerId: MarkerId('selected_location_$name'),
        position: selectedLatLng,
        infoWindow: InfoWindow(title: name, snippet: address),
        icon: markerIcon,
      );

      _markers.add(marker);
      globalMapService.addMarker(marker);

      // Animate camera to selected location
      if (mounted) {
        _mapController.animateCamera(
          CameraUpdate.newLatLngZoom(selectedLatLng, 16.0),
        );
      }

      setState(() {});
    } catch (e) {
      print('❌ Error adding selected location marker: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebounceTimer?.cancel();
    // Don't dispose _positionStream - it's managed by MapCacheService
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundImage(
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.5),
        body: Stack(
          children: [
            // Main Home Content (Wrapped in SafeArea)
            if (!_showRideSelection)
              SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
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
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Good Evening",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    const Text(
                                      "👋",
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                                Obx(() {
                                  String firstName =
                                      _authController.userFirstName.value;
                                  String lastName =
                                      _authController.userLastName.value;
                                  String displayName =
                                      '$firstName $lastName'.trim().isNotEmpty
                                      ? '$firstName $lastName'.trim()
                                      : "User";

                                  print(
                                    '🟢 Display Name: "$displayName" | FirstName: "$firstName" | LastName: "$lastName"',
                                  );

                                  return Text(
                                    displayName,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }),
                              ],
                            ),
                            Stack(
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Search Bar with Suggestions
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F1115),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.12),
                                  width: 1.2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.30),
                                    blurRadius: 15,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      controller: _searchController,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "Where are you going?",
                                        hintStyle: GoogleFonts.poppins(
                                          color: Colors.white54,
                                          fontSize: 14,
                                        ),
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _showRideSelection = true;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.black,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Suggestions Dropdown - Fixed Height with Scrolling
                            if (_filteredLocations.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(top: 8),
                                constraints: const BoxConstraints(
                                  maxHeight: 240,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E1E1E),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.12),
                                    width: 1,
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: _filteredLocations.length,
                                    itemBuilder: (context, index) {
                                      final suggestion =
                                          _filteredLocations[index];

                                      return GestureDetector(
                                        onTap: () => selectLocation(suggestion),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            border:
                                                index <
                                                    _filteredLocations.length -
                                                        1
                                                ? Border(
                                                    bottom: BorderSide(
                                                      color: Colors.white
                                                          .withOpacity(0.1),
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.location_on_rounded,
                                                color: Colors.blue[400],
                                                size: 16,
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      suggestion.mainText,
                                                      style:
                                                          GoogleFonts.poppins(
                                                            color: Colors.white,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                                    Text(
                                                      suggestion.secondaryText,
                                                      style:
                                                          GoogleFonts.poppins(
                                                            color:
                                                                Colors.white60,
                                                            fontSize: 11,
                                                          ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (_isSearching &&
                                                  index ==
                                                      _filteredLocations
                                                              .length -
                                                          1)
                                                const SizedBox(
                                                  width: 16,
                                                  height: 16,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                          Color
                                                        >(Colors.blue),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            // Show loading indicator when searching
                            if (_isSearching && _filteredLocations.isEmpty)
                              Container(
                                margin: const EdgeInsets.only(top: 8),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E1E1E),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.12),
                                    width: 1,
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.blue,
                                            ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Searching locations...',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Recent Destinations Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Recent destinations",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "See all >",
                              style: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Destination Cards (Local Scroll)
                      SizedBox(
                        height:
                            220, // Increased height to show at least 3 cards
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          physics: const BouncingScrollPhysics(),
                          children: [
                            buildDestinationCard(
                              icon: Icons.work_outline,
                              title: "Office",
                              subtitle: "2972 Westheimer Rd.",
                              time: "12 min",
                              price: "14.20",
                              dotColor: Colors.blue,
                            ),
                            const SizedBox(height: 8),
                            buildDestinationCard(
                              icon: Icons.coffee_outlined,
                              title: "Coffee shop",
                              subtitle: "1901 Thorridge Cir.",
                              time: "8 min",
                              price: "10.50",
                              dotColor: Colors.orange,
                            ),
                            const SizedBox(height: 8),
                            buildDestinationCard(
                              icon: Icons.home_outlined,
                              title: "Home",
                              subtitle: "Home",
                              time: "15 min",
                              price: "9.80",
                              dotColor: Colors.green,
                            ),
                          ],
                        ),
                      ),

                      // Map Section with Fixed Height
                      SizedBox(
                        height: 300,
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          margin: const EdgeInsets.only(bottom: 0),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Stack(
                              children: [
                                // Google Map
                                _isLoadingLocation
                                    ? Container(
                                        color: Colors.grey.withOpacity(0.3),
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : _currentLocation == null
                                    ? Container(
                                        color: Colors.grey.withOpacity(0.3),
                                        child: const Center(
                                          child: Text(
                                            'Unable to get location',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                    : GoogleMap(
                                        onMapCreated: (controller) async {
                                          _mapController = controller;
                                          print('✅ Map controller initialized');

                                          // Update Global Map Service
                                          final globalMapService =
                                              Get.find<GlobalMapService>();
                                          globalMapService.setMapController(
                                            controller,
                                          );
                                          globalMapService.updateLocation(
                                            _currentLocation ??
                                                const LatLng(
                                                  37.7749,
                                                  -122.4194,
                                                ),
                                          );

                                          // Apply style after a brief delay to ensure map is ready
                                          await Future.delayed(
                                            const Duration(milliseconds: 500),
                                          );
                                          await loadMapStyle();
                                          if (_currentLocation != null &&
                                              mounted) {
                                            _mapController.animateCamera(
                                              CameraUpdate.newLatLng(
                                                _currentLocation!,
                                              ),
                                            );
                                          }
                                        },
                                        initialCameraPosition: CameraPosition(
                                          target:
                                              _currentLocation ??
                                              const LatLng(37.7749, -122.4194),
                                          zoom: 15,
                                        ),
                                        markers: _markers,
                                        myLocationEnabled: false,
                                        myLocationButtonEnabled: false,
                                        compassEnabled: true,
                                        mapToolbarEnabled: false,
                                        zoomControlsEnabled: false,
                                      ),

                                // Location Icon - Repositioned for Nav Overlap
                                Positioned(
                                  bottom: 100,
                                  right: 20,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (_currentLocation != null) {
                                        _mapController.animateCamera(
                                          CameraUpdate.newLatLng(
                                            _currentLocation!,
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.white10,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.my_location_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
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

            // Floating Custom Bottom Navigation Bar
            if (!_showRideSelection)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: Obx(
                    () => RidenBottomNav(
                      selectedIndex:
                          _navigationController.selectedNavIndex.value,
                      onItemSelected: (index) {
                        if (index == 1) {
                          // Navigate to Support
                          _navigationController.setSelectedIndex(1);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const Support()),
                          );
                        } else if (index == 3) {
                          // Navigate to Account
                          _navigationController.setSelectedIndex(3);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AccountScreen(),
                            ),
                          );
                        } else {
                          _navigationController.setSelectedIndex(index);
                        }
                      },
                    ),
                  ),
                ),
              ),

            // Ride Selection View Overlay (Full-screen, non-SafeArea mapped)
            if (_showRideSelection)
              Positioned.fill(
                child: RideRequestView(
                  onBack: () {
                    setState(() {
                      _showRideSelection = false;
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildDestinationCard({
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
        color: const Color(0xFF111318),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Stack(
        children: [
          // Top-left accent glow
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
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
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
                        fontSize: 11,
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
                  size: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
