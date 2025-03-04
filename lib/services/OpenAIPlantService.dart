import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/PlantInfo.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIPlantService {
  late final String apiKey;
  final String apiUrl = 'https://api.openai.com/v1/chat/completions'; // passe den Endpunkt an

  OpenAIPlantService() {
    apiKey = dotenv.env['OPENAI_API_KEY']!;
  }

  Future<PlantInfo> getPlantInfo(String plantName) async {
    // Erstelle die Prompt, die du an die API senden möchtest
    final prompt = '''
       Bitte liefere mir Informationen über die Pflanze "$plantName" in folgendem Format:
       {
         "name": "...",
         "type": "...",
         "wateringDays": ["...", "..."],
         "location": "..."
       }
       ''';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-4o-2024-08-06', // oder ein anderes passendes Modell
        'prompt': prompt,
        'max_tokens': 150,
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Angenommen, der API-Antworttext enthält direkt das JSON-Objekt
      final resultText = data['choices'][0]['text'];

      // Versuch, den Antworttext als JSON zu parsen
      try {
        final Map<String, dynamic> resultJson = jsonDecode(resultText);
        return PlantInfo.fromJson(resultJson);
      } catch (e) {
        throw Exception('Fehler beim Parsen der API-Antwort: $e');
      }
    } else {
      throw Exception('Fehlerhafte Antwort der API: ${response.statusCode}');
    }
  }
}