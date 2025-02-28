import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import '../../PlantGame.dart';

abstract class Effect extends SpriteAnimationComponent with HasGameRef<PlantGame> {
  bool isFinished = false;
  bool _removalScheduled = false;
  double _elapsedTime = 0.0;

  // Damit Unterklassen den verstrichenen Zeitwert nutzen können
  double get elapsedTime => _elapsedTime;

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
      // Entferne den Effekt direkt nach dem aktuellen Frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (isMounted) {
          removeFromParent();
          isFinished = true;
        }
      });
    }
  }
}
