import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:green_guardian/services/PlantService.dart';
import 'package:provider/provider.dart';
import '../services/GameStateProvider.dart';
import '../services/auth_provider.dart';
import '../widgets/plant_tile.dart';
import '../services/PlantProvider.dart';

class PlantOverviewPage extends StatelessWidget {
  const PlantOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final plantService = PlantService();
    final gameState = Provider.of<GameStateProvider>(context);
    final plantProvider = Provider.of<PlantProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Zugriff auf die globale Pflanzenliste über den Provider
    final plants = Provider.of<PlantProvider>(context).plants;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meine Pflanzen'),
        automaticallyImplyLeading: false, // Entfernt den Standard-Zurück-Pfeil
      ),
      body: plants.isEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            "Es konnten keine Pflanzendaten gefunden werden",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ),
      )
          : LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount;
          if (constraints.maxWidth < 600) {
            // Kleine Bildschirme: 1 Karte pro Zeile
            crossAxisCount = 1;
          } else if (constraints.maxWidth < 1200) {
            // Mittlere Bildschirme: 2 Karten pro Zeile
            crossAxisCount = 2;
          } else {
            // Große Bildschirme: 4 Karten pro Zeile
            crossAxisCount = 4;
          }
          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 1,
            ),
            itemCount: plants.length,
            itemBuilder: (context, index) {
              final plant = plants[index];
              return PlantTile(
                plant: plant,
                onWater: () {
                  if (plantProvider.waterPlant(plant)) {
                    gameState.updateCurrency(gameState.currency + 35);
                  }
                  plantService.updateAllPlants(
                    userId: authProvider.userId,
                    plants: plantProvider.plants,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
