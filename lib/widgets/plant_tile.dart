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
    return SizedBox(
      height: 250, // Reduzierte Gesamthöhe der Karte
      child: FlipCard(
        direction: FlipDirection.HORIZONTAL, // Alternativ: FlipDirection.VERTICAL
        front: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 4,
          child: Stack(
            children: [
              Column(
                children: [
                  // Oberer Bereich: Icon-Bereich, hier verkleinert und mit geringerem Flex-Anteil
                  Expanded(
                    flex: 1,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
                      child: Container(
                        width: double.infinity,
                        color: Colors.green.shade100,
                        child: const Icon(
                          Icons.local_florist,
                          size: 60, // Verkleinerte Icon-Größe
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                  // Unterer Bereich: Info-Bereich mit Texten und Button
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            plant.plantInfo.name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            plant.plantInfo.type,
                            style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
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
                                textAlign: TextAlign.center,
                              );
                            },
                          ),
                          const SizedBox(height: 20),
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
              // Flip-Hinweis Icon in der rechten unteren Ecke
              Positioned(
                bottom: 8,
                right: 8,
                child: Icon(
                  Icons.flip_camera_android,
                  size: 24,
                  color: Colors.grey.withOpacity(0.7),
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
      ),
    );
  }
}
