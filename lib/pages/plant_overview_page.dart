import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/plant.dart';
import '../widgets/plant_tile.dart';
import '../services/PlantProvider.dart';

class PlantOverviewPage extends StatelessWidget {
  const PlantOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Zugriff auf die globale Pflanzenliste über den Provider
    final plants = Provider.of<PlantProvider>(context).plants;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meine Pflanzen'),
        automaticallyImplyLeading: false, // Entfernt den Standard-Zurück-Pfeil
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = kIsWeb ? (constraints.maxWidth < 600 ? 1 : 4) : 1;
          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.7,
            ),
            itemCount: plants.length,
            itemBuilder: (context, index) {
              final plant = plants[index];
              return PlantTile(
                plant: plant,
                onWater: () {
                  Provider.of<PlantProvider>(context, listen: false).waterPlant(plant);
                },
              );
            },
          );
        },
      ),
    );
  }
}
