import 'dart:async';

import 'package:flame/game.dart';
import 'package:green_guardian/game/BattleBackground.dart';
import 'package:green_guardian/game/entities/boss/BossOne.dart';

import 'entities/HousePlant.dart';

class PlantGame extends FlameGame {

  List<HousePlant> plants = [];
  int playerHealth = 100;
  int currency = 0;

  Timer? wateringCheckTimer;

  @override
  Future<void> onLoad() async {

    //Hintergrund
    await add(BattleBackground());

    //Boss
    // Erstelle eine Instanz des BossMonster
    final boss = BossOne();
    // Füge den Boss dem Spiel hinzu
    add(boss);

    // Beispielhafte Initialisierung von Pflanzen.
    // In der Produktion ersetzt du dies durch die dynamische Registrierung der Pflanzen.
    plants.add(HousePlant(
      name: "Ficus",
      lastWatered: DateTime.now(),
      wateringInterval: const Duration(seconds: 10), // Simuliert 1 Woche als 10 Sekunden
    ));
    plants.add(HousePlant(
      name: "Aloe",
      lastWatered: DateTime.now(),
      wateringInterval: const Duration(seconds: 15),
    ));

    // Starte einen Timer, der jede Sekunde den Gieß-Status aller Pflanzen überprüft.
    wateringCheckTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      checkWateringStatus();
    });
  }

  // Überprüft, ob alle Pflanzen rechtzeitig gegossen wurden.
  void checkWateringStatus() {
    for (var plant in plants) {
      // Falls eine Pflanze nicht innerhalb des Intervalls gegossen wurde, greift der Boss an.
      if (!plant.isWatered) {
        bossAttack(plant);
      }
    }
  }

  // Methode, um eine spezifische Pflanze zu gießen.
  void waterPlant(String plantName) {
    for (var plant in plants) {
      if (plant.name == plantName) {
        plant.water();
        currency += 10; // Belohnung für erfolgreiches Gießen
        print('${plant.name} wurde gegossen! Währung: $currency');
      }
    }
  }

  // Der Boss greift an, wenn eine Pflanze überfällig ist.
  void bossAttack(HousePlant plant) {
    // Angriff nur einmal pro versäumtem Gießen
    if (!plant.attacked) {
      playerHealth -= 10;
      plant.attacked = true;
      print('Boss greift an, da ${plant.name} nicht rechtzeitig gegossen wurde. Spieler HP: $playerHealth');
    }
  }


}