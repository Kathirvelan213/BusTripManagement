import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/config/app_config.dart';
import 'package:flutter_app/services/hub_services/hub_service.dart';
import 'package:flutter_app/services/location_services/location_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LocationHubService extends HubService {
  static final hubUrl = AppConfig.hubUrl;

  LocationHubService() : super(hubUrl) {
    on("receiveAcknowledgement", confirmConnection);
    on("receiveLocationUpdate", updateLocation);
  }
  void confirmConnection(arguements) {
    print("connected");
  }

  void updateLocation(arguements) {
    LocationService.updateLocation(arguements[0], arguements[1]);
  }
}
