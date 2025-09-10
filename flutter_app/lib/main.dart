import 'package:flutter/material.dart';
import 'package:flutter_app/components/pages/tracking/tracking_page.dart';
import 'package:flutter_app/services/hub_services/location_hub_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  final LocationHubService locationHubService = LocationHubService();
  await locationHubService.start();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: TrackingPage(),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
