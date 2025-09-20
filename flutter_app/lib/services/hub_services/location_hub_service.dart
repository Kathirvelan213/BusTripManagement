import 'package:flutter/material.dart';
import 'package:flutter_app/config/app_config.dart';
import 'package:flutter_app/services/hub_services/hub_service.dart';
import 'package:flutter_app/services/location_services/location_service.dart';
import 'package:flutter_app/services/location_services/trip_status_service.dart';
import 'package:signalr_netcore/signalr_client.dart';

class LocationHubService extends HubService {
  static final hubUrl = AppConfig.hubUrl;
  int? _currentRouteId;
  static final LocationHubService _instance = LocationHubService._internal();
  factory LocationHubService() => _instance;
  LocationHubService._internal() : super(hubUrl) {
    on("receiveAcknowledgement", confirmConnection);
    on("receiveLocationUpdate", updateLocation);
    on("stopReached", notifyStopReached);
    on("resetRouteStatus", TripStatusService.instance.resetRouteStatus);
  }

  void confirmConnection(arguments) {
    print("connected");
    // Don't auto-join any group - wait for route selection
  }

  void notifyStopReached(arguments) {
    print("stopReached: " + arguments[0]["stopName"]);
    TripStatusService.instance.markStopReached(arguments[0]["stopNumber"]);
  }

  void updateLocation(args) {
    if (args == null || args.isEmpty) return;
    final routeId = args[0]["routeId"] as int;
    final latitude = (args[0]["latitude"] as num).toDouble();
    final longitude = (args[0]["longitude"] as num).toDouble();

    LocationService.updateLocation(routeId, latitude, longitude);
  }

  void joinRouteGroup(int routeId) {
    if (hubConnection.state != HubConnectionState.Connected) {
      print("Cannot join route group, hub not connected");
      return;
    }
    if (_currentRouteId != null && _currentRouteId != routeId) {
      // Leave current group first
      leaveRouteGroup();
    }
    _currentRouteId = routeId;
    invoke('JoinRouteGroup', args: [routeId]);
    print("Joined route group: $routeId");
  }

  void leaveRouteGroup() {
    final routeId = _currentRouteId;
    if (routeId == null ||
        hubConnection.state != HubConnectionState.Connected) {
      print("No route group to leave or hub not connected");
      return;
    }
    if (_currentRouteId != null) {
      invoke('LeaveRouteGroup', args: [_currentRouteId!]);
      print("Left route group: $_currentRouteId");
      _currentRouteId = null;
    }
  }

  int? get currentRouteId => _currentRouteId;
}
