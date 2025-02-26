import 'dart:async';
import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:green_guardian/game/entities/overlays/BattleBackground.dart';
import 'package:green_guardian/game/entities/HealthBar.dart';
import 'package:green_guardian/game/entities/boss/BossOne.dart';
import 'package:green_guardian/game/entities/effects/ExplosionItemEffect.dart';
import 'package:green_guardian/game/entities/effects/HealEffect.dart';

import 'entities/Item.dart';
import 'entities/HousePlant.dart';
import 'entities/boss/BossMonster.dart';


class PlantGame extends FlameGame {

  List<HousePlant> plants = [];
  double playerHealth = 100;
  int currency = 0;
  double lastXPEarned = 0;
  late BossMonster currentBoss;
  late BossMonster bossBlueprint;
  int bossCounter = 0;

  Timer? wateringCheckTimer;

  late HealthBar bossHealthBar;
  late HealthBar playerHealthBar;

  List<Item> inventory = [];

  @override
  Future<void> onLoad() async {

    //Hintergrund
    await add(BattleBackground());

    //Boss
    currentBoss = BossOne(bossName: "Eisgolem", level: 2);
    add(currentBoss);

    //Lebensanzeigen:
    bossHealthBar = HealthBar(
      currentHealth: currentBoss.health.toDouble(),
      maxHealth: currentBoss.health,
      position: Vector2(currentBoss.position.x - currentBoss.xOffset + 40, currentBoss.position.y + currentBoss.yOffset + 100),
      size: Vector2(200, 30),
      label: currentBoss.bossName
    );
    add(bossHealthBar);

    // Spieler-HealthBar
    playerHealthBar = HealthBar(
      currentHealth: playerHealth.toDouble(),
      maxHealth: 100,
      position: Vector2(20, 60),
      size: Vector2(300, 30),
      fillColor: const Color(0xFFFFFF00),
      label: "HP Spieler"
    );
    add(playerHealthBar);

    // Beispielhafte Initialisierung von Pflanzen.
    // In der Produktion ersetzt du dies durch die dynamische Registrierung der Pflanzen.
    plants.add(HousePlant(
      name: "Ficus",
      lastWatered: DateTime.now(),
      wateringInterval: Duration(seconds: 10), // Simuliert 1 Woche als 10 Sekunden
    ));
    plants.add(HousePlant(
      name: "Ficus",
      lastWatered: DateTime.now(),
      wateringInterval: Duration(seconds: 2), // Simuliert 1 Woche als 10 Sekunden
    ));
    plants.add(HousePlant(
      name: "Ficus",
      lastWatered: DateTime.now(),
      wateringInterval: Duration(seconds: 20), // Simuliert 1 Woche als 10 Sekunden
    ));
    plants.add(HousePlant(
      name: "Ficus",
      lastWatered: DateTime.now(),
      wateringInterval: Duration(seconds: 15), // Simuliert 1 Woche als 10 Sekunden
    ));
    plants.add(HousePlant(
      name: "Ficus",
      lastWatered: DateTime.now(),
      wateringInterval: Duration(seconds: 5), // Simuliert 1 Woche als 10 Sekunden
    ));
    plants.add(HousePlant(
      name: "Ficus",
      lastWatered: DateTime.now(),
      wateringInterval: Duration(seconds: 12), // Simuliert 1 Woche als 10 Sekunden
    ));
    plants.add(HousePlant(
      name: "Ficus",
      lastWatered: DateTime.now(),
      wateringInterval: Duration(seconds: 30), // Simuliert 1 Woche als 10 Sekunden
    ));

    // Starte einen Timer, der jede Sekunde den Gieß-Status aller Pflanzen überprüft.
    wateringCheckTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      checkWateringStatus();
    });

    // Beispiel: Füge ein paar Items ins Inventar ein
    inventory.addAll([
      Item(
        name: 'Beere',
        assetPath: 'assets/images/items/Berry.png',
        effect: 'Heilt',
        value: 20,
      ),
      Item(
        name: 'Bombe',
        assetPath: 'assets/images/items/defaultBomb.png',
        effect: 'Boss-Schaden',
        value: 50,
      ),
      Item(
        name: 'Bombe',
        assetPath: 'assets/images/items/defaultBomb.png',
        effect: 'Boss-Schaden',
        value: 200,
      ),
      Item(
        name: 'Bombe',
        assetPath: 'assets/images/items/defaultBomb.png',
        effect: 'Boss-Schaden',
        value: 40,
      ),
      Item(
        name: 'Bombe',
        assetPath: 'assets/images/items/defaultBomb.png',
        effect: 'Boss-Schaden',
        value: 150,
      ),
      Item(
        name: 'Bombe',
        assetPath: 'assets/images/items/defaultBomb.png',
        effect: 'Boss-Schaden',
        value: 1000,
      ),
    ]);
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
      FlameAudio.play("boss_attack.mp3", volume: 100);
      playerHealth -= currentBoss.attackDamage;
      plant.attacked = true;
      currentBoss.attack();
      print('Boss greift an, da ${plant.name} nicht rechtzeitig gegossen wurde. Spieler HP: $playerHealth');
    }
  }

  void bossTakeDamage(double damage) {
    currentBoss.takeDamage(damage);
  }


  Future<void> useItem(Item item) async {
    if (item.effect == 'Heilt') {
      playerHealth += item.value;
      if (playerHealth > 100) playerHealth = 100;

      FlameAudio.play("heal.mp3");
      final effect = HealEffect();
      add(effect);

      print('Spieler wird geheilt: $playerHealth/100');
    } else if (item.effect == 'Boss-Schaden') {

      final effect = ExplosionItemEffect();
      add(effect);
      await Future.delayed(currentBoss.damageAnimation.totalDuration);
      FlameAudio.play("explosion.mp3");
      currentBoss.takeDamage(item.value);

      print('Boss erhält ${item.value} Schaden!');
    }
    inventory.remove(item);
  }

  void nextBoss() {
    //TODO: Boss Typen hinzufügen dann random Boss. Schauen wie mit Level
    currentBoss = BossOne(bossName: "Testatze", level: 30);
    bossBlueprint = currentBoss;
    add(currentBoss);

    _resetBossHealthBar();
  }

  void resetCurrentBoss() {
    // Entferne den alten Boss (falls nötig) und erstelle einen neuen
    // Beispiel: Setze currentBoss neu und aktualisiere die HealthBar
    currentBoss.removeFromParent();
    currentBoss = bossBlueprint;
    add(currentBoss);
    _resetBossHealthBar();
    bossCounter = 0;
  }


  void _resetBossHealthBar() {
    bossHealthBar.currentHealth = currentBoss.health.toDouble();
    bossHealthBar.maxHealth = currentBoss.health.toDouble();
    bossHealthBar.label = currentBoss.bossName;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (playerHealth <= 0 && !overlays.isActive('LoseScreen')) {
      // Spieler verloren – zeige LoseScreen
      overlays.add('LoseScreen');
    }
    if (playerHealth.toDouble() < 0) {
      playerHealthBar.currentHealth = 0;
    } else {
      playerHealthBar.currentHealth = playerHealth.toDouble();
    }
    if (currentBoss.health.toDouble() < 0) {
      bossHealthBar.currentHealth = 0;
    } else {
      bossHealthBar.currentHealth = currentBoss.health.toDouble();
    }

  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Rendering der Spielkomponenten (Pflanzen, Lebensanzeigen, Items etc.) erfolgt hier.
  }

  Future<void> loadSounds() async {
    await FlameAudio.audioCache.load('heal.mp3');
    await FlameAudio.audioCache.load('boss_attack.mp3');
    await FlameAudio.audioCache.load('explosion.mp3');
  }
}