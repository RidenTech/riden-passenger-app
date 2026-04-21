// ignore_for_file: avoid_print

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

/// Global Map Service - Manages ONE shared map controller across entire app
/// All screens use this single map instance instead of creating new ones
class GlobalMapService extends GetxService {
  GoogleMapController? _mapController;
  final Rx<LatLng?> currentLocation = Rx<LatLng?>(null);
  final RxSet<Marker> markers = RxSet<Marker>();
  final RxSet<Polyline> polylines = RxSet<Polyline>();
  final Rx<String> mapStyle = Rx<String>(_getDarkMapStyle());

  /// Get shared map controller
  GoogleMapController? get mapController => _mapController;

  /// Static dark map style for entire app
  static String _getDarkMapStyle() {
    return '''
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
  }

  /// Set map controller (called by home screen)
  void setMapController(GoogleMapController controller) {
    _mapController = controller;
    print('🗺️ Global map controller registered');
  }

  /// Update current location
  void updateLocation(LatLng location) {
    currentLocation.value = location;
    print('📍 Global location updated: $location');
  }

  /// Add marker to shared map
  void addMarker(Marker marker) {
    markers.add(marker);
    print('📌 Marker added: ${marker.markerId}');
  }

  /// Remove marker from shared map
  void removeMarker(MarkerId markerId) {
    markers.removeWhere((m) => m.markerId == markerId);
    print('🗑️ Marker removed: $markerId');
  }

  /// Clear all markers
  void clearMarkers() {
    markers.clear();
    print('🧹 All markers cleared');
  }

  /// Add polyline to shared map
  void addPolyline(Polyline polyline) {
    polylines.add(polyline);
    print('📍 Polyline added: ${polyline.polylineId}');
  }

  /// Remove polyline from shared map
  void removePolyline(PolylineId polylineId) {
    polylines.removeWhere((p) => p.polylineId == polylineId);
    print('🗑️ Polyline removed: $polylineId');
  }

  /// Clear all polylines
  void clearPolylines() {
    polylines.clear();
    print('🧹 All polylines cleared');
  }

  /// Set map style
  void setMapStyle(String style) {
    mapStyle.value = style;
    _mapController?.setMapStyle(style);
    print('🎨 Map style updated');
  }

  /// Animate camera to location
  Future<void> animateToLocation(LatLng location) async {
    if (_mapController == null) {
      print('❌ Map controller not available');
      return;
    }
    await _mapController!.animateCamera(CameraUpdate.newLatLng(location));
    print('📍 Camera animated to: $location');
  }

  /// Animate camera to show both locations with bounds
  Future<void> animateToBounds(LatLng location1, LatLng location2) async {
    if (_mapController == null) {
      print('❌ Map controller not available');
      return;
    }

    // Calculate bounds
    double minLat = location1.latitude < location2.latitude
        ? location1.latitude
        : location2.latitude;
    double maxLat = location1.latitude > location2.latitude
        ? location1.latitude
        : location2.latitude;
    double minLng = location1.longitude < location2.longitude
        ? location1.longitude
        : location2.longitude;
    double maxLng = location1.longitude > location2.longitude
        ? location1.longitude
        : location2.longitude;

    final LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    // Add padding for better view
    final CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 100);

    try {
      await _mapController!.animateCamera(cameraUpdate);
      print('📍 Camera animated to show both locations');
    } catch (e) {
      print('❌ Error animating camera to bounds: $e');
    }
  }

  /// Check if map controller is ready
  bool get isMapReady => _mapController != null;
}
