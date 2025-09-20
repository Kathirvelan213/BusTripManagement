import 'dart:async';
import 'package:latlong2/latlong.dart';

class LocationService {
  static final _streamController = StreamController<LatLng>.broadcast();
  static Stream<LatLng> get stream => _streamController.stream;

  static void updateLocation(int routeId, double latitude, double longitude) {
    _streamController.add(LatLng(latitude, longitude));
  }
}
