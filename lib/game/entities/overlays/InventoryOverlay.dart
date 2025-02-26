import 'package:flutter/material.dart';
import 'package:green_guardian/game/PlantGame.dart';

class InventoryOverlay extends StatelessWidget {
  final PlantGame game;
  const InventoryOverlay({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth  = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      // Mit einem GestureDetector erfassen wir Klicks außerhalb des Inventars.
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // Klickt der Nutzer außerhalb des Inventars, schließt sich das Overlay.
          game.overlays.remove('Inventory');
        },
        child: Stack(
          children: [
            // Das Inventar selbst, hier am unteren Bildschirmrand
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                // Verhindere, dass Klicks innerhalb des Inventars das Overlay schließen.
                onTap: () {},
                child: Container(
                  width: screenWidth,
                  height: screenHeight * 0.5, // z.B. untere Hälfte des Bildschirms
                  decoration: BoxDecoration(
                    // Statt image: verwende gradient oder color:
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.8),
                        Colors.white.withOpacity(0.9),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),

                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Inventar',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: game.inventory.length,
                          itemBuilder: (context, index) {
                            final item = game.inventory[index];
                            return GestureDetector(
                              onTap: () {
                                // Bei Klick: Item benutzen und Overlay schließen
                                game.useItem(item);
                                game.overlays.remove('Inventory');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Transform.scale(
                                      scale: 2,
                                      child: Image.asset(
                                        item.assetPath,
                                        width: 16,
                                        height: 16,
                                        fit: BoxFit.contain,
                                      )
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      item.name,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
