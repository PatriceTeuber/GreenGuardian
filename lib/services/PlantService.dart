import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/plant.dart';

class PlantService {
  final String baseUrl = "https://lkkbee3vea.execute-api.us-east-1.amazonaws.com/1/plant";

  PlantService();

  /// Fügt eine Pflanze hinzu.
  /// Erwartet als Parameter die Benutzer-ID und ein Map mit den Pflanzendaten.
  Future<bool> addPlant({
    required int userId,
    required Plant plantData,
  }) async {
    final url = Uri.parse('$baseUrl/add');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'plant_data': plantData.toJsonReduced(),
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Fehler beim Hinzufügen der Pflanze: ${response.body}');
    }
  }

  /// Ruft alle Pflanzen eines Benutzers ab.
  /// Hier wird angenommen, dass der Endpunkt die Benutzer-ID als Query-Parameter erwartet.
  Future<List<Map<String, dynamic>>> getAllPlants({required int userId}) async {
    // Anpassen, falls der API-Endpunkt stattdessen einen POST-Request oder Body erwartet.
    final url = Uri.parse('$baseUrl/getAll');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
      }),
    );

    if (response.statusCode == 200) {
      // Annahme: Die API gibt eine JSON-Liste zurück.
      final List<dynamic> decoded = jsonDecode(response.body);
      return decoded.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Fehler beim Abrufen der Pflanzen: ${response.body}');
    }
  }

  Future<bool> updateAllPlants({
    required int userId,
    required List<Plant> plants,
  }) async {
    final url = Uri.parse('$baseUrl/updateAll');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'plants': plants.map((plant) => plant.toJson()).toList(),
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Fehler beim Aktualisieren der Pflanzen: ${response.body}');
    }
  }


}
