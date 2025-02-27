import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../game/PlantGame.dart';
import 'dashboard_page.dart';
import 'plant_overview_page.dart';
import 'battle_page.dart';
import 'shop_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Standardmäßig wird die Pflanzenübersicht angezeigt.
  int _selectedIndex = 1;

  late final PlantGame plantGame;
  late List<Widget> _pages = [];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onAddPlant() {
    // Hier kannst du später die Logik zum Hinzufügen einer neuen Pflanze einbauen.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Neue Pflanze hinzufügen')),
    );
  }

  @override
  void initState() {
    super.initState();
    plantGame = PlantGame();
    _pages = [
      const DashboardPage(),
      const PlantOverviewPage(),
      BattlePage(plantGame: plantGame),
      ShopPage(plantGame: plantGame),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0), // Erhöht den Radius des Buttons
        ),
        onPressed: _onAddPlant,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Dashboard-Icon
              IconButton(
                icon: Icon(
                  Icons.dashboard,
                  color: _selectedIndex == 0 ? Colors.green : Colors.grey,
                ),
                onPressed: () => _onItemTapped(0),
              ),
              // Pflanzenübersicht-Icon
              IconButton(
                icon: Icon(
                  Icons.local_florist,
                  color: _selectedIndex == 1 ? Colors.green : Colors.grey,
                ),
                onPressed: () => _onItemTapped(1),
              ),
              // Leeres Feld, um Platz für den FAB zu reservieren
              const SizedBox(width: 48),
              // Kampf-Icon (z. B. Sports MMA)
              IconButton(
                icon: Icon(
                  Icons.military_tech,
                  color: _selectedIndex == 2 ? Colors.green : Colors.grey,
                ),
                onPressed: () => _onItemTapped(2),
              ),
              // Shop-Icon
              IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: _selectedIndex == 3 ? Colors.green : Colors.grey,
                ),
                onPressed: () => _onItemTapped(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
