import 'package:flutter/material.dart';

import '../models/boss.dart';
import '../models/plant.dart';
import '../models/player.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  late Player _player;
  late List<Plant> _plants;
  late Boss _boss;

  @override
  void initState() {
    super.initState();
    _loadPlayerAndPlants();
  }

  void _loadPlayerAndPlants() {
    setState(() {
      //TODO: Später Requests vom AWS API Gateway einbauen;
      _player = Player(
          id: 3,
          name: 'Robert Testerheld',
          points: 1400,
          level: 3,
          xp: 300,
          maxLP: 500,
          currentLP: 342
      );

      _plants = [
        Plant(
          id: 1,
          playerId: 3,
          name: 'Monstera',
          type: 'Zimmerpflanze',
          imagePath: 'https://de-de.bakker.com/cdn/shop/files/VIS_018129_1_BK_1705411387376.jpg?v=1705411425',
          wateringIntervalDays: 3,
          lastWatered: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Plant(
          id: 2,
          playerId: 3,
          name: 'Sansevieria',
          type: 'Luftreiniger',
          imagePath: 'https://www.ikea.com/de/de/images/products/sansevieria-trifasciata-pflanze-bogenhanf__0908898_pe676659_s5.jpg',
          wateringIntervalDays: 7,
          lastWatered: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ];

      _boss = Boss(
        id: 1,
        playerId: 3,
        level: 2,
        maxLP: 2000,
        currentLP: 234
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gamification-Status Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _player.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatusItem("Punkte", _player.points.toString()),
                        _buildStatusItem("Level", _player.level.toString()),
                        _buildStatusItem("XP", "${_player.currentLP}/${_player.maxLP}"),
                      ],
                    ),
                  ],
                )
              ),
            ),
            const SizedBox(height: 16.0),
            // Pflanzenpflege Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pflanzenpflege",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8.0),
                    ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(), // Optional, um Scrollen zu deaktivieren
                      itemCount: _plants.length,
                      itemBuilder: (BuildContext context, int index) {
                        final plant = _plants[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.local_florist, color: Colors.green),
                          title: Text(plant.name),
                          subtitle: Text("${plant.daysUntilNextWatering} Tage bis zum nächsten Gießen"),
                          trailing: IconButton(
                            icon: const Icon(Icons.opacity, color: Colors.blueAccent),
                            onPressed: () {
                              //TODO Aktion: Pflanze gießen
                            },
                          ),
                        );
                      },
                    ),
                    const Divider(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Boss-Kampf Status Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Boss-Kampf",
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8.0),
                    LinearProgressIndicator(
                      value: _boss.getProgress, // % Fortschritt
                      backgroundColor: Colors.grey[300],
                      valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.redAccent),
                    ),
                    const SizedBox(height: 8.0),
                    Text("Boss HP: ${_boss.getProgress}%"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Boss-Kampf Status Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Lebens-Status",
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8.0),
                    LinearProgressIndicator(
                      value: _player.getProgress, // Beispiel: 50% Fortschritt
                      backgroundColor: Colors.grey[300],
                      valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                    ),
                    const SizedBox(height: 8.0),
                    Text("Spieler HP: ${_player.getProgress}%"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4.0),
        Text(label),
      ],
    );
  }
}
