import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../game/PlantGame.dart';
import '../game/entities/overlays/InventoryOverlay.dart';
import '../game/entities/overlays/LoseScreenOverlay.dart';
import '../game/entities/overlays/WinScreenOverlay.dart';

class BattlePage extends StatelessWidget {
  final PlantGame plantGame;
  const BattlePage({super.key, required this.plantGame});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;

    return Scaffold(
      body: Stack(
        children: [
          GameWidget(
            game: plantGame,
            overlayBuilderMap: {
              'Inventory': (BuildContext context, PlantGame game) {
                return InventoryOverlay(game: game);
              },
              'WinScreen': (BuildContext context, PlantGame game) {
                return WinScreenOverlay(
                  game: game,
                  xpEarned: game.lastXPEarned,
                );
              },
              'LoseScreen': (BuildContext context, PlantGame game) {
                return LoseScreenOverlay(game: game);
              },
            },
          ),
          // Positioniere den Button dynamisch je nach Ausrichtung
          Positioned(
            bottom: isLandscape ? 30 : 20,
            right: isLandscape ? 30 : 20,
            child: FloatingActionButton(
              onPressed: () {
                plantGame.overlays.add('Inventory');
              },
              child: const Icon(Icons.inventory),
            ),
          ),
        ],
      ),
    );
  }
}
