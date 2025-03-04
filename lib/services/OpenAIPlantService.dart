import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/PlantInfo.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIPlantService {
  late final String apiKey;
  final String apiUrl = 'https://api.openai.com/v1/chat/completions'; // Chat-Endpunkt

  OpenAIPlantService() {
    apiKey = dotenv.env['OPENAI_API_KEY']!;
  }

  Future<PlantInfo> getPlantInfo(String plantName) async {
    final prompt = '''
      Bitte liefere mir Informationen über die Pflanze "$plantName" in folgendem Format auf deutsch:
      {
        "name": "...",
        "type": "...",
        "wateringDays": ["...", "..."],
        "location": "..."
      }
      Nur das Format befüllen und keine anderen Infos oder Redewendungen. Bitte Format ohne ```json davor und ohne ``` am Ende.
      ''';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      // Beachte hier die Nutzung des Feldes "messages" statt "prompt"
      body: jsonEncode({
        'model': 'gpt-4o', // Nutze hier ein gültiges Modell, z.B. 'gpt-4' oder 'gpt-3.5-turbo'
        'messages': [
          {"role": "user", "content": prompt}
        ],
        'max_tokens': 150,
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Bei Chat Completions steht die Antwort im "content" der ersten Nachricht
      final resultText = data['choices'][0]['message']['content'];

      try {
        final Map<String, dynamic> resultJson = jsonDecode(resultText);
        return PlantInfo.fromJson(resultJson);
      } catch (e) {
        throw Exception('Fehler beim Parsen der API-Antwort: $e');
      }
    } else {
      print('Response body: ${response.body}');
      throw Exception('Fehlerhafte Antwort der API: ${response.statusCode}');
    }
  }
}
