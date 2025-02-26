import 'entity.dart';

class Player extends Entity{
  final int id;
  final String name;
  int points;
  int xp;

  Player({
    required this.id,
    required this.name,
    required this.points,
    required super.level,
    required this.xp,
    required super.maxLP,
    required super.currentLP,
  });
}
