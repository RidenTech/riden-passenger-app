import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:Riden/services/map_cache_service.dart';
import 'dart:async';

class RidenMapView extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;
  final double? mapHeight;

  const RidenMapView({
    super.key,
    this.initialLat,
    this.initialLng,
    this.mapHeight,
  });

  @override
  State<RidenMapView> createState() => _RidenMapViewState();
}

class _RidenMapViewState extends State<RidenMapView> {
  late GoogleMapController _mapController;
  LatLng? _currentLocation;
  final Set<Marker> _markers = {};
  bool _isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    _initializeFromCache();
  }

  /// Load data from cache service (avoids redundant API calls)
  Future<void> _initializeFromCache() async {
    try {
      final mapCache = MapCacheService();

      // If already initialized, use cached location
      if (mapCache.isLocationInitialized) {
        print('✅ Using cached location data');
        _currentLocation = mapCache.cachedLocation;
        _markers.addAll(mapCache.cachedMarkers);
      } else {
        // If not initialized, initialize the cache now
        print('🗺️ Initializing map cache for first time');
        await mapCache.initializeMapCache();
        _currentLocation = mapCache.cachedLocation;
        _markers.addAll(mapCache.cachedMarkers);
      }

      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });

        // Animate camera after small delay to ensure map is ready
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted && _currentLocation != null) {
          _mapController.animateCamera(
            CameraUpdate.newLatLng(_currentLocation!),
          );
        }
      }
    } catch (e) {
      print('❌ Error initializing from cache: $e');
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  Future<void> _loadMapStyle() async {
    try {
      final mapCache = MapCacheService();

      // Try to load from asset file first
      try {
        final String style = await DefaultAssetBundle.of(
          context,
        ).loadString('assets/map_style_dark.json');
        if (mounted) {
          await _mapController.setMapStyle(style);
          print('✅ Map style loaded from asset');
        }
      } catch (e) {
        // Fallback to cached style or inline style
        if (mapCache.cachedMapStyle != null && mounted) {
          await _mapController.setMapStyle(mapCache.cachedMapStyle);
          print('✅ Map style loaded from cache');
        } else {
          // Use default inline style
          await _mapController.setMapStyle('''
            [
              { "elementType": "geometry", "stylers": [{ "color": "#151d26" }] },
              { "elementType": "labels.text.fill", "stylers": [{ "color": "#8fa3af" }] },
              { "featureType": "water", "elementType": "geometry", "stylers": [{ "color": "#0f1a24" }] }
            ]
          ''');
          print('✅ Map style loaded from default');
        }
      }
    } catch (e) {
      print('⚠️ Error loading map style: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingLocation) {
      return Container(
        height: widget.mapHeight,
        color: Colors.black,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: SizedBox(
        height: widget.mapHeight,
        child: GoogleMap(
          onMapCreated: (controller) async {
            _mapController = controller;
            print('✅ Map controller initialized (RidenMapView)');
            await Future.delayed(const Duration(milliseconds: 300));
            await _loadMapStyle();
            if (_currentLocation != null && mounted) {
              _mapController.animateCamera(
                CameraUpdate.newLatLng(_currentLocation!),
              );
            }
          },
          initialCameraPosition: CameraPosition(
            target:
                _currentLocation ??
                LatLng(
                  widget.initialLat ?? 37.7749,
                  widget.initialLng ?? -122.4194,
                ),
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
    );
  }

  @override
  void dispose() {
    // Don't cancel location tracking here - it's managed by MapCacheService
    super.dispose();
  }
}
