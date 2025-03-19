import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Ergebnis der Authentifizierung bzw. Registrierung
class AuthResponse {
  final bool success;
  final String message;
  AuthResponse({required this.success, required this.message});
}

class AuthProvider with ChangeNotifier {
  late String _username;
  late int _userId;
  String get username => _username;
  int get userId => _userId;

  /// Führt den Login durch und gibt ein AuthResponse zurück.
  Future<AuthResponse> login(String username, String password) async {
    final url = Uri.parse("https://lkkbee3vea.execute-api.us-east-1.amazonaws.com/1/user/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      // Erwarte einen Response-Body wie: {"message": "Anmeldung erfolgreich.", "user_id": 123}
      final Map<String, dynamic> data = json.decode(response.body);
      _username = username;
      _userId = data['user_id'];
      notifyListeners();
      return AuthResponse(success: true, message: data['message'] ?? "Anmeldung erfolgreich.");
    } else {
      // Versuche, die Fehlermeldung aus dem Response-Body zu extrahieren.
      String errorMessage = response.body;
      try {
        final Map<String, dynamic> errorData = json.decode(response.body);
        if (errorData.containsKey("body")) {
          errorMessage = errorData["body"];
        }
      } catch (e) {
        // Falls der Body kein JSON ist, wird response.body direkt genutzt.
      }
      return AuthResponse(success: false, message: errorMessage);
    }
  }


  /// Führt die Registrierung durch und gibt ein AuthResponse zurück.
  Future<AuthResponse> register(String username, String password) async {
    final url = Uri.parse("https://lkkbee3vea.execute-api.us-east-1.amazonaws.com/1/user/register");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"username": username, "password": password}),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = json.decode(response.body);
      _userId = data['user_id'];
      return AuthResponse(success: true, message: "Benutzer erfolgreich registriert.");
    } else {
      String errorMessage = response.body;
      try {
        final Map<String, dynamic> errorData = json.decode(response.body);
        if (errorData.containsKey("body")) {
          errorMessage = errorData["body"];
        }
      } catch (e) {
        // Kein JSON: Fehlertext direkt übernehmen.
      }
      return AuthResponse(success: false, message: errorMessage);
    }
  }
}
