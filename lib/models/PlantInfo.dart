import 'package:json_annotation/json_annotation.dart';

part 'PlantInfo.g.dart';

@JsonSerializable()
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

  factory PlantInfo.fromJson(Map<String, dynamic> json) =>
      _$PlantInfoFromJson(json);

  @override
  String toString() {
    return 'PlantInfo{name: $name, type: $type, wateringDays: $wateringDays, location: $location}';
  }
}
