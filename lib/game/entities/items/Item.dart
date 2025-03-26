import 'package:json_annotation/json_annotation.dart';

part 'Item.g.dart';

@JsonSerializable()
class Item {
  final String name;
  final String assetPath;
  final String effect;
  final double value;
  final int price;
  final String description;
  final int randomAddition;

  Item({
    required this.randomAddition,
    required this.description,
    required this.price,
    required this.name,
    required this.assetPath,
    required this.effect,
    required this.value,
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
