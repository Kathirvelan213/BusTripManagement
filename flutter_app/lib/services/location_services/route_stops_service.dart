import 'package:flutter_app/models/route_stop.dart';
import 'package:latlong2/latlong.dart';

class RouteStopsService {
  static final RouteStopsService _instance = RouteStopsService._internal();
  static RouteStopsService get instance => _instance;

  factory RouteStopsService() => _instance;
  RouteStopsService._internal();

  final Map<int, RouteStop> _stops = {}; // stopId -> RouteStop
  final Map<int, RouteStop> _stopsBySequence = {}; // sequence -> RouteStop
  int? _currentRouteId;

  /// Load stop coordinates for a route
  void setRouteStops(List<RouteStop> stops) {
    _stops.clear();
    _stopsBySequence.clear();

    for (final stop in stops) {
      _stops[stop.stopId] = stop;
      _stopsBySequence[stop.sequence] = stop;
    }

    if (stops.isNotEmpty) {
      _currentRouteId = stops.first.routeId;
    }
  }

  /// Get location for a specific stop by stopId
  LatLng? getStopLocation(int stopId) {
    final stop = _stops[stopId];
    return stop != null ? LatLng(stop.lat, stop.lng) : null;
  }

  /// Get location for a stop by its sequence number (stopNumber)
  LatLng? getStopLocationBySequence(int sequence) {
    final stop = _stopsBySequence[sequence];
    return stop != null ? LatLng(stop.lat, stop.lng) : null;
  }

  int get totalStops => _stopsBySequence.length;

  /// Get RouteStop by sequence
  RouteStop? getStopBySequence(int sequence) {
    return _stopsBySequence[sequence];
  }

  /// Clear all stop data
  void clear() {
    _stops.clear();
    _stopsBySequence.clear();
    _currentRouteId = null;
  }

  /// Get current route ID
  int? get currentRouteId => _currentRouteId;
}
