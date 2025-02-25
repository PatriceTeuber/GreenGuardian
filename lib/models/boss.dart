import 'package:green_guardian/models/entity.dart';

class Boss extends Entity{
  final int id;
  final int playerId;

  Boss({required this.id, required this.playerId, required super.level, required super.maxLP, required super.currentLP});
}