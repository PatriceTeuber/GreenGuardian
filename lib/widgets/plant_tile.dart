import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'dart:async';
import '../models/plant.dart';

class PlantTile extends StatelessWidget {
  final Plant plant;
  final VoidCallback onWater;

  const PlantTile({super.key, required this.plant, required this.onWater});

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      direction: FlipDirection.HORIZONTAL, // Alternativ: FlipDirection.VERTICAL
      front: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
                child: Container(
                  width: double.infinity,
                  color: Colors.green.shade100, // Hintergrundfarbe optional
                  child: const Icon(
                    Icons.local_florist, // Pflanzen-Icon
                    size: 100,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
            // Untere Hälfte: Pflanzendetails und Gießen-Button
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      plant.plantInfo.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(plant.plantInfo.type),
                    // Hier wird der Countdown aktualisiert:
                    StreamBuilder(
                      stream: Stream.periodic(const Duration(seconds: 1)),
                      builder: (context, snapshot) {
                        int days = plant.getDaysUntilWatering();
                        String wateringText = days > 0
                            ? 'Noch $days Tage bis zum nächsten Gießen'
                            : 'Pflanze muss jetzt gegossen werden!';
                        return Text(
                          wateringText,
                          style: TextStyle(
                            fontSize: 12,
                            color: days > 0 ? Colors.black : Colors.red,
                          ),
                        );
                      },
                    ),
                    ElevatedButton.icon(
                      onPressed: onWater,
                      icon: const Icon(Icons.opacity, color: Colors.blueAccent),
                      label: const Text(
                        'Gießen',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      back: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              plant.plantInfo.location,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
