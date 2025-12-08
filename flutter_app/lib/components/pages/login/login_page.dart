import 'package:flutter/material.dart';
import '../../../../services/auth_services/google_auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  bool _loading = false;

  Future<void> _handleLogin() async {
    setState(() => _loading = true);

    final jwt = await _authService.login();

    setState(() => _loading = false);

    if (jwt != null) {
      // Navigate to your home page
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _handleLogin,
                child: const Text("Sign in with Google"),
              ),
      ),
    );
  }
}
