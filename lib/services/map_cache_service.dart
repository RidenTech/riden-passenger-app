// ignore_for_file: avoid_print

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';

/// Singleton service to cache map data and prevent redundant API calls
/// This ensures location is fetched only once and shared across all screens
class MapCacheService extends GetxService {
  // Cached location data
  static final MapCacheService _instance = MapCacheService._internal();

  LatLng? _cachedLocation;
  Set<Marker> _cachedMarkers = {};
  String? _cachedMapStyle;
  bool _isLocationInitialized = false;
  bool _isLocationInitializing = false;

  // Location tracking stream
  StreamSubscription<Position>? _positionStream;

  factory MapCacheService() {
    return _instance;
  }

  MapCacheService._internal();

  // ─────────────────────────────────────────────────────────────────
  // GETTERS
  // ─────────────────────────────────────────────────────────────────

  LatLng? get cachedLocation => _cachedLocation;
  Set<Marker> get cachedMarkers => _cachedMarkers;
  String? get cachedMapStyle => _cachedMapStyle;
  bool get isLocationInitialized => _isLocationInitialized;

  // ─────────────────────────────────────────────────────────────────
  // INITIALIZATION - Call this ONCE when app starts
  // ─────────────────────────────────────────────────────────────────

  /// Initialize map cache (call once in main.dart or app startup)
  Future<void> initializeMapCache() async {
    if (_isLocationInitialized || _isLocationInitializing) {
      print('✓ Map cache already initialized or initializing');
      return;
    }

    _isLocationInitializing = true;
    print('🗺️ Initializing map cache service...');

    try {
      await _initializeLocation();
      await _loadMapStyle();
      _startLocationTracking();
      _isLocationInitialized = true;
      print('✅ Map cache initialized successfully');
    } catch (e) {
      print('❌ Error initializing map cache: $e');
      _isLocationInitialized = false;
    }

    _isLocationInitializing = false;
  }

  // ─────────────────────────────────────────────────────────────────
  // PRIVATE METHODS
  // ─────────────────────────────────────────────────────────────────

  /// Get current location (fetched once and cached)
  Future<void> _initializeLocation() async {
    try {
      print('📍 Fetching current location...');

      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      _cachedLocation = LatLng(position.latitude, position.longitude);
      print('✅ Location cached: $_cachedLocation');

      // Add user marker
      await _addUserMarker();
    } catch (e) {
      print('❌ Error initializing location: $e');
    }
  }

  /// Create marker with custom icon
  Future<BitmapDescriptor> _createPointerMarker() async {
    try {
      return await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(64, 64)),
        'assets/images/pointer.png',
      );
    } catch (e) {
      print('❌ Error loading pointer icon: $e');
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    }
  }

  /// Add user marker at current location
  Future<void> _addUserMarker() async {
    if (_cachedLocation == null) return;

    try {
      final markerIcon = await _createPointerMarker();
      _cachedMarkers.clear();
      _cachedMarkers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: _cachedLocation!,
          icon: markerIcon,
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
      );
      print('✅ User marker added');
    } catch (e) {
      print('❌ Error adding user marker: $e');
    }
  }

  /// Load and cache map style
  Future<void> _loadMapStyle() async {
    try {
      print('🎨 Loading map style...');

      // Use comprehensive dark theme (matching account and all screens)
      _cachedMapStyle = '''
        [
          {
            "elementType": "geometry",
            "stylers": [{ "color": "#151d26" }]
          },
          {
            "elementType": "labels.text.fill",
            "stylers": [{ "color": "#8fa3af" }]
          },
          {
            "elementType": "labels.text.stroke",
            "stylers": [{ "color": "#050f17" }]
          },
          {
            "featureType": "administrative",
            "elementType": "geometry",
            "stylers": [{ "color": "#1f2d3a" }]
          },
          {
            "featureType": "administrative",
            "elementType": "labels.text.fill",
            "stylers": [{ "color": "#7fa3c7" }]
          },
          {
            "featureType": "administrative.country",
            "elementType": "labels.text.fill",
            "stylers": [{ "color": "#9fb3d4" }]
          },
          {
            "featureType": "administrative.land_parcel",
            "elementType": "labels.text.fill",
            "stylers": [{ "color": "#5a7a97" }]
          },
          {
            "featureType": "administrative.locality",
            "elementType": "labels.text.fill",
            "stylers": [{ "color": "#7fa3c7" }]
          },
          {
            "featureType": "administrative.province",
            "elementType": "labels.text.fill",
            "stylers": [{ "color": "#7fa3c7" }]
          },
          {
            "featureType": "landscape",
            "elementType": "geometry",
            "stylers": [{ "color": "#151d26" }]
          },
          {
            "featureType": "landscape.man_made",
            "elementType": "geometry",
            "stylers": [{ "color": "#1d2935" }]
          },
          {
            "featureType": "landscape.natural",
            "elementType": "geometry",
            "stylers": [{ "color": "#141e27" }]
          },
          {
            "featureType": "poi",
            "elementType": "geometry",
            "stylers": [{ "color": "#1d2a38" }]
          },
          {
            "featureType": "poi",
            "elementType": "labels.icon",
            "stylers": [{ "visibility": "on" }]
          },
          {
            "featureType": "poi",
            "elementType": "labels.text.fill",
            "stylers": [{ "color": "#6a8cb8" }]
          },
          {
            "featureType": "poi.attraction",
            "elementType": "geometry",
            "stylers": [{ "color": "#1d2a38" }]
          },
          {
            "featureType": "poi.business",
            "elementType": "geometry",
            "stylers": [{ "color": "#1d2a38" }]
          },
          {
            "featureType": "poi.business",
            "elementType": "labels.text.fill",
            "stylers": [{ "color": "#6a8cb8" }]
          },
          {
            "featureType": "poi.government",
            "elementType": "geometry",
            "stylers": [{ "color": "#1d2a38" }]
          },
          {
            "featureType": "poi.medical",
            "elementType": "geometry",
            "stylers": [{ "color": "#1d2a38" }]
          },
          {
            "featureType": "poi.park",
            "elementType": "geometry",
            "stylers": [{ "color": "#1a2932" }]
          },
          {
            "featureType": "poi.park",
            "elementType": "labels.text.fill",
            "stylers": [{ "color": "#5a8b99" }]
          },
          {
            "featureType": "poi.place_of_worship",
            "elementType": "geometry",
            "stylers": [{ "color": "#1d2a38" }]
          },
          {
            "featureType": "poi.school",
            "elementType": "geometry",
            "stylers": [{ "color": "#1d2a38" }]
          },
          {
            "featureType": "poi.sports_complex",
            "elementType": "geometry",
            "stylers": [{ "color": "#1d2a38" }]
          },
          {
            "featureType": "road",
            "elementType": "geometry.fill",
            "stylers": [{ "color": "#2d3f52" }]
          },
          {
            "featureType": "road",
            "elementType": "labels.text.fill",
            "stylers": [{ "color": "#7a8fa7" }]
          },
          {
            "featureType": "road",
            "elementType": "labels.text.stroke",
            "stylers": [{ "color": "#151d26" }]
          },
          {
            "featureType": "road.arterial",
            "elementType": "geometry",
            "stylers": [{ "color": "#354766" }]
          },
          {
            "featureType": "road.highway",
            "elementType": "geometry",
            "stylers": [{ "color": "#3d5376" }]
          },
          {
            "featureType": "road.highway",
            "elementType": "geometry.stroke",
            "stylers": [{ "color": "#1f3050" }]
          },
          {
            "featureType": "road.highway.controlled_access",
            "elementType": "geometry",
            "stylers": [{ "color": "#3d5376" }]
          },
          {
            "featureType": "road.local",
            "elementType": "geometry",
            "stylers": [{ "color": "#2d3f52" }]
          },
          {
            "featureType": "road.local",
            "elementType": "labels.text.fill",
            "stylers": [{ "color": "#6a7d92" }]
          },
          {
            "featureType": "transit",
            "elementType": "geometry",
            "stylers": [{ "color": "#2d3f52" }]
          },
          {
            "featureType": "transit",
            "elementType": "labels.text.fill",
            "stylers": [{ "color": "#7a8fa7" }]
          },
          {
            "featureType": "transit",
            "elementType": "labels.text.stroke",
            "stylers": [{ "color": "#151d26" }]
          },
          {
            "featureType": "transit.line",
            "elementType": "geometry",
            "stylers": [{ "color": "#2d3f52" }]
          },
          {
            "featureType": "transit.station",
            "elementType": "geometry",
            "stylers": [{ "color": "#2d3f52" }]
          },
          {
            "featureType": "transit.station.airport",
            "elementType": "geometry",
            "stylers": [{ "color": "#2d3f52" }]
          },
          {
            "featureType": "transit.station.bus",
            "elementType": "geometry",
            "stylers": [{ "color": "#2d3f52" }]
          },
          {
            "featureType": "transit.station.rail",
            "elementType": "geometry",
            "stylers": [{ "color": "#2d3f52" }]
          },
          {
            "featureType": "water",
            "elementType": "geometry",
            "stylers": [{ "color": "#0f1a24" }]
          },
          {
            "featureType": "water",
            "elementType": "labels.text.fill",
            "stylers": [{ "color": "#5a7d99" }]
          },
          {
            "featureType": "water",
            "elementType": "labels.text.stroke",
            "stylers": [{ "color": "#0f1a24" }]
          }
        ]
      ''';
      print('✅ Map style cached');
    } catch (e) {
      print('❌ Error loading map style: $e');
    }
  }

  /// Start listening to location updates (only once)
  void _startLocationTracking() {
    if (_positionStream != null) {
      print('✓ Location tracking already active');
      return;
    }

    try {
      print('📍 Starting location tracking...');

      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10, // Update when moved 10 meters
      );

      _positionStream =
          Geolocator.getPositionStream(
            locationSettings: locationSettings,
          ).listen((Position position) {
            _cachedLocation = LatLng(position.latitude, position.longitude);
            print('📍 Location updated: $_cachedLocation');
          });
    } catch (e) {
      print('❌ Error starting location tracking: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // PUBLIC METHODS
  // ─────────────────────────────────────────────────────────────────

  /// Get location (returns cached value)
  Future<LatLng?> getLocation() async {
    if (_cachedLocation != null) {
      return _cachedLocation;
    }

    // If not initialized, initialize now
    if (!_isLocationInitialized) {
      await initializeMapCache();
    }

    return _cachedLocation;
  }

  /// Add a custom marker (doesn't clear existing markers)
  void addMarker(Marker marker) {
    _cachedMarkers.add(marker);
    print('✅ Marker added: ${marker.markerId}');
  }

  /// Remove a marker
  void removeMarker(MarkerId markerId) {
    _cachedMarkers.removeWhere((m) => m.markerId == markerId);
    print('✅ Marker removed: $markerId');
  }

  /// Clear all markers
  void clearMarkers() {
    _cachedMarkers.clear();
    print('✅ All markers cleared');
  }

  // ─────────────────────────────────────────────────────────────────
  // CLEANUP
  // ─────────────────────────────────────────────────────────────────

  /// Call this when app is disposing (optional, not usually needed)
  void dispose() {
    _positionStream?.cancel();
    print('🗺️ Map cache service disposed');
  }
}

/// Convenience method to get map cache service
MapCacheService getMapCache() => Get.find<MapCacheService>();
