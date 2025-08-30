import 'package:flutter/material.dart';
import 'package:flutter_app/services/location_services/location_service.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// class TrackingPage extends StatelessWidget {
//   TrackingPage({super.key});
//   Location location = Location();

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ElevatedButton(
//                 onPressed: () {
//                   print('hi');
//                   location.requestPermission();
//                   Future<LocationData> loc = location.getLocation();
//                   loc.then(
//                     (data) {
//                       print(data);
//                     },
//                   );
//                 },
//                 child: Text('data'))),
//         bottomNavigationBar: BottomNavigationBar(
//           items: [
//             BottomNavigationBarItem(icon: Text('data'), label: 'label'),
//             BottomNavigationBarItem(icon: Text('data2'), label: 'label2')
//           ],
//         ),
//       ),
//     );
//   }
// }

class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapTile(),
    );
  }
}

class MapTile extends StatefulWidget {
  MapTile({super.key});

  @override
  State<MapTile> createState() => _MapTileState();
}

class _MapTileState extends State<MapTile> {
  late MapZoomPanBehavior _mapZoomPanBehaviour;
  final LocationService locationService = LocationService();
  late MapLatLng _currentLocation;
  MapTileLayerController _mapController = MapTileLayerController();

  @override
  void initState() {
    _mapZoomPanBehaviour = MapZoomPanBehavior(
      enablePinching: true,
      enableDoubleTapZooming: true,
      enableMouseWheelZooming: true,
      enablePanning: true,
      focalLatLng: MapLatLng(27.1751, 78.0421),
      zoomLevel: 5,
      maxZoomLevel: 20,
    );
    _currentLocation = MapLatLng(0, 0);

    locationService.stream.listen(
      (MapLatLng locationData) {
        _updateCurrentLocation(locationData);
        print(locationData.latitude);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(2),
        child: SfMaps(
          layers: [
            MapTileLayer(
              urlTemplate: dotenv.env['MAP_TILE_URL']!,
              zoomPanBehavior: _mapZoomPanBehaviour,
              initialMarkersCount: 1,
              markerBuilder: (BuildContext context, int index) {
                return MapMarker(
                  latitude: double.parse(_currentLocation.latitude.toString()),
                  longitude:
                      double.parse(_currentLocation.longitude.toString()),
                  iconColor: Colors.green.shade900,
                );
              },
              controller: _mapController,
            ),
          ],
        ),
      ),
    );
  }

  void _updateCurrentLocation(MapLatLng newLocation) {
    // if (newLocation.latitude != null && newLocation.longitude != null) {
    setState(
      () {
        _currentLocation = newLocation;
        _mapController.updateMarkers([0]);
      },
    );
  }
}
