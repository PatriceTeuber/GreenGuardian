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

    // Pflanzenpflege-Card
    Widget plantListCard = Card(
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
                    subtitle: Text(
                        "${plant.getDaysUntilWatering()} Tage bis zum nächsten Gießen"),
                    trailing: IconButton(
                      icon: const Icon(Icons.opacity, color: Colors.blueAccent),
                      onPressed: () {
                        plantProvider.waterPlant(plant);
                        plantService.updateAllPlants(
                          userId: authProvider.userId,
                          plants: plantProvider.plants,
                        );
                      },
                    ),
                  );
                },
              ),
            const Divider(),
          ],
        ),
      ),
    );

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Statistik-Card abhängig von der Breite definieren
            Widget statisticsCard;
            if (constraints.maxWidth > 600) {
              // Bei breiten Bildschirmen: Werte untereinander (vertikal)
              statisticsCard = Card(
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatusItem(
                              "XP", gameState.playerXP.toStringAsFixed(0)),
                          const SizedBox(height: 8.0),
                          _buildStatusItem("Spieler HP",
                              gameState.playerHealth.toStringAsFixed(0)),
                          const SizedBox(height: 8.0),
                          _buildStatusItem("Boss HP",
                              gameState.bossHealth.toStringAsFixed(0)),
                          const SizedBox(height: 8.0),
                          _buildStatusItem("Währung", gameState.currency.toString()),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else {
              // Bei schmalen Bildschirmen: Werte horizontal (Row)
              statisticsCard = Card(
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
                          _buildStatusItem(
                              "XP", gameState.playerXP.toStringAsFixed(0)),
                          _buildStatusItem("Spieler HP",
                              gameState.playerHealth.toStringAsFixed(0)),
                          _buildStatusItem("Boss HP",
                              gameState.bossHealth.toStringAsFixed(0)),
                          _buildStatusItem("Währung", gameState.currency.toString()),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }

            // Gesamtlayout: Bei Breite über 600 Pixel werden die beiden Cards nebeneinander zentriert angezeigt.
            if (constraints.maxWidth > 600) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Statistik: 1/3 der Breite
                      Expanded(
                        flex: 1,
                        child: statisticsCard,
                      ),
                      const SizedBox(width: 16.0),
                      // Pflanzenpflege: 2/3 der Breite
                      Expanded(
                        flex: 2,
                        child: plantListCard,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              // In der mobilen Portrait-Ansicht: einfache Column-Anordnung
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  statisticsCard,
                  const SizedBox(height: 16.0),
                  plantListCard,
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildStatusItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4.0),
        Text(label),
      ],
    );
  }
}
