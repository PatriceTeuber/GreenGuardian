import 'package:json_annotation/json_annotation.dart';

import '../game/entities/items/Item.dart';

part 'gameData.g.dart';

@JsonSerializable()
class GameData {
  final double playerHealth;
  final double maxPlayerHealth;
  final int currency;
  final double playerXP;
  final double bossHealth;
  final String bossName;
  final int bossLevel;
  final List<Item> items;

  GameData({
    required this.playerHealth,
    required this.maxPlayerHealth,
    required this.currency,
    required this.playerXP,
    required this.bossHealth,
    required this.bossName,
    required this.bossLevel,
    required this.items,
  });

  factory GameData.fromJson(Map<String, dynamic> json) =>
      _$GameDataFromJson(json);

  Map<String, dynamic> toJson() => _$GameDataToJson(this);
}
