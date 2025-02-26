import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:green_guardian/game/PlantGame.dart';

import '../game/InventoryOverlay.dart';
import '../game/WinScreenOverlay.dart';

class BattlePage extends StatelessWidget {
  const BattlePage({super.key});

  @override
  Widget build(BuildContext context) {
    final plantGame = PlantGame();
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
