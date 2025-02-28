import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:green_guardian/game/PlantGame.dart';
import 'package:green_guardian/game/entities/boss/BossMonster.dart';

class IceSpellEffect extends SpriteAnimationComponent with HasGameRef<PlantGame> {
  double _elapsedTime = 0.0;
  bool _soundPlayed = false;
  bool _damageApplied = false;
  final BossMonster boss;
  final double itemDamage;
  bool _removalScheduled = false;

  IceSpellEffect({
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
      Sprite.load('other/icespell/ice1.png'),
      Sprite.load('other/icespell/ice2.png'),
      Sprite.load('other/icespell/ice3.png'),
      Sprite.load('other/icespell/ice4.png'),
      Sprite.load('other/icespell/ice5.png'),
      Sprite.load('other/icespell/ice6.png'),
      Sprite.load('other/icespell/ice7.png'),
      Sprite.load('other/icespell/ice8.png'),
      Sprite.load('other/icespell/ice9.png'),
      Sprite.load('other/icespell/ice10.png'),
      Sprite.load('other/icespell/ice11.png'),
      Sprite.load('other/icespell/ice12.png'),
      Sprite.load('other/icespell/ice13.png'),
      Sprite.load('other/icespell/ice14.png'),
      Sprite.load('other/icespell/ice15.png'),
      Sprite.load('other/icespell/ice16.png'),
      Sprite.load('other/icespell/ice17.png'),
    ]);
    // Animation ohne Loop
    animation = SpriteAnimation.spriteList(sprites, stepTime: 0.15, loop: false);

    // Setze die Position unten links, falls nicht anders übergeben
    if (position == Vector2.zero()) {
      position = _getVectorBasedOnEnemyType();
    }
  }

  Vector2 _getVectorBasedOnEnemyType() {

    final screenWidth = gameRef.size.x;
    final screenHeight = gameRef.size.y;

    var computedXOffset = screenWidth * boss.xOffsetFactor;
    var computedYOffset = screenHeight * boss.yOffsetFactor;
    var computedScaling = boss.scalingFactor * (screenHeight / screenWidth);

    if (boss.bossName.contains("Feuerdämon")) {
      computedXOffset *= -0.5;
      computedYOffset *= 1.5;
      computedScaling *= 1.25;
    } else if (boss.bossName.contains("Eisgolem")) {
      computedXOffset *= 2;
      computedYOffset *= 0.9;
      computedScaling *= 1.2;
    } else {
      computedXOffset *= 1;
      computedYOffset *= 1;
      computedScaling *= 0.5;
    }

    scale = Vector2.all(computedScaling);
    return Vector2(computedXOffset, computedYOffset);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (animation == null) return;

    if (!_soundPlayed) { //
      FlameAudio.play("icespell.mp3", volume: 0.5);
      _soundPlayed = true;
    }

    _elapsedTime += dt;

    // Berechne die Gesamtdauer der Animation (in Sekunden)
    final totalSeconds = animation!.frames.fold<double>(0.0, (prev, frame) => prev + frame.stepTime);


    if (!_damageApplied && _elapsedTime >= totalSeconds - 1.5) {
      boss.takeDamage(itemDamage);
      _damageApplied = true;
    }

    if (_elapsedTime >= totalSeconds && !_removalScheduled && isMounted) {
      _removalScheduled = true;
      Future.microtask(() {
        if (isMounted) removeFromParent();
      });
    }
  }
}
