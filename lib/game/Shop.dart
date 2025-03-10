import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:green_guardian/game/entities/items/BerryItem.dart';
import 'package:green_guardian/game/entities/items/BombItem.dart';
import 'package:green_guardian/game/entities/items/HealthPotionItem.dart';
import 'package:green_guardian/game/entities/items/Item.dart';

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
    final screenSize = MediaQuery.of(context).size;
    // Beispiel: Jede Karte soll 30% der Bildschirmhöhe einnehmen
    final double cardHeight = screenSize.height * 0.4;
    // Berechne die verfügbare Breite pro Karte (unter Berücksichtigung von Padding und Spacing)
    final int crossAxisCount = 2;
    final double horizontalPadding = 16 * 2; // linkes und rechtes Padding
    final double spacing = 16 * (crossAxisCount - 1);
    final double cardWidth = (screenSize.width - horizontalPadding - spacing) / crossAxisCount;
    final double aspectRatio = cardWidth / cardHeight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        automaticallyImplyLeading: false, // Entfernt den Standard-Zurück-Pfeil
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: aspectRatio,
          ),
          itemCount: shopItems.length,
          itemBuilder: (context, index) {
            final item = shopItems[index];
            return FlipCard(
              direction: FlipDirection.HORIZONTAL,
              front: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Positioniere das Icon etwas weiter unten
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Image.asset(
                        item.assetPath,
                        width: 50,
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Preis: ${item.price}'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (plantGame.currency >= item.price) {
                          plantGame.currency -= item.price;
                          plantGame.inventory.add(item);
                          print("Kauf erfolgt!: ${item.name}");
                        } else {
                          print("Geld reicht nicht mehr! ${plantGame.currency}");
                        }
                      },
                      child: const Text('Kaufen'),
                    ),
                  ],
                ),
              ),
              back: Card(
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
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.description,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

}
