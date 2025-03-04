// Modell zur Repräsentation der Pflanzeninformationen
class PlantInfo {
  final String name;
  final String type;
  final List<String> wateringDays;
  final String location;

  PlantInfo({
    required this.name,
    required this.type,
    required this.wateringDays,
    required this.location,
  });

  // Annahme: Die API gibt ein JSON zurück, das zu diesem Modell passt
  factory PlantInfo.fromJson(Map<String, dynamic> json) {
    return PlantInfo(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      wateringDays: List<String>.from(json['wateringDays'] ?? []),
      location: json['location'] ?? '',
    );
  }
}