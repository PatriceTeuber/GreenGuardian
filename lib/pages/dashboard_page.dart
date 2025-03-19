import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/plant.dart';
import '../services/GameStateProvider.dart';
import '../services/PlantProvider.dart';
import '../services/PlantService.dart';
import '../services/auth_provider.dart';
import 'login.dart';

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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Abmelden"),
        content: const Text("Möchten Sie sich wirklich abmelden?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Dialog schließen, Abbrechen
            },
            child: const Text("Abbrechen"),
          ),
          TextButton(
            onPressed: () {
              // Hier z. B. deine Logout-Logik (Provider oder ähnliches)
              Navigator.of(ctx).pop(); // Dialog schließen
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text("Ja"),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);
    final List<Plant> plants = Provider.of<PlantProvider>(context).plants;
    final plantService = PlantService();
    final plantProvider = Provider.of<PlantProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: ElevatedButton.icon(
              onPressed: () => _showLogoutDialog(context),
              icon: const Icon(Icons.exit_to_app),
              label: const Text('Ausloggen'),
            ),
          ),
        ],
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
                    // Überprüfe, ob Pflanzen vorhanden sind:
                    if (plants.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            "Es konnten keine Pflanzendaten gefunden werden",
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    else
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
                                plantProvider.waterPlant(plant);
                                plantService.updateAllPlants(userId: authProvider.userId, plants: plantProvider.plants);
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
