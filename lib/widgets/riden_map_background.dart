import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:Riden/services/map_cache_service.dart';

/// Lightweight map widget that reuses cached location data
/// Use this for decorative/background maps to avoid redundant loading
///
/// Features:
/// - No redundant location fetches (uses MapCacheService)
/// - No location tracking stream
/// - Instant rendering from cached data
/// - Perfect for backgrounds in Account, Payment, etc.
class RidenMapBackground extends StatefulWidget {
  final double? mapHeight;
  final LatLng? initialPosition;

  const RidenMapBackground({super.key, this.mapHeight, this.initialPosition});

  @override
  State<RidenMapBackground> createState() => _RidenMapBackgroundState();
}

class _RidenMapBackgroundState extends State<RidenMapBackground> {
  late GoogleMapController _mapController;
  LatLng? _displayLocation;

  @override
  void initState() {
    super.initState();
    _initializeFromCache();
  }

  /// Load data from cache instead of fetching fresh
  Future<void> _initializeFromCache() async {
    try {
      // Get map cache service
      final mapCache = MapCacheService();

      // Use initial position if provided, else use cached location
      _displayLocation = widget.initialPosition ?? mapCache.cachedLocation;

      if (_displayLocation != null && mounted) {
        setState(() {});

        // Animate camera to location
        await Future.delayed(const Duration(milliseconds: 300));
        if (mounted) {
          _mapController.animateCamera(
            CameraUpdate.newLatLng(_displayLocation!),
          );
        }
        print('✅ Map background initialized from cache');
      }
    } catch (e) {
      print('❌ Error initializing map background: $e');
    }
  }

  /// Apply cached map style
  Future<void> _loadMapStyle() async {
    try {
      final mapCache = MapCacheService();
      if (mapCache.cachedMapStyle != null && mounted) {
        await _mapController.setMapStyle(mapCache.cachedMapStyle);
        print('✅ Map style applied from cache');
      }
    } catch (e) {
      print('❌ Error loading map style: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.mapHeight,
      child: _displayLocation == null
          ? Container(
              color: Colors.grey.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            )
          : GoogleMap(
              onMapCreated: (controller) async {
                _mapController = controller;
                print('🗺️ Map controller created (background)');

                // Apply cached style
                await Future.delayed(const Duration(milliseconds: 300));
                await _loadMapStyle();
              },
              initialCameraPosition: CameraPosition(
                target: _displayLocation ?? const LatLng(37.7749, -122.4194),
                zoom: 15,
              ),
              markers: MapCacheService().cachedMarkers,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              compassEnabled: false,
              mapToolbarEnabled: false,
              zoomControlsEnabled: false,
            ),
    );
  }
}
