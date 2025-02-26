import 'package:flame/components.dart';
import 'package:green_guardian/game/PlantGame.dart';

class HealEffect extends SpriteAnimationComponent with HasGameRef<PlantGame> {
  double _elapsedTime = 0.0;

  HealEffect({Vector2? position})
      : super(
    // Wenn keine Position übergeben wurde, wird später in onLoad unten links gesetzt.
    position: position ?? Vector2.zero(),
    size: Vector2.all(150), // Basisgröße (wird später skaliert)
  );

  @override
  Future<void> onLoad() async {
    final sprites = await Future.wait([
      Sprite.load('other/heal/Heal1.png'),
      Sprite.load('other/heal/Heal2.png'),
      Sprite.load('other/heal/Heal3.png'),
      Sprite.load('other/heal/Heal4.png'),
      Sprite.load('other/heal/Heal5.png'),
      Sprite.load('other/heal/Heal6.png'),
      Sprite.load('other/heal/Heal7.png'),
      Sprite.load('other/heal/Heal8.png'),
      Sprite.load('other/heal/Heal9.png'),
      Sprite.load('other/heal/Heal10.png'),
      Sprite.load('other/heal/Heal11.png'),
    ]);
    animation = SpriteAnimation.spriteList(sprites, stepTime: 0.15, loop: false);

    // Setze die Position unten links, falls nicht schon anders übergeben.
    if (position == Vector2.zero()) {
      position = Vector2(0, gameRef.size.y - size.y * 3 - 150); // Beachte: size.y * Skalierungsfaktor
    }

    // Skaliere den Effekt größer, z. B. 2x
    scale = Vector2.all(3);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsedTime += dt;
    // Berechne die Gesamtdauer der Animation
    final totalDuration = Duration(
      milliseconds: (animation!.frames.fold<double>(
          0.0, (prev, frame) => prev + frame.stepTime) *
          1000)
          .round(),
    );
    if (_elapsedTime >= totalDuration.inMilliseconds / 1000.0) {
      removeFromParent();
    }
  }
}

