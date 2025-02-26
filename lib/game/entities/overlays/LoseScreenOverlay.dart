import 'package:flutter/material.dart';
import 'package:green_guardian/game/PlantGame.dart';

class LoseScreenOverlay extends StatelessWidget {
  final PlantGame game;

  const LoseScreenOverlay({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          width: 300,
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Game Over',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Bosse besiegt: ${game.bossCounter.toInt()}',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Schließe das LoseScreen-Overlay
                  game.overlays.remove('LoseScreen');
                  // Setze den Boss zurück
                  game.resetCurrentBoss();
                  // Optional: Spieler-HP wieder auffüllen oder andere Anpassungen vornehmen
                  game.playerHealth = 100;
                },
                child: const Text('Neustarten'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
