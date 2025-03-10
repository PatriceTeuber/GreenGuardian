import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import '../../PlantGame.dart';

abstract class ItemEffect extends SpriteAnimationComponent with HasGameRef<PlantGame> {
  bool isFinished = false;
  bool _removalScheduled = false;
  double _elapsedTime = 0.0;
  late PlantGame plantGame;

  // Damit Unterklassen den verstrichenen Zeitwert nutzen können
  double get elapsedTime => _elapsedTime;

  ItemEffect(PlantGame game) {
    plantGame = game;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (animation == null) return;

    _elapsedTime += dt;
    final totalSeconds = animation!.frames.fold<double>(
      0.0,
          (prev, frame) => prev + frame.stepTime,
    );

    if (_elapsedTime >= totalSeconds && !_removalScheduled && isMounted) {
      _removalScheduled = true;
      opacity = 0;  // Verstecke den Effekt sofort
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (isMounted) {
          removeFromParent();
          isFinished = true;
        }
      });
    }

  }

  @override
  void render(Canvas canvas) {
    // Wenn die Animation noch nicht geladen ist, nichts rendern.
    if (animation == null) return;

    // Berechne die Gesamtdauer der Animation
    final totalSeconds = animation!.frames.fold<double>(
      0.0,
          (prev, frame) => prev + frame.stepTime,
    );

    // Wenn die Animation beendet ist, nicht rendern (sodass der letzte Frame nicht angezeigt wird)
    if (_elapsedTime >= totalSeconds) return;

    super.render(canvas);
  }
}
