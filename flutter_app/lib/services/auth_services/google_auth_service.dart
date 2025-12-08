import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../../config/app_config.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  final _storage = const FlutterSecureStorage();

  /// Login with Google → send ID token to backend → receive JWT
  Future<String?> login() async {
    try {
      // 1. Google login (client-side)
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      print("Google ID Token: $idToken");
      if (idToken == null) return null;
      // 2. Send idToken to backend
      final url = Uri.parse("${AppConfig.backendUrl}/auth/google/mobile");

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({"idToken": idToken}),
      );

      if (response.statusCode != 200) {
        print("Backend login failed: ${response.body}");
        return null;
      }

      final body = jsonDecode(response.body);
      final jwt = body["token"] as String?;

      if (jwt == null) return null;

      // 3. Store JWT securely
      await _storage.write(key: "jwt", value: jwt);

      return jwt;
    } catch (e) {
      print("Login error: $e");
      return null;
    }
  }

  /// Read stored JWT
  Future<String?> getJwt() async {
    return await _storage.read(key: "jwt");
  }

  /// Logout (clear token + Google account)
  Future<void> logout() async {
    await _storage.delete(key: "jwt");
    await _googleSignIn.signOut();
  }
}
