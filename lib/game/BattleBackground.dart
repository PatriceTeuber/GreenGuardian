import 'package:flame/components.dart';
import 'package:green_guardian/game/PlantGame.dart';


class BattleBackground extends SpriteComponent with HasGameRef<PlantGame> {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('Background.webp');
    size = gameRef.size;
    anchor = Anchor.topLeft;
  }
}
