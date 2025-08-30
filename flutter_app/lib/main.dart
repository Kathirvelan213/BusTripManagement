import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_app/components/pages/tracking/tracking_page.dart';
import 'package:flutter_app/services/hub_services/location_hub_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env.production");
  final LocationHubService locationHubService = LocationHubService();
  await locationHubService.start();
=======

void main() {
>>>>>>> d00d9210a4ba15460a5cb47e90bea4d55e709dd8
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
<<<<<<< HEAD
          child: TrackingPage(),
=======
          child: Text('Hello World!'),
>>>>>>> d00d9210a4ba15460a5cb47e90bea4d55e709dd8
        ),
      ),
    );
  }
}
