import 'dart:convert';
import 'package:http/http.dart' as http;

class GameService {
  final String baseUrl = "https://lkkbee3vea.execute-api.us-east-1.amazonaws.com/1/game";

  GameService();

  /// Speichert die Spieldaten eines Benutzers.
  /// Erwartet als Parameter die Benutzer-ID und ein Map mit den Spieldaten.
  Future<bool> addOrUpdateGameData({
    required int userId,
    required Map<String, dynamic> gameData,
  }) async {
    final url = Uri.parse('$baseUrl/save');
    final body = jsonEncode({
      'user_id': userId,
      'game_data': gameData,
    });
    print(body);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'game_data': gameData,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Fehler beim Speichern der Spieldaten: ${response.body}');
    }
  }

  /// Ruft die Spieldaten eines Benutzers ab.
  /// Erwartet als Parameter die Benutzer-ID.
  Future<Map<String, dynamic>> getGameData({required int userId}) async {
    final url = Uri.parse('$baseUrl/get');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
      }),
    );

    if (response.statusCode == 200) {
      // Annahme: Die API gibt ein JSON-Objekt zurück, das die Spieldaten enthält.
      final decoded = jsonDecode(response.body);
      return decoded as Map<String, dynamic>;
    } else {
      throw Exception('Fehler beim Abrufen der Spieldaten: ${response.body}');
    }
  }
}