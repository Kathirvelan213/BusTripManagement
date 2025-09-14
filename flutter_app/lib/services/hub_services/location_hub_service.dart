import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/config/app_config.dart';
import 'package:flutter_app/services/hub_services/hub_service.dart';
import 'package:flutter_app/services/location_services/location_service.dart';
import 'package:flutter_app/services/location_services/trip_status_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LocationHubService extends HubService {
  static final hubUrl = AppConfig.hubUrl;
  int tempRouteId = 1;

  LocationHubService() : super(hubUrl) {
    on("receiveAcknowledgement", confirmConnection);
    on("receiveLocationUpdate", updateLocation);
    on("stopReached", notifyStopReached);
  }
  void confirmConnection(arguments) {
    print("connected");
    JoinGroup(tempRouteId);
  }

  void notifyStopReached(arguments) {
    print("stopReached: " + arguments[0]["stopName"]);
    // TripStatusService.instance.markStopReached(arguments[0]);
  }

  void updateLocation(args) {
    if (args == null || args.isEmpty) return;
    final routeId = args[0]["routeId"] as int;
    final latitude = (args[0]["latitude"] as num).toDouble();
    final longitude = (args[0]["longitude"] as num).toDouble();

    LocationService.updateLocation(routeId, latitude, longitude);
  }

  void JoinGroup(routeId) {
    invoke('JoinRouteGroup', args: [routeId]);
  }
}
