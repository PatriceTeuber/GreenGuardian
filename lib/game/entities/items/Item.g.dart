// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      randomAddition: (json['randomAddition'] as num).toInt(),
      description: json['description'] as String,
      price: (json['price'] as num).toInt(),
      name: json['name'] as String,
      assetPath: json['assetPath'] as String,
      effect: json['effect'] as String,
      value: (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'name': instance.name,
      'assetPath': instance.assetPath,
      'effect': instance.effect,
      'value': instance.value,
      'price': instance.price,
      'description': instance.description,
      'randomAddition': instance.randomAddition,
    };
