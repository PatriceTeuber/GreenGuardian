import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:green_guardian/game/entities/boss/BossMonster.dart';
import '../../PlantGame.dart';
import 'ItemEffect.dart';

class WindSpellEffect extends ItemEffect {
  bool _soundPlayed = false;
  bool _damageApplied = false;
  final BossMonster boss;
  final double itemDamage;
  late PlantGame plantGame;

  WindSpellEffect({
    Vector2? position,
    required this.boss,
    required this.itemDamage,
    required this.plantGame,
  }) : super(plantGame) {
    this.position = position ?? Vector2.zero();
    size = Vector2.all(150);
  }

  @override
  Future<void> onLoad() async {
    final sprites = await Future.wait([
      Sprite.load('other/windspell/air1.png'),
      Sprite.load('other/windspell/air2.png'),
      Sprite.load('other/windspell/air3.png'),
      Sprite.load('other/windspell/air4.png'),
      Sprite.load('other/windspell/air5.png'),
      Sprite.load('other/windspell/air6.png'),
      Sprite.load('other/windspell/air7.png'),
      Sprite.load('other/windspell/air8.png'),
      Sprite.load('other/windspell/air9.png'),
      Sprite.load('other/windspell/air10.png'),
      Sprite.load('other/windspell/air11.png'),
      Sprite.load('other/windspell/air12.png'),
      Sprite.load('other/windspell/air13.png'),
      Sprite.load('other/windspell/air14.png'),
      Sprite.load('other/windspell/air15.png'),
      Sprite.load('other/windspell/air16.png'),
      Sprite.load('other/windspell/air17.png'),
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

    // Spielt den Sound nur einmal ab
    if (!_soundPlayed) {
      FlameAudio.play("windspell.wav", volume: 0.5);
      _soundPlayed = true;
    }

    // Gesamtdauer der Animation
    final totalSeconds = animation!.frames.fold<double>(
      0.0,
          (prev, frame) => prev + frame.stepTime,
    );

    // Schaden zufügen, wenn kurz vor dem Ende der Animation
    if (!_damageApplied && elapsedTime >= totalSeconds - 1.5) {
      boss.takeDamage(itemDamage);
      _damageApplied = true;
    }
    // Der Aufruf von removeFromParent() wird bereits in Effect.update() erledigt.
  }
}
