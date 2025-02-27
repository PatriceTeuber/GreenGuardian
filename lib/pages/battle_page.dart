import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:green_guardian/game/PlantGame.dart';

import '../game/entities/overlays/InventoryOverlay.dart';
import '../game/entities/overlays/LoseScreenOverlay.dart';
import '../game/entities/overlays/WinScreenOverlay.dart';

class BattlePage extends StatelessWidget {
  final PlantGame plantGame;
  const BattlePage({super.key, required this.plantGame});

  @override
  Widget build(BuildContext context) {
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
                  xpEarned: game.lastXPEarned, // Stelle sicher, dass lastXPEarned deklariert ist.
                );
              },
              'LoseScreen': (BuildContext context, PlantGame game) {
                return LoseScreenOverlay(game: game);
              },
            },
          ),
          // Button, der das Inventar öffnet
          Positioned(
            bottom: 20,
            right: 20,
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
