import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:green_guardian/game/entities/boss/Crow.dart';
import 'package:green_guardian/game/entities/boss/FireDemon.dart';
import 'package:green_guardian/game/entities/effects/IceSpellEffect.dart';
import 'package:green_guardian/game/entities/effects/ItemEffect.dart';
import 'package:green_guardian/game/entities/effects/WindSpellEffect.dart';
import 'package:green_guardian/game/entities/items/BerryItem.dart';
import 'package:green_guardian/game/entities/overlays/BattleBackground.dart';
import 'package:green_guardian/game/entities/HealthBar.dart';
import 'package:green_guardian/game/entities/boss/IceGolem.dart';
import 'package:green_guardian/game/entities/effects/ExplosionItemEffect.dart';
import 'package:green_guardian/game/entities/effects/HealEffect.dart';
import 'package:green_guardian/models/plant.dart';
import 'package:provider/provider.dart';

import '../services/GameStateProvider.dart';
import '../services/PlantProvider.dart';
import 'entities/items/Item.dart';
import 'entities/boss/BossMonster.dart';


class PlantGame extends FlameGame {

  bool _loaded = false;

  final PlantProvider plantProvider;
  double playerHealth = 100;
  double maxPlayerHealth = 100;
  int currency = 0;
  double lastXPEarned = 0;
  double playerXP = 0;
  late BossMonster currentBoss;
  late BossMonster bossBlueprint;
  int bossCounter = 0;
  final BuildContext gameContext;

  Timer? wateringCheckTimer;

  late HealthBar bossHealthBar;
  late HealthBar playerHealthBar;

  List<Item> inventory = [];

  List<ItemEffect> destroyEffectList = [];



  PlantGame({required this.plantProvider, required this.gameContext});

  @override
  Future<void> onLoad() async {

    final gameState = Provider.of<GameStateProvider>(gameContext, listen: false);

    //Stand laden
    print("=====================================");
    print("=====================================");
    print("=====================================");
    inventory.addAll(gameState.items);
    getSavedBoss(gameState.bossLevel, gameState.bossHealth, gameState.bossName);
    currency = gameState.currency;
    playerXP = gameState.playerXP;
    playerHealth = gameState.playerHealth;
    maxPlayerHealth = gameState.maxPlayerHealth;
    print("=====================================");
    print("=====================================");
    print("=====================================");

    //Hintergrund
    await add(BattleBackground());

    add(currentBoss);

    await currentBoss.onLoaded;
    //Lebensanzeigen:
    bossHealthBar = HealthBar(
      currentHealth: currentBoss.health.toDouble(),
      maxHealth: currentBoss.maxHealth,
      position: Vector2(currentBoss.labelXOffset, currentBoss.labelYOffset),
      size: Vector2(200, 30),
      label: currentBoss.bossName
    );
    add(bossHealthBar);

    // Spieler-HealthBar
    playerHealthBar = HealthBar(
      currentHealth: playerHealth.toDouble(),
      maxHealth: maxPlayerHealth,
      position: Vector2(20, 60),
      size: Vector2(300, 30),
      fillColor: const Color(0xFFFFFF00),
      label: "HP Spieler"
    );
    add(playerHealthBar);

    // Starte einen Timer, der jede Sekunde den Gieß-Status aller Pflanzen überprüft.
    wateringCheckTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      checkWateringStatus();
    });

    _loaded = true;
  }

  // Überprüft, ob alle Pflanzen rechtzeitig gegossen wurden.
  void checkWateringStatus() {
    for (var plant in plantProvider.plants) {
      // Greift nur an, wenn die Pflanze überfällig ist
      if (plant.isOverdue) {
        bossAttack(plant);
      }
    }
  }

  // Der Boss greift an, wenn eine Pflanze überfällig ist.
  void bossAttack(Plant plant) {
    // Angriff nur einmal pro versäumtem Gießen
    if (!plant.attacked) {
      playerHealth -= currentBoss.attackDamage;
      plant.attacked = true;
      currentBoss.attack();
      print('Boss greift an, da ${plant.plantInfo.name} nicht rechtzeitig gegossen wurde. Spieler HP: $playerHealth');
    }
  }

  void bossTakeDamage(double damage) {
    currentBoss.takeDamage(damage);
  }


  Future<void> useItem(Item item) async {
    if (item.effect == 'Heilt') {
      playerHealth += (item.value + item.randomAddition);
      if (playerHealth > 100) playerHealth = 100;
      FlameAudio.play("heal.mp3");
      final effect = HealEffect(plantGame: this);
      add(effect);

      print('Spieler wird geheilt: $playerHealth/100');
    } else if (item.effect == 'Boss-Schaden') {

      final effect = ExplosionItemEffect(boss: currentBoss, itemDamage: item.value + item.randomAddition, plantGame: this);
      add(effect);

    } else if (item.effect == "Boss-Ice-Damage") {
      final effect = IceSpellEffect(boss: currentBoss, itemDamage: item.value + item.randomAddition, plantGame: this);
      add(effect);
    } else if (item.effect == "Boss-Wind-Damage") {
      final effect = WindSpellEffect(boss: currentBoss, itemDamage: item.value + item.randomAddition, plantGame: this);
      add(effect);
    }

    inventory.remove(item);
  }

  void nextBoss() {
    currentBoss = _getRandomBoss();
    bossBlueprint = currentBoss;
    add(currentBoss);

    _resetBossHealthBar();
  }

  BossMonster _getRandomBoss() {
    final random = Random();

    int monsterIndex = random.nextInt(3);
    int level = random.nextInt(10);
    if (monsterIndex == 0) {
      return IceGolem(level: level);
    } else if (monsterIndex == 1) {
      return Crow(level: level);
    } else {
      return FireDemon(level: level);
    }
  }

  void getSavedBoss(int bossLevel, double bossHealth, String bossName) {
    print(bossName + " " + bossHealth.toString() + " " + bossLevel.toString());
    if (bossName.contains("Feuerdämon")) {
      currentBoss = FireDemon.byDatabase(level: bossLevel, health: bossHealth);
      bossBlueprint = FireDemon(level: bossLevel);
    } else if (bossName.contains("Eisgolem")) {
      currentBoss = IceGolem.byDatabase(level: bossLevel, health: bossHealth);
      bossBlueprint = IceGolem(level: bossLevel);
    } else if (bossName.contains("Crow")) {
      currentBoss = Crow.byDatabase(level: bossLevel, health: bossHealth);
      bossBlueprint = Crow(level: bossLevel);
    } else {
      //Boss
      currentBoss = FireDemon(level: 1);
      bossBlueprint = currentBoss;
    }
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

    for (ItemEffect effect in List.from(destroyEffectList)) {
      effect.removeFromParent();
      destroyEffectList.remove(effect);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gameState = Provider.of<GameStateProvider>(gameContext, listen: false);
      gameState.updatePlayerHealth(playerHealth);
      gameState.updateCurrency(currency);
      gameState.updatePlayerXP(playerXP);
      gameState.updateBossHealth(currentBoss.health.toDouble());
      gameState.updateItmes(inventory);
      gameState.updateBoss(currentBoss.level, currentBoss.bossName);
    });
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    if (!_loaded) return;

    // Beispiel: Neuberechnung der Positionswerte
    final isLandscape = size.x > size.y;

    // Passe hier dynamisch Parameter an:
    // - Offset-Werte für Boss und HealthBars
    // - Skalierungsfaktoren etc.

    if (kIsWeb) {
      const double spacing = 20.0; // Abstand zwischen den Healthbars
      const double topMargin = 50.0; // Abstand vom oberen Rand
      const double leftMargin = 20.0; // Abstand vom linken Rand

      // Setze die Position der Player-Healthbar
      playerHealthBar.position = Vector2(leftMargin, topMargin);

      // Berechne die Position der Boss-Healthbar rechts neben der Player-Healthbar
      bossHealthBar.position = Vector2(
        leftMargin + playerHealthBar.size.x + spacing,
        topMargin,
      );

      currentBoss.scale = Vector2.all(1.5);
      currentBoss.position = Vector2(size.x / 3, size.y / 2);

    } else {
      if (isLandscape) {
        currentBoss.scale = Vector2.all(1.5);
        currentBoss.position = Vector2(size.x / 3, size.y / 6);
        bossHealthBar.position = Vector2(currentBoss.labelXOffset, currentBoss.labelYOffset);
      } else {
        currentBoss.scale = bossBlueprint.scale;
        currentBoss.position = bossBlueprint.position;
      }
    }
  }


  Future<void> loadSounds() async {
    await FlameAudio.audioCache.load('heal.mp3');
    await FlameAudio.audioCache.load('golem_attack.mp3');
    await FlameAudio.audioCache.load('explosion.mp3');
    await FlameAudio.audioCache.load('golem_death.mp3');
    await FlameAudio.audioCache.load('crow_death.wav');
    await FlameAudio.audioCache.load('crow_attack.mp3');
    await FlameAudio.audioCache.load('player_lose.mp3');
    await FlameAudio.audioCache.load('fire_attack.mp3');
    await FlameAudio.audioCache.load('fire_death.mp3');
    await FlameAudio.audioCache.load('icespell.mp3');
    await FlameAudio.audioCache.load('windspell.wav');
  }
}