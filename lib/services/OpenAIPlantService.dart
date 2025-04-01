import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/PlantInfo.dart';

class OpenAIPlantService {
  // Beispielendpunkt deiner Lambda-Funktion, z.B. über API Gateway
  final String lambdaEndpoint = 'https://674ykbftq6.execute-api.us-east-1.amazonaws.com/1/plant/getInfo';

  Future<PlantInfo> getPlantInfo(String plantName) async {
    final response = await http.post(
      Uri.parse(lambdaEndpoint),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"plantName": plantName}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PlantInfo.fromJson(data);
    } else {
      throw Exception('Fehlerhafte Antwort: ${response.statusCode}');
    }
  }
}