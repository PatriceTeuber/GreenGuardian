import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatusItem("Punkte", "1200"),
                    _buildStatusItem("Level", "5"),
                    _buildStatusItem("XP", "300/500"),
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
                    // ListTile für die Monstera
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.local_florist, color: Colors.green),
                      title: const Text("Monstera"),
                      subtitle: const Text("2 Tage bis zum nächsten Gießen"),
                      trailing: IconButton(
                        icon: const Icon(Icons.opacity, color: Colors.blueAccent),
                        onPressed: () {
                          // Aktion: Pflanze gießen
                        },
                      ),
                    ),
                    const Divider(),
                    // ListTile für die Sansevieria
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.local_florist, color: Colors.green),
                      title: const Text("Sansevieria"),
                      subtitle: const Text("Heute gießen"),
                      trailing: IconButton(
                        icon: const Icon(Icons.opacity, color: Colors.blueAccent),
                        onPressed: () {
                          // Aktion: Pflanze gießen
                        },
                      ),
                    ),
                    // Hier kannst du weitere ListTiles hinzufügen, falls du mehrere Pflanzen hast.
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
                      value: 0.5, // Beispiel: 50% Fortschritt
                      backgroundColor: Colors.grey[300],
                      valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.redAccent),
                    ),
                    const SizedBox(height: 8.0),
                    const Text("Boss HP: 50%"),
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
                      value: 0.8, // Beispiel: 50% Fortschritt
                      backgroundColor: Colors.grey[300],
                      valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                    ),
                    const SizedBox(height: 8.0),
                    const Text("Spieler HP: 80%"),
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
