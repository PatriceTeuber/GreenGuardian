import 'package:flutter/material.dart';
import 'package:green_guardian/models/plant.dart';
import 'package:provider/provider.dart';
import '../services/GameStateProvider.dart';
import '../services/OpenAIPlantService.dart';
import '../services/PlantProvider.dart';
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
  int _selectedIndex = 1;
  late OpenAIPlantService service;
  late final PlantGame plantGame;
  late List<Widget> _pages = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onAddPlant() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.text_fields),
                title: Text('Mit Pflanzennamen suchen'),
                onTap: () {
                  Navigator.pop(context);
                  _showPlantNameInputDialog();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPlantNameInputDialog() {
    // Speichere den Eltern-Kontext (aus HomeScreen) in einer Variablen.
    final parentContext = context;

    showDialog(
      context: parentContext,
      builder: (dialogContext) {
        String plantName = '';
        return AlertDialog(
          title: Text('Pflanzenname eingeben'),
          content: TextField(
            onChanged: (value) {
              plantName = value;
            },
            decoration: InputDecoration(hintText: "Name der Pflanze"),
          ),
          actions: [
            TextButton(
              child: Text('Abbrechen'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text('Suchen'),
              onPressed: () {
                // Schließe den Dialog.
                Navigator.of(dialogContext).pop();
                // Nutze den gespeicherten Eltern-Kontext für den Provider-Zugriff.
                service.getPlantInfo(plantName).then((plantInfo) {
                  Provider.of<PlantProvider>(parentContext, listen: false)
                      .addPlant(Plant(
                    id: 1,
                    //TODO: Bilder?
                    imagePath: "https://www.ikea.com/de/en/images/products/fejka-artificial-potted-plant-in-outdoor-monstera__0959226_pe809439_s5.jpg?f=xs",
                    plantInfo: plantInfo, attacked: false,
                  ));
                }).catchError((error) {
                  print("Fehler: $error");
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final plantProvider = Provider.of<PlantProvider>(context, listen: false);
      setState(() {
        plantGame = PlantGame(plantProvider: plantProvider, gameContext: context);
        _pages = [
          const DashboardPage(),
          const PlantOverviewPage(),
          BattlePage(plantGame: plantGame),
          ShopPage(plantGame: plantGame),
        ];
      });
    });
    service = OpenAIPlantService();
  }

  @override
  Widget build(BuildContext context) {
    // Zugriff auf den Provider hier, wenn benötigt:
    final plants = Provider.of<PlantProvider>(context).plants;
    final gameState = Provider.of<GameStateProvider>(context);

    return Scaffold(
      body: _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
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
              IconButton(
                icon: Icon(
                  Icons.dashboard,
                  color: _selectedIndex == 0 ? Colors.green : Colors.grey,
                ),
                onPressed: () => _onItemTapped(0),
              ),
              IconButton(
                icon: Icon(
                  Icons.local_florist,
                  color: _selectedIndex == 1 ? Colors.green : Colors.grey,
                ),
                onPressed: () => _onItemTapped(1),
              ),
              const SizedBox(width: 48),
              IconButton(
                icon: Icon(
                  Icons.military_tech,
                  color: _selectedIndex == 2 ? Colors.green : Colors.grey,
                ),
                onPressed: () => _onItemTapped(2),
              ),
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
