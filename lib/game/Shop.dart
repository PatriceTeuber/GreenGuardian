import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:green_guardian/game/entities/items/BerryItem.dart';
import 'package:green_guardian/game/entities/items/BombItem.dart';
import 'package:green_guardian/game/entities/items/Item.dart';

import 'PlantGame.dart';

class Shop extends StatelessWidget {
  final PlantGame plantGame;
  Shop({super.key, required this.plantGame});

  // Beispielhafte Liste von Shop-Items
  final List<Item> shopItems = [
    BerryItem(),
    BombItem()
    // Weitere Items hier...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Zwei Items pro Zeile
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: shopItems.length,
          itemBuilder: (context, index) {
            final item = shopItems[index];
            return FlipCard(
              direction: FlipDirection.HORIZONTAL, // oder vertical, je nach Präferenz
              front: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon etwas tiefer positionieren
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
