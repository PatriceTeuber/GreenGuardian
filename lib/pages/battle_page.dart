import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:green_guardian/game/PlantGame.dart';

class BattlePage extends StatelessWidget {
  const BattlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: PlantGame(),
    );
  }
}
