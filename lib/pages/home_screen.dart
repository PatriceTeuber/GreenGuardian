import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_guardian/models/plant.dart';
import 'package:green_guardian/services/GameService.dart';
import 'package:green_guardian/services/GameStateProvider.dart';
import 'package:green_guardian/services/PlantService.dart';
import 'package:green_guardian/services/auth_provider.dart';
import 'package:provider/provider.dart';
import '../models/gameData.dart';
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
  int _selectedIndex = 0;
  late OpenAIPlantService openAIPlantService;
  late PlantService plantService;
  late GameService gameService;
  late AuthProvider authProvider;
  late GameStateProvider gameStateProvider;
  late final PlantGame plantGame;
  late List<Widget> _pages = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showPlantNameInputDialog() {
    // Speichere den Eltern-Kontext (aus HomeScreen) in einer Variablen.
    final parentContext = context;

    showDialog(
      context: parentContext,
      builder: (dialogContext) {
        String plantName = '';
        final _formKey = GlobalKey<FormState>();

        return AlertDialog(
          title: Text('Neue Pflanze hinzufügen'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    "Gib den Namen deiner Pflanze ein. Unsere generative KI erstellt daraufhin einen individuellen Gießplan und liefert dir wertvolle Pflegetipps.",
                    style: TextStyle(fontSize: 14, color: Colors.blue[800]),
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  onChanged: (value) {
                    plantName = value;
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Bitte gib einen Pflanzennamen ein.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Name der Pflanze hier eingeben",
                  ),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              child: Text('Abbrechen'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text('Suchen'),
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                Navigator.of(dialogContext).pop();

                openAIPlantService.getPlantInfo(plantName).then((plantInfo) {
                  // Pflanze zur Datenbank hinzufügen
                  plantService
                      .addPlant(
                      userId: authProvider.userId,
                      plantData: Plant(
                        id: 0, // Dummy-Wert
                        userId: authProvider.userId,
                        attacked: false,
                        plantInfo: plantInfo,
                      ))
                      .then((success) {
                    if (success) {
                      // Nach erfolgreichem Hinzufügen: Alle Pflanzen dieses Users abrufen
                      plantService
                          .getAllPlants(userId: authProvider.userId)
                          .then((plantsData) {
                        print(plantsData);
                        // Umwandeln der JSON-Daten in Plant-Objekte
                        final List<Plant> plants = plantsData
                            .map((json) => Plant.fromJson(json))
                            .toList();
                        // Aktualisieren des Providers mit der neuen Liste
                        Provider.of<PlantProvider>(parentContext, listen: false)
                            .setPlants(plants);
                        // Zeige eine Erfolgsnachricht an
                        Fluttertoast.showToast(
                          msg: "Neue Pflanze: $plantName erfolgreich hinzugefügt!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }).catchError((error) {
                        print("Fehler beim Abrufen der Pflanzen: $error");
                        // Zeige eine Fehlernachricht an
                        Fluttertoast.showToast(
                          msg: "Neue Pflanze: $plantName konnte nicht hinzugefügt werden. Versuche es erneut.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      });
                    }
                  }).catchError((error) {
                    print("Fehler beim Hinzufügen der Pflanze: $error");
                    // Zeige eine Fehlernachricht an
                    Fluttertoast.showToast(
                      msg: "Neue Pflanze: $plantName konnte nicht hinzugefügt werden. Versuche es erneut.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  });
                }).catchError((error) {
                  print("Fehler: $error");
                  // Zeige eine Fehlernachricht an
                  Fluttertoast.showToast(
                    msg: "Neue Pflanze: $plantName konnte nicht hinzugefügt werden. Versuche es erneut.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
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
    openAIPlantService = OpenAIPlantService();
    plantService = PlantService();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    gameStateProvider = Provider.of<GameStateProvider>(context, listen: false);
    gameService = GameService();

    // Lade die vorhandenen Pflanzen des angemeldeten Users und aktualisiere den Provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final plantProvider = Provider.of<PlantProvider>(context, listen: false);
      plantService.getAllPlants(userId: authProvider.userId).then((plantsData) {
        final List<Plant> plants =
            plantsData.map((json) => Plant.fromJson(json)).toList();
        plantProvider.setPlants(plants);
      }).catchError((error) {
        print("Fehler beim Abrufen der Pflanzen: $error");
      });

      // Spielstand vom Backend abrufen
      gameService.getGameData(userId: authProvider.userId).then((gameData) {
        final gameStateData = GameData.fromJson(gameData);
        gameStateProvider.setGameData(gameStateData);
      }).catchError((error) {
        print("Fehler beim Abrufen der Speildaten: $error");
      });

      // Initialisiere hier auch deinen PlantGame und deine Seiten
      setState(() {
        plantGame =
            PlantGame(plantProvider: plantProvider, gameContext: context);
        _pages = [
          const DashboardPage(),
          const PlantOverviewPage(),
          BattlePage(plantGame: plantGame),
          ShopPage(plantGame: plantGame),
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Falls die _pages noch nicht initialisiert wurden, zeige einen Ladeindikator
    if (_pages.isEmpty) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        onPressed: _showPlantNameInputDialog,
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
