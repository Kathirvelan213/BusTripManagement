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

  LocationHubService() : super(hubUrl) {
    on("receiveAcknowledgement", confirmConnection);
    on("receiveLocationUpdate", updateLocation);
    on("stopReached", notifyStopReached);
  }
  void confirmConnection(arguements) {
    print("connected");
    JoinGroup(1);
  }

  void notifyStopReached(arguements) {
    TripStatusService.instance.markStopReached(arguements[0]);
  }

  void updateLocation(arguements) {
    LocationService.updateLocation(arguements[0], arguements[1]);
  }

  void JoinGroup(routeId) {
    invoke('JoinRouteGroup', args: [routeId]);
  }
}
