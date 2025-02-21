import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../widgets/plant_tile.dart';

class PlantOverviewPage extends StatefulWidget {
  const PlantOverviewPage({super.key});

  @override
  _PlantOverviewPageState createState() => _PlantOverviewPageState();
}

class _PlantOverviewPageState extends State<PlantOverviewPage> {
  List<Plant> _plants = [];

  @override
  void initState() {
    super.initState();
    _loadPlants();
  }


  void _loadPlants() {
    // Beispiel: Monstera wurde vor 1 Tag gegossen, Sansevieria vor 5 Tagen.
    setState(() {
      _plants = [
        Plant(
          id: '1',
          name: 'Monstera',
          type: 'Zimmerpflanze',
          imagePath: 'https://de-de.bakker.com/cdn/shop/files/VIS_018129_1_BK_1705411387376.jpg?v=1705411425',
          wateringIntervalDays: 3,
          lastWatered: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Plant(
          id: '2',
          name: 'Sansevieria',
          type: 'Luftreiniger',
          imagePath: 'https://www.ikea.com/de/de/images/products/sansevieria-trifasciata-pflanze-bogenhanf__0908898_pe676659_s5.jpg',
          wateringIntervalDays: 7,
          lastWatered: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ];
    });
  }

  void _waterPlant(Plant plant) {
    setState(() {
      plant.lastWatered = DateTime.now();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${plant.name} wurde gegossen!')),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meine Pflanzen'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Für Android (nicht Web) immer 1 Spalte, ansonsten responsiv (Web: 1 oder mehr Spalten)
          int crossAxisCount = kIsWeb ? (constraints.maxWidth < 600 ? 1 : 4) : 1;

          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.7,
            ),
            itemCount: _plants.length,
            itemBuilder: (context, index) {
              final plant = _plants[index];
              return PlantTile(
                plant: plant,
                onWater: () => _waterPlant(plant),
              );
            },
          );
        },
      ),
    );
  }
}
