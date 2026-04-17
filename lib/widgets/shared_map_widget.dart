import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:Riden/services/global_map_service.dart';

/// Shared Map Widget - Used by all screens to display the same map
/// Properly handles polyline updates
class SharedMapWidget extends StatefulWidget {
  final double height;
  final double width;

  const SharedMapWidget({
    Key? key,
    this.height = double.infinity,
    this.width = double.infinity,
  }) : super(key: key);

  @override
  State<SharedMapWidget> createState() => _SharedMapWidgetState();
}

class _SharedMapWidgetState extends State<SharedMapWidget> {
  late GlobalMapService globalMapService;

  @override
  void initState() {
    super.initState();
    globalMapService = Get.find<GlobalMapService>();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Obx(() {
        // Watch for location, markers, and polylines changes
        final location = globalMapService.currentLocation.value;
        final markers = globalMapService.markers.toList();
        final polylines = globalMapService.polylines.toList();

        if (location == null) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF80F0F)),
            ),
          );
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: GoogleMap(
            initialCameraPosition: CameraPosition(target: location, zoom: 15),
            markers: Set<Marker>.from(markers),
            polylines: Set<Polyline>.from(
              polylines,
            ), // Polylines passed directly
            onMapCreated: (GoogleMapController controller) {
              // Update global service with map controller
              globalMapService.setMapController(controller);
              print('✅ GoogleMap created with ${polylines.length} polylines');
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            style: globalMapService.mapStyle.value,
          ),
        );
      }),
    );
  }
}
