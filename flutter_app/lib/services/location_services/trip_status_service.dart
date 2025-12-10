import 'package:flutter/material.dart';
import 'package:flutter_app/models/stop_status.dart';
import 'package:flutter_app/services/api_consumer/api_client.dart';
import 'package:flutter_app/services/api_consumer/route_stops_api.dart';
import 'package:flutter_app/services/location_services/route_stops_service.dart';
import 'package:flutter_app/services/notification_services/reminder_service.dart';
import 'package:flutter_app/services/notification_services/notification_service.dart';

/// Model to represent a stop and its status

/// Singleton StopStatusService
class TripStatusService {
  // Private constructor
  TripStatusService._();

  // Singleton instance
  static final TripStatusService instance = TripStatusService._();

  // ValueNotifier so widgets can listen to updates
  final ValueNotifier<List<StopStatus>> stopsNotifier =
      ValueNotifier<List<StopStatus>>([]);

  /// Initialize stops from API
  Future<void> initializeStops(int routeId) async {
    try {
      final data = await getRouteStops(routeId);

      // Populate RouteStopsService with stop locations
      RouteStopsService.instance.setRouteStops(data);

      final stops = data.map((rs) {
        return StopStatus(
          routeId: rs.routeId,
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
    final stops = List<StopStatus>.from(stopsNotifier.value);
    if (stopNumber > 0 && stopNumber <= stops.length) {
      // Get the current stop information before updating
      final currentStop = stops[stopNumber - 1];

      // Check if there's an active reminder for this stop
      if (ReminderService.instance
          .hasActiveReminder(currentStop.routeId, currentStop.stopNumber)) {
        // Trigger notification
        NotificationService.instance.showStopReachedNotification(
          stopName: currentStop.stopName,
          routeName:
              'Route ${currentStop.routeId}', // You can make this more descriptive
          stopNumber: currentStop.stopNumber,
        );
      }

      // Mark previous stops as passed
      for (int i = stopNumber - 2; i >= 0; i--) {
        if (!stops[i].reached) {
          stops[i] = StopStatus(
            routeId: stops[i].routeId,
            stopNumber: stops[i].stopNumber,
            stopName: stops[i].stopName,
            reached: true,
            passed: true,
            reachedTime: DateTime.now(),
          );
        } else {
          break;
        }
      }

      // Mark the stop before current as passed
      if (stopNumber - 2 >= 0) {
        stops[stopNumber - 2] = StopStatus(
          routeId: stops[stopNumber - 2].routeId,
          stopNumber: stops[stopNumber - 2].stopNumber,
          stopName: stops[stopNumber - 2].stopName,
          reached: true,
          passed: true,
          reachedTime: DateTime.now(),
        );
      }

      // Mark current stop as reached (not passed)
      final stop = stops[stopNumber - 1];
      stops[stopNumber - 1] = StopStatus(
        routeId: stop.routeId,
        stopNumber: stop.stopNumber,
        stopName: stop.stopName,
        reached: true,
        reachedTime: DateTime.now(),
      );
      stopsNotifier.value = stops;
    }
  }

  void resetRouteStatus([List<Object?>? args]) {
    final stops = stopsNotifier.value.map((s) {
      return StopStatus(
          routeId: s.routeId, stopNumber: s.stopNumber, stopName: s.stopName);
    }).toList();
    stopsNotifier.value = stops;
  }

  /// Convenience getter
  List<StopStatus> get stops => stopsNotifier.value;
}

/// A global navigator key (needed for formatting TimeOfDay outside widgets)
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
