import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/services/api_consumer/route_coordinates_api.dart';
import 'package:flutter_app/models/bus_route.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_app/services/location_services/location_service.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapTile extends StatefulWidget {
  final BusRoute? selectedRoute;
  final AnimatedMapController animatedMapController;

  const MapTile({
    super.key,
    this.selectedRoute,
    required this.animatedMapController,
  });

  @override
  State<MapTile> createState() => _MapTileState();
}

class _MapTileState extends State<MapTile> with TickerProviderStateMixin {
  final LocationService locationService = LocationService();
  late LatLng _currentLocation;
  StreamSubscription? _locationSubscription;

  List<List<LatLng>> routePoints = [];

  @override
  void initState() {
    super.initState();

    _currentLocation = LatLng(0, 0);

    _loadRouteData();
    _subscribeToLocationUpdates();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(MapTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedRoute?.routeId != widget.selectedRoute?.routeId) {
      _loadRouteData();
    }
  }

  void _subscribeToLocationUpdates() {
    _locationSubscription?.cancel();

    _locationSubscription = LocationService.stream.listen((location) {
      if (mounted) {
        setState(() {
          _currentLocation = location;
        });
      }
    });
  }

  void _loadRouteData() {
    final routeId = widget.selectedRoute?.routeId ?? 1;

    getRouteSegments(routeId).then((segments) {
      if (mounted) {
        setState(() {
          routePoints = segments
              .map((seg) => seg.map((c) => LatLng(c.lat, c.lng)).toList())
              .toList();
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() => routePoints = []);
      }
    });
  }

  void _centerOnUser() {
    widget.animatedMapController.animateTo(
      dest: _currentLocation,
      zoom: 16,
      curve: Curves.easeInOut,

      // duration: const Duration(milliseconds: 600),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: widget.animatedMapController.mapController,
          options: MapOptions(
            initialCenter: LatLng(27.1751, 78.0421),
            initialZoom: 5,
            minZoom: 2,
            maxZoom: 20,
            initialRotation: 0,
            interactionOptions: InteractionOptions(
              flags: InteractiveFlag.drag |
                  InteractiveFlag.pinchZoom |
                  InteractiveFlag.doubleTapZoom |
                  InteractiveFlag.scrollWheelZoom,
            ),
            cameraConstraint: CameraConstraint.contain(
              bounds: LatLngBounds(
                LatLng(-85, -180),
                LatLng(85, 180),
              ),
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: dotenv.env['MAP_TILE_URL']!,
              userAgentPackageName: 'com.example.flutter_app',
              panBuffer: 2,
            ),
            PolylineLayer(
              polylines: [
                for (final route in routePoints)
                  Polyline(
                    points: route,
                    strokeWidth: 1.5,
                    color: Colors.blue.shade500,
                  ),
              ],
            ),
            MarkerLayer(markers: [
              Marker(
                point: _currentLocation,
                width: 40,
                height: 40,
                child: Icon(
                  Icons.location_on,
                  color: Colors.green.shade900,
                  size: 40,
                ),
              ),
            ]),
          ],
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue.shade700,
            onPressed: _centerOnUser,
            child: const Icon(Icons.my_location),
          ),
        ),
      ],
    );
  }
}
