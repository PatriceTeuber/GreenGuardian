import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:green_guardian/game/PlantGame.dart';
import 'package:green_guardian/game/entities/boss/BossMonster.dart';

class ExplosionItemEffect extends SpriteAnimationComponent with HasGameRef<PlantGame> {
  double _elapsedTime = 0.0;
  bool _soundPlayed = false;
  bool _damageApplied = false;
  final BossMonster boss;
  final double itemDamage;

  ExplosionItemEffect({
    Vector2? position,
    required this.boss,
    required this.itemDamage,
  }) : super(
    position: position ?? Vector2.zero(),
    size: Vector2.all(150),
  );

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
    // Animation ohne Loop
    animation = SpriteAnimation.spriteList(sprites, stepTime: 0.15, loop: false);

    // Setze die Position unten links, falls nicht anders übergeben
    if (position == Vector2.zero()) {
      position = _getVectorBasedOnEnemyType();
    }
    // Skaliere den Effekt (z. B. 3x größer)
    scale = Vector2.all(3);
  }

  Vector2 _getVectorBasedOnEnemyType() {
    if (boss.bossName.contains("Feuerdämon")) {
      return Vector2(boss.position.x - 10, boss.position.y - 20);
    } else if (boss.bossName.contains("Eisgolem")) {
      return Vector2(boss.position.x - 50, boss.position.y - 80);
    } else {
      return Vector2(boss.position.x - 120, boss.position.y-100);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsedTime += dt;

    // Berechne die Gesamtdauer der Animation (in Sekunden)
    final totalSeconds = animation!.frames.fold<double>(0.0, (prev, frame) => prev + frame.stepTime);

    // Trigger Explosion-Sound 200ms vor Ende der Animation:
    if (!_soundPlayed && _elapsedTime >= totalSeconds - 1) {
      FlameAudio.play("explosion.mp3", volume: 0.5);
      _soundPlayed = true;
    }

    // Wende Schaden ca. 100ms nach dem Sound (also kurz vor Ende) an:
    if (!_damageApplied && _elapsedTime >= totalSeconds - 0.5) {
      boss.takeDamage(itemDamage);
      _damageApplied = true;
    }

    // Entferne den Effekt, wenn die Animation vollständig abgespielt wurde.
    if (_elapsedTime >= totalSeconds) {
      removeFromParent();
    }
  }
}
