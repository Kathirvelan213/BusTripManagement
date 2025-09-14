import 'dart:async';
import 'package:syncfusion_flutter_maps/maps.dart';

class LocationService {
  static final _streamController = StreamController<MapLatLng>();
  Stream<MapLatLng> get stream => _streamController.stream;

  static void updateLocation(int routeId, double latitude, double longitude) {
    _streamController.add(MapLatLng(latitude, longitude));
  }
}
