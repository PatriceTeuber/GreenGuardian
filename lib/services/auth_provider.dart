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
  String? username;
  // Falls du ein Token erhältst, kannst du es hier speichern:
  String? token;

  /// Führt den Login durch und gibt ein AuthResponse zurück.
  Future<AuthResponse> login(String username, String password) async {
    final url = Uri.parse("https://lkkbee3vea.execute-api.us-east-1.amazonaws.com/1/user/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      this.username = username;
      notifyListeners();
      return AuthResponse(success: true, message: "Anmeldung erfolgreich.");
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
