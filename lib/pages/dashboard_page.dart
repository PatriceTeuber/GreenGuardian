import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/plant.dart';
import '../services/GameStateProvider.dart';
import '../services/PlantProvider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);
    final List<Plant> plants = Provider.of<PlantProvider>(context).plants;

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
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Statistik",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatusItem("XP", gameState.playerXP.toStringAsFixed(0)),
                        _buildStatusItem("Spieler HP", gameState.playerHealth.toStringAsFixed(0)),
                        _buildStatusItem("Boss HP", gameState.bossHealth.toStringAsFixed(0)),
                        _buildStatusItem("Währung", gameState.currency.toString()),
                      ],
                    ),
                  ],
                ),
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
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: plants.length,
                      itemBuilder: (BuildContext context, int index) {
                        final plant = plants[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.local_florist, color: Colors.green),
                          title: Text(plant.plantInfo.name),
                          subtitle: Text("${plant.getDaysUntilWatering()} Tage bis zum nächsten Gießen"),
                          trailing: IconButton(
                            icon: const Icon(Icons.opacity, color: Colors.blueAccent),
                            onPressed: () {
                              // Beispiel: Pflanze gießen (hier könnte auch ein Provider-Aufruf erfolgen)
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
            // Weitere Cards (z.B. Boss-Kampf, Lebens-Status) hier einbauen...
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4.0),
        Text(label),
      ],
    );
  }
}
