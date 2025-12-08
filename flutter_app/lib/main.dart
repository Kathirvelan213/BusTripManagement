import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/pages/route_selection/route_selection_page.dart';
import 'package:flutter_app/services/hub_services/location_hub_service.dart';
import 'package:flutter_app/services/auth_services/google_auth_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'components/pages/login/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env
  await dotenv.load(fileName: ".env");

  // Optionally allow self-signed certs in dev: set ALLOW_INSECURE_SSL=true in .env.
  if ((dotenv.env['ALLOW_INSECURE_SSL'] ?? '').toLowerCase() == 'true') {
    HttpOverrides.global = _DevHttpOverrides();
  }

  runApp(const MainApp());
}

class _DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.badCertificateCallback = (cert, host, port) => true;
    return client;
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final AuthService _auth = AuthService();
  final LocationHubService _hub = LocationHubService();

  bool _checking = true;
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final jwt = await _auth.getJwt();

    if (jwt != null) {
      // Try connecting to SignalR hub now that we are authenticated
      await _hub.start();
      setState(() {
        _loggedIn = true;
      });
    }

    setState(() {
      _checking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _loggedIn ? const RouteSelectionPage() : const LoginPage(),
      routes: {
        "/home": (_) => const RouteSelectionPage(),
      },
    );
  }
}
