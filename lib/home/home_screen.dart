// ignore_for_file: deprecated_member_use, avoid_print
import 'package:Riden/widgets/background_image.dart';
import 'package:Riden/widgets/riden_bottom_nav.dart';
import 'package:Riden/account/account_screen.dart';
import 'package:Riden/Booking/ride_request_view.dart';
import 'package:Riden/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0;
  bool _showRideSelection = false;
  final TextEditingController _searchController = TextEditingController();
  late AuthController _authController;

  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  StreamSubscription<Position>? _positionStream;
  final Set<Marker> _markers = {};
  bool _isLoadingLocation = true;

  // Location suggestions with coordinates (lat, lng)
  final List<Map<String, dynamic>> _allLocations = [
    {
      'name': 'McDonald\'s',
      'address': '123 Main St, Downtown',
      'category': 'restaurant',
      'lat': 37.7849,
      'lng': -122.4094,
    },
    {
      'name': 'Burger King',
      'address': '456 Commercial Ave, Downtown',
      'category': 'restaurant',
      'lat': 37.7949,
      'lng': -122.3994,
    },
    {
      'name': 'Pizza Hut',
      'address': '789 Food St, Downtown',
      'category': 'restaurant',
      'lat': 37.7849,
      'lng': -122.4094,
    },
    {
      'name': 'KFC',
      'address': '100 Main St, Midtown',
      'category': 'restaurant',
      'lat': 37.7749,
      'lng': -122.3894,
    },
    {
      'name': 'Starbucks Coffee',
      'address': '200 Market St, Central',
      'category': 'café',
      'lat': 37.7649,
      'lng': -122.4194,
    },
    {
      'name': 'Costa Coffee',
      'address': '300 Park Lane, Uptown',
      'category': 'café',
      'lat': 37.7549,
      'lng': -122.4494,
    },
    {
      'name': 'Dunkin Donuts',
      'address': '150 Broadway, Downtown',
      'category': 'café',
      'lat': 37.7849,
      'lng': -122.4294,
    },
    {
      'name': 'Walmart Supermarket',
      'address': '500 Commerce Blvd, Industrial',
      'category': 'shopping',
      'lat': 37.7249,
      'lng': -122.3894,
    },
    {
      'name': 'Target Store',
      'address': '501 Retail Dr, Mall Area',
      'category': 'shopping',
      'lat': 37.7649,
      'lng': -122.3794,
    },
    {
      'name': 'Best Buy Electronics',
      'address': '502 Tech Way, Downtown',
      'category': 'electronics',
      'lat': 37.7749,
      'lng': -122.3994,
    },
    {
      'name': 'Nike Store',
      'address': '503 Fashion St, Downtown',
      'category': 'shopping',
      'lat': 37.7949,
      'lng': -122.4094,
    },
    {
      'name': 'Gold\'s Gym',
      'address': '400 Athletic Rd, Sports District',
      'category': 'fitness',
      'lat': 37.7649,
      'lng': -122.4194,
    },
    {
      'name': 'Planet Fitness',
      'address': '401 Health Blvd, Fitness Zone',
      'category': 'fitness',
      'lat': 37.7549,
      'lng': -122.3994,
    },
    {
      'name': 'Central Hospital',
      'address': '150 Medical Park, Healthcare Zone',
      'category': 'hospital',
      'lat': 37.7649,
      'lng': -122.4394,
    },
    {
      'name': 'City General Hospital',
      'address': '151 Health Ave, Medical District',
      'category': 'hospital',
      'lat': 37.7949,
      'lng': -122.4094,
    },
    {
      'name': 'Cinema Palace',
      'address': '420 Entertainment Ave, Arts District',
      'category': 'entertainment',
      'lat': 37.7849,
      'lng': -122.4294,
    },
    {
      'name': 'Movie Theater',
      'address': '421 Film Lane, Downtown',
      'category': 'entertainment',
      'lat': 37.7749,
      'lng': -122.3994,
    },
    {
      'name': 'Central Park',
      'address': '789 Park Road, Nature',
      'category': 'park',
      'lat': 37.7749,
      'lng': -122.4194,
    },
    {
      'name': 'Beach Waterfront',
      'address': '300 Coastal Rd, Beach Area',
      'category': 'park',
      'lat': 37.7549,
      'lng': -122.4494,
    },
    {
      'name': 'Train Station',
      'address': '200 Station Rd, Transport Hub',
      'category': 'transport',
      'lat': 37.7949,
      'lng': -122.3894,
    },
  ];
  List<Map<String, dynamic>> _filteredLocations = [];

  @override
  void initState() {
    super.initState();
    // Initialize AuthController
    try {
      _authController = Get.find<AuthController>();
    } catch (e) {
      _authController = Get.put(AuthController());
    }
    print(
      '✅ AuthController initialized: ${_authController.userFullName.value}',
    );

    _initializeLocation();
    _startLocationTracking();
    _searchController.addListener(_filterLocations);
  }

  Future<void> _initializeLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _isLoadingLocation = false;
        _addUserMarker();
      });

      if (mounted && _mapController != null) {
        _mapController!.animateCamera(CameraUpdate.newLatLng(_currentLocation!));
      }
    } catch (e) {
      print('Error getting location: $e');
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  void _startLocationTracking() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 10, // Update when moved 10 meters
    );

    _positionStream =
        Geolocator.getPositionStream(
          locationSettings: locationSettings,
        ).listen((Position position) {
          if (mounted) {
            setState(() {
              _currentLocation = LatLng(position.latitude, position.longitude);
              _addUserMarker();
            });

            if (_mapController != null) {
              _mapController!.animateCamera(
                CameraUpdate.newLatLng(_currentLocation!),
              );
            }
          }
        });
  }

  Future<BitmapDescriptor> _createPointerMarker() async {
    // Avoid app crash from invalid/non-bitmap marker assets on some devices.
    return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
  }

  Future<void> _addUserMarker() async {
    if (_currentLocation == null) return;

    final markerIcon = await _createPointerMarker();

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

  Future<void> _loadMapStyle() async {
    try {
      final String style = await DefaultAssetBundle.of(
        context,
      ).loadString('assets/map_style_dark.json');
      if (_mapController != null) {
        await _mapController!.setMapStyle(style);
      }
    } catch (e) {
      print('Error loading map style: $e');
    }
  }

  // Calculate distance between two coordinates (in km)
  double _calculateDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
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

  void _filterLocations() {
    final query = _searchController.text.toLowerCase().trim();

    setState(() {
      if (query.isEmpty) {
        _filteredLocations = [];
      } else {
        List<Map<String, dynamic>> results = [];

        // Smart Google Maps-like search
        // 1. Exact name matches (highest priority)
        var exactMatches = _allLocations
            .where((location) => location['name']!.toLowerCase() == query)
            .toList();
        results.addAll(exactMatches);

        // 2. Name starts with query
        var nameStarts = _allLocations
            .where(
              (location) =>
                  location['name']!.toLowerCase().startsWith(query) &&
                  !exactMatches.contains(location),
            )
            .toList();
        results.addAll(nameStarts);

        // 3. Name contains query
        var nameContains = _allLocations
            .where(
              (location) =>
                  location['name']!.toLowerCase().contains(query) &&
                  !exactMatches.contains(location) &&
                  !nameStarts.contains(location),
            )
            .toList();
        results.addAll(nameContains);

        // 4. Address contains query
        var addressMatches = _allLocations
            .where(
              (location) =>
                  location['address']!.toLowerCase().contains(query) &&
                  !results.contains(location),
            )
            .toList();
        results.addAll(addressMatches);

        // Sort all results by proximity to current location
        if (_currentLocation != null) {
          results.sort((a, b) {
            double distA = _calculateDistance(
              _currentLocation!.latitude,
              _currentLocation!.longitude,
              a['lat'] as double,
              a['lng'] as double,
            );
            double distB = _calculateDistance(
              _currentLocation!.latitude,
              _currentLocation!.longitude,
              b['lat'] as double,
              b['lng'] as double,
            );
            return distA.compareTo(distB);
          });
          print(
            '📍 Sorted by proximity - Top result is ${(results.isNotEmpty ? results.first['name'] : 'None')}',
          );
        }

        // Limit total results to 10 suggestions
        _filteredLocations = results.length > 10
            ? results.sublist(0, 10)
            : results;

        print(
          '🔍 Search Query: "$query" - Found ${_filteredLocations.length} results near user',
        );
      }
    });
  }

  void _selectLocation(String locationName, String locationAddress) {
    print('📍 Location Selected: $locationName - $locationAddress');
    _searchController.text = locationName;

    // Find the location to get coordinates
    var selectedLocation = _allLocations.firstWhere(
      (loc) => loc['name'] == locationName,
      orElse: () => {},
    );

    if (selectedLocation.isNotEmpty) {
      _addSelectedLocationMarker(
        locationName,
        locationAddress,
        selectedLocation['lat'] as double,
        selectedLocation['lng'] as double,
      );
    }

    setState(() {
      _filteredLocations = [];
    });
  }

  void _addSelectedLocationMarker(
    String name,
    String address,
    double lat,
    double lng,
  ) {
    final selectedLatLng = LatLng(lat, lng);

    // Add marker for selected location
    _markers.add(
      Marker(
        markerId: MarkerId('selected_location_$name'),
        position: selectedLatLng,
        infoWindow: InfoWindow(title: name, snippet: address),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );

    // Animate camera to selected location
    if (mounted) {
      if (_mapController != null) {
        _mapController!.animateCamera(CameraUpdate.newLatLng(selectedLatLng));
      }
    }

    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    _positionStream?.cancel();
    _mapController?.dispose();
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
                bottom: false,
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
                                  String displayName =
                                      _authController
                                          .userFullName
                                          .value
                                          .isNotEmpty
                                      ? _authController.userFullName.value
                                      : "User";

                                  print(
                                    '🟢 Display Name: "$displayName" | Full: "${_authController.userFullName.value}" | FirstName: "${_authController.userFirstName.value}" | LastName: "${_authController.userLastName.value}"',
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
                                      final location =
                                          _filteredLocations[index];

                                      return GestureDetector(
                                        onTap: () => _selectLocation(
                                          location['name']!,
                                          location['address']!,
                                        ),
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
                                                      location['name']!,
                                                      style:
                                                          GoogleFonts.poppins(
                                                            color: Colors.white,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                                    Text(
                                                      location['address']!,
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
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
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
                            _buildDestinationCard(
                              icon: Icons.work_outline,
                              title: "Office",
                              subtitle: "2972 Westheimer Rd.",
                              time: "12 min",
                              price: "14.20",
                              dotColor: Colors.blue,
                            ),
                            const SizedBox(height: 8),
                            _buildDestinationCard(
                              icon: Icons.coffee_outlined,
                              title: "Coffee shop",
                              subtitle: "1901 Thorridge Cir.",
                              time: "8 min",
                              price: "10.50",
                              dotColor: Colors.orange,
                            ),
                            const SizedBox(height: 8),
                            _buildDestinationCard(
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

                      // Map section starts under cards and extends behind nav.
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.46,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: _isLoadingLocation
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
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    )
                                  : GoogleMap(
                                      onMapCreated: (controller) async {
                                        _mapController = controller;
                                        await _loadMapStyle();
                                        _mapController!.animateCamera(
                                          CameraUpdate.newLatLng(
                                            _currentLocation!,
                                          ),
                                        );
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
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              top: 0,
                              child: IgnorePointer(
                                child: Container(
                                  height: 150,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xFF060B16),
                                        Color(0xB3060B16),
                                        Color(0x00060B16),
                                      ],
                                      stops: [0.0, 0.45, 1.0],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 115,
                              right: 20,
                              child: GestureDetector(
                                onTap: () {
                                  if (_currentLocation != null) {
                                    _mapController?.animateCamera(
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
                                    border: Border.all(color: Colors.white10),
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
                  child: RidenBottomNav(
                    selectedIndex: _selectedNavIndex,
                    onItemSelected: (index) {
                      if (index == 3) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AccountScreen(),
                          ),
                        );
                      } else {
                        setState(() {
                          _selectedNavIndex = index;
                        });
                      }
                    },
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

  Widget _buildDestinationCard({
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