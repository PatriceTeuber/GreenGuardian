import 'package:flame/components.dart';
import 'package:green_guardian/game/PlantGame.dart';
import 'ItemEffect.dart';

class HealEffect extends ItemEffect {
  late PlantGame plantGame;
  HealEffect({Vector2? position, required this.plantGame}) : super(plantGame) {
    // Weist die Position und Größe zu – falls keine Position übergeben wurde, wird Vector2.zero() genutzt.
    this.position = position ?? Vector2.zero();
    size = Vector2.all(150);
  }

  @override
  Future<void> onLoad() async {
    final sprites = await Future.wait([
      Sprite.load('other/heal/heal1.png'),
      Sprite.load('other/heal/heal2.png'),
      Sprite.load('other/heal/heal3.png'),
      Sprite.load('other/heal/heal4.png'),
      Sprite.load('other/heal/heal5.png'),
      Sprite.load('other/heal/heal6.png'),
      Sprite.load('other/heal/heal7.png'),
      Sprite.load('other/heal/heal8.png'),
      Sprite.load('other/heal/heal9.png'),
      Sprite.load('other/heal/heal10.png'),
    ]);
    animation = SpriteAnimation.spriteList(sprites, stepTime: 0.15, loop: false);

    // Falls keine Position übergeben wurde (also Vector2.zero()), wird eine Standardposition gesetzt.
    if (this.position == Vector2.zero()) {
      this.position = Vector2(0, gameRef.size.y - size.y * 3 - 50);
    }

    // Skaliere den Effekt, z. B. 3x
    scale = Vector2.all(3);
  }

// Die update()-Logik übernimmt bereits die Elternklasse Effect.
}
