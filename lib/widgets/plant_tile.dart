import 'package:flutter/material.dart';
import '../models/plant.dart';

class PlantTile extends StatelessWidget {
  final Plant plant;
  final VoidCallback onWater;

  const PlantTile({super.key, required this.plant, required this.onWater});

  @override
  Widget build(BuildContext context) {
    String wateringText;
    if (plant.daysUntilNextWatering > 0) {
      wateringText = 'Noch ${plant.daysUntilNextWatering} Tage bis zum nächsten Gießen';
    } else {
      wateringText = 'Pflanze muss jetzt gegossen werden!';
    }
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4,
      child: Column(
        children: [
          // Obere Hälfte: Online-Bild der Pflanze
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
              child: Image.network(
                plant.imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          // Untere Hälfte: Pflanzendetails, Wasserstatus und Gießen-Button
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    plant.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(plant.type),
                  Text(
                    wateringText,
                    style: TextStyle(
                      fontSize: 12,
                      color: plant.daysUntilNextWatering > 0 ? Colors.black : Colors.red,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.opacity, color: Colors.blueAccent),
                    label: const Text('Gießen', style: TextStyle(color: Colors.blueAccent),),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
