import 'package:flutter/material.dart';
import 'package:green_guardian/game/PlantGame.dart';

class WinScreenOverlay extends StatelessWidget {
  final PlantGame game;
  final double xpEarned;

  const WinScreenOverlay({
    Key? key,
    required this.game,
    required this.xpEarned,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Das Overlay füllt den gesamten Bildschirm, aber der obere Bereich (z.B. Boss) bleibt sichtbar,
    // wenn das Overlay als halbtransparentes Widget über dem Spiel liegt.
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
                'Gewonnen!',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Erhaltene XP: $xpEarned',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Schließe das WinScreen-Overlay
                  game.overlays.remove('WinScreen');
                  // Starte den nächsten Boss
                  game.nextBoss();
                },
                child: const Text('Weiter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
