// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gameData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameData _$GameDataFromJson(Map<String, dynamic> json) => GameData(
      playerHealth: (json['playerHealth'] as num).toDouble(),
      maxPlayerHealth: (json['maxPlayerHealth'] as num).toDouble(),
      currency: (json['currency'] as num).toInt(),
      playerXP: (json['playerXP'] as num).toDouble(),
      bossHealth: (json['bossHealth'] as num).toDouble(),
      bossName: json['bossName'] as String,
      bossLevel: (json['bossLevel'] as num).toInt(),
      items: (json['items'] as List<dynamic>)
          .map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GameDataToJson(GameData instance) => <String, dynamic>{
      'playerHealth': instance.playerHealth,
      'maxPlayerHealth': instance.maxPlayerHealth,
      'currency': instance.currency,
      'playerXP': instance.playerXP,
      'bossHealth': instance.bossHealth,
      'bossName': instance.bossName,
      'bossLevel': instance.bossLevel,
      'items': instance.items,
    };
