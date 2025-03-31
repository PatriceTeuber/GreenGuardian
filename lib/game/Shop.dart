import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:green_guardian/game/entities/items/BerryItem.dart';
import 'package:green_guardian/game/entities/items/BombItem.dart';
import 'package:green_guardian/game/entities/items/HealthPotionItem.dart';
import 'package:green_guardian/game/entities/items/Item.dart';
import 'package:provider/provider.dart';

import '../services/GameService.dart';
import '../services/GameStateProvider.dart';
import '../services/auth_provider.dart';
import 'PlantGame.dart';
import 'entities/items/IceSpellItem.dart';
import 'entities/items/WindSpell.dart';

class Shop extends StatelessWidget {
  final PlantGame plantGame;
  Shop({super.key, required this.plantGame});

  // Beispielhafte Liste von Shop-Items
  final List<Item> shopItems = [
    BerryItem(),
    BombItem(),
    HealthPotionItem(),
    IceSpellItem(),
    WindSpellItem()
    // Weitere Items hier...
  ];

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Währung: ${plantGame.currency}',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
        automaticallyImplyLeading: false, // Entfernt den Standard-Zurück-Pfeil
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Konfiguration der GridView
            final int crossAxisCount = 2;
            final double spacing = 16.0;
            final double totalHorizontalPadding = 16 * 2 + spacing * (crossAxisCount - 1);
            final double cardWidth = (constraints.maxWidth - totalHorizontalPadding) / crossAxisCount;
            // Hier definieren wir ein Verhältnis, z.B. 1.4-mal so hoch wie die Breite
            final double cardHeight = cardWidth * 1.4;
            final double aspectRatio = cardWidth / cardHeight;

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
                childAspectRatio: aspectRatio,
              ),
              itemCount: shopItems.length,
              itemBuilder: (context, index) {
                final item = shopItems[index];
                return FlipCard(
                  direction: FlipDirection.HORIZONTAL,
                  front: SizedBox(
                    height: cardHeight,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Nutze Flexible, um Overflow beim Bild zu vermeiden
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Image.asset(
                                item.assetPath,
                                width: 50,
                                height: 50,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Preis: ${item.price}'),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              if (plantGame.currency >= item.price) {
                                plantGame.currency -= item.price;
                                gameState.updateCurrency(plantGame.currency);
                                plantGame.inventory.add(item);
                                print("Kauf erfolgt!: ${item.name}");

                                // Backend aktualisieren
                                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                                GameService gameService = GameService();
                                final gameData = Provider.of<GameStateProvider>(context, listen: false)
                                    .currentGameData;
                                gameService.addOrUpdateGameData(
                                  userId: authProvider.userId,
                                  gameData: gameData.toJson(),
                                );
                              } else {
                                print("Nicht genug Währung! ${plantGame.currency}");
                              }
                            },
                            child: const Text('Kaufen'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  back: SizedBox(
                    height: cardHeight,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.description,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
