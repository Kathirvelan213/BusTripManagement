import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_app/services/location_services/location_service.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_app/routes/parsed_routes.dart';

class MapTile extends StatefulWidget {
  const MapTile({super.key});

  @override
  State<MapTile> createState() => _MapTileState();
}

class _MapTileState extends State<MapTile> {
  final LocationService locationService = LocationService();
  late LatLng _currentLocation;

  final MapController _mapController = MapController();

  List<List<LatLng>> routePoints = [];
  @override
  void initState() {
    super.initState();

    _currentLocation = LatLng(0, 0);
    loadRouteFromFile('lib/routes/HomeToSSN.kml').then((points) {
      setState(() {
        routePoints = points;
      });
    });
    locationService.stream.listen((locationData) {
      setState(() {
        _currentLocation =
            LatLng(locationData.latitude, locationData.longitude);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: LatLng(27.1751, 78.0421), // Taj Mahal area
        initialZoom: 5,
        minZoom: 2,
        maxZoom: 20,
        initialRotation: 0, // ensure initial rotation is 0
        interactionOptions: InteractionOptions(
            flags: InteractiveFlag.drag | InteractiveFlag.pinchZoom),
        // clamp to valid world bounds (no white borders)
        cameraConstraint: CameraConstraint.contain(
          bounds: LatLngBounds(
            LatLng(-85.0, -180.0),
            LatLng(85.0, 180.0),
          ),
        ),
      ),
      children: [
        // Tile layer (your map provider)
        TileLayer(
          urlTemplate: dotenv.env['MAP_TILE_URL']!,
          userAgentPackageName: 'com.example.flutter_app',
          panBuffer: 2, // optional, smoother wrapping
        ),
        PolylineLayer(
          polylines: [
            for (final points in routePoints)
              Polyline(points: points, strokeWidth: 4, color: Colors.blue),
          ],
        ),
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
