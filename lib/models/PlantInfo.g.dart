// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PlantInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlantInfo _$PlantInfoFromJson(Map<String, dynamic> json) => PlantInfo(
      name: json['name'] as String,
      type: json['type'] as String,
      wateringDays: (json['wateringDays'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      location: json['location'] as String,
    );

Map<String, dynamic> _$PlantInfoToJson(PlantInfo instance) => <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'wateringDays': instance.wateringDays,
      'location': instance.location,
    };
