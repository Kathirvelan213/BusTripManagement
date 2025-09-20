import 'package:flutter/material.dart';
import 'package:flutter_app/components/pages/route_selection/route_selection_page.dart';
import 'package:flutter_app/services/hub_services/location_hub_service.dart';
import 'package:flutter_app/services/location_services/trip_status_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  final LocationHubService locationHubService = LocationHubService();
  await locationHubService.start();
  // TripStatusService.instance.initializeStops(1);
  // locationHubService.joinRouteGroup(1);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: const RouteSelectionPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
