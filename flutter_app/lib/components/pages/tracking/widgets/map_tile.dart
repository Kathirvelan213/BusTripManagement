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

  const MapTile({super.key, this.selectedRoute});

  @override
  State<MapTile> createState() => _MapTileState();
}

class _MapTileState extends State<MapTile> {
  final LocationService locationService = LocationService();
  late LatLng _currentLocation;
  StreamSubscription? _locationSubscription;

  final MapController _mapController = MapController();

  List<List<LatLng>> routePoints = [];

  @override
  void initState() {
    super.initState();

    _currentLocation = LatLng(0, 0);

    _loadRouteData();

    _locationSubscription = locationService.stream.listen((locationData) {
      if (mounted) {
        setState(() {
          _currentLocation =
              LatLng(locationData.latitude, locationData.longitude);
        });
      }
    });
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

  void _loadRouteData() {
    final routeId = widget.selectedRoute?.routeId ?? 1; // fallback to route 1

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
        setState(() {
          routePoints = []; // Clear route points on error
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
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
        // clamp to valid world bounds (no white borders)
        cameraConstraint: CameraConstraint.contain(
          bounds: LatLngBounds(
            LatLng(-85.0, -180.0),
            LatLng(85.0, 180.0),
          ),
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: dotenv.env['MAP_TILE_URL']!,
          userAgentPackageName: 'com.example.flutter_app',
          panBuffer: 2, // optional, smoother wrapping
        ),
        PolylineLayer(polylines: [
          for (final route in routePoints) ...[
            Polyline(points: route, strokeWidth: 8, color: Colors.white),
            Polyline(
                points: route, strokeWidth: 4, color: Colors.blue.shade500),
          ],
        ]),
        // Marker layer (your current location)
        MarkerLayer(
          markers: [
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
          ],
        ),
      ],
    );
  }
}
