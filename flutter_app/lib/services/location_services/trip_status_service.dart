import 'package:flutter/material.dart';
import 'package:flutter_app/services/api_consumer/api_client.dart';
import 'package:flutter_app/services/api_consumer/route_stops_api.dart';

/// Model to represent a stop and its status
class StopStatus {
  final int stopNumber;
  final String stopName;
  bool reached;
  String? reachedTime;

  StopStatus({
    required this.stopNumber,
    required this.stopName,
    this.reached = false,
    this.reachedTime,
  });
}

/// Singleton StopStatusService
class TripStatusService {
  // Private constructor
  TripStatusService._();

  // Singleton instance
  static final TripStatusService instance = TripStatusService._();

  // ValueNotifier so widgets can listen to updates
  final ValueNotifier<List<StopStatus>> stopsNotifier =
      ValueNotifier<List<StopStatus>>([]);

  final ApiClient _apiClient = ApiClient();

  /// Initialize stops from API
  Future<void> initializeStops(int routeId) async {
    try {
      final data = await getRouteStops(routeId);
      final stops = data.map((rs) {
        return StopStatus(
          stopNumber: rs.sequence,
          stopName: rs.name,
        );
      }).toList();
      stopsNotifier.value = stops;
    } catch (e) {
      debugPrint("Failed to load stops: $e");
      stopsNotifier.value = [];
    }
  }

  /// Mark a stop as reached
  void markStopReached(int stopNumber) {
    print(stopNumber);
    final stops = List<StopStatus>.from(stopsNotifier.value);
    if (stopNumber > 0 && stopNumber <= stops.length) {
      stops[stopNumber - 1].reached = true;
      print('hi');
      stopsNotifier.value = stops; // trigger UI update
    }
  }

  /// Reset all stops (e.g., new trip)
  void reset() {
    final stops = stopsNotifier.value.map((s) {
      return StopStatus(stopNumber: s.stopNumber, stopName: s.stopName);
    }).toList();
    stopsNotifier.value = stops;
  }

  /// Convenience getter
  List<StopStatus> get stops => stopsNotifier.value;
}

/// A global navigator key (needed for formatting TimeOfDay outside widgets)
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
