import 'dart:async';

class LocationData {
  final int routeId;
  final double latitude;
  final double longitude;

  LocationData({
    required this.routeId,
    required this.latitude,
    required this.longitude,
  });
}

class LocationService {
  static final _streamController = StreamController<LocationData>.broadcast();
  static Stream<LocationData> get stream => _streamController.stream;

  static void updateLocation(int routeId, double latitude, double longitude) {
    _streamController.add(LocationData(
      routeId: routeId,
      latitude: latitude,
      longitude: longitude,
    ));
  }
}
