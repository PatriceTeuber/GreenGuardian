import 'package:flame/components.dart';
import 'package:green_guardian/game/PlantGame.dart';

class BattleBackground extends SpriteComponent with HasGameRef<PlantGame> {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('Background.webp');
    // Setze den Anchor auf die Mitte, um den Hintergrund leichter zentrieren zu können
    anchor = Anchor.center;
    // Initiale Anpassung der Größe
    onGameResize(gameRef.size);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    // Berechne die Skalierungsfaktoren, damit das Bild immer den Bildschirm ausfüllt.
    final scaleX = size.x / sprite!.srcSize.x;
    final scaleY = size.y / sprite!.srcSize.y;
    // Verwende z. B. den größeren Faktor für ein "cover"-Verhalten:
    final scaleFactor = scaleX > scaleY ? scaleX : scaleY;
    this.size = sprite!.srcSize * scaleFactor;
    // Positioniere den Hintergrund in der Bildschirmmitte
    position = size / 2;
  }
}
