import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:green_guardian/game/entities/boss/BossMonster.dart';
import '../../PlantGame.dart';
import 'ItemEffect.dart'; // Passe den Importpfad an

class ExplosionItemEffect extends ItemEffect {
  final BossMonster boss;
  final double itemDamage;
  bool _soundPlayed = false;
  bool _damageApplied = false;
  late PlantGame plantGame;

  ExplosionItemEffect({
    Vector2? position,
    required this.boss,
    required this.itemDamage,
    required this.plantGame,
  }) : super(plantGame) {
    // Setze Position und Größe im Konstruktor, da die Elternklasse keinen benannten Konstruktor hat
    this.position = position ?? Vector2.zero();
    this.size = Vector2.all(150);
  }

  @override
  Future<void> onLoad() async {
    final sprites = await Future.wait([
      Sprite.load('other/explosion/explosion1.png'),
      Sprite.load('other/explosion/explosion2.png'),
      Sprite.load('other/explosion/explosion3.png'),
      Sprite.load('other/explosion/explosion4.png'),
      Sprite.load('other/explosion/explosion5.png'),
      Sprite.load('other/explosion/explosion6.png'),
      Sprite.load('other/explosion/explosion7.png'),
      Sprite.load('other/explosion/explosion8.png'),
      Sprite.load('other/explosion/explosion9.png'),
      Sprite.load('other/explosion/explosion10.png'),
      Sprite.load('other/explosion/explosion11.png'),
      Sprite.load('other/explosion/explosion12.png'),
      Sprite.load('other/explosion/explosion13.png'),
    ]);
    // Erstelle die Animation ohne Loop
    animation = SpriteAnimation.spriteList(sprites, stepTime: 0.15, loop: false);

    // Falls keine Position übergeben wurde, berechne eine anhand des Gegners
    if (position == Vector2.zero()) {
      position = _getVectorBasedOnEnemyType();
    }
    // Skaliere den Effekt, z. B. 3x größer
    scale = Vector2.all(3);
  }

  Vector2 _getVectorBasedOnEnemyType() {
    if (boss.bossName.contains("Feuerdämon")) {
      return Vector2(boss.position.x - 10, boss.position.y - 20);
    } else if (boss.bossName.contains("Eisgolem")) {
      return Vector2(boss.position.x - 50, boss.position.y - 80);
    } else {
      return Vector2(boss.position.x - 120, boss.position.y - 100);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (animation == null) return;

    // Berechne die Gesamtdauer der Animation
    final totalSeconds = animation!.frames.fold<double>(
      0.0,
          (prev, frame) => prev + frame.stepTime,
    );

    // Sound abspielen, wenn kurz vor Ende der Animation
    if (!_soundPlayed && elapsedTime >= totalSeconds - 1) {
      FlameAudio.play("explosion.mp3", volume: 0.5);
      _soundPlayed = true;
    }

    // Schaden zufügen, wenn kurz vor Ende der Animation
    if (!_damageApplied && elapsedTime >= totalSeconds - 0.5) {
      boss.takeDamage(itemDamage);
      _damageApplied = true;
    }
    // Das Entfernen der Komponente erfolgt bereits in Effect.update()
  }
}
