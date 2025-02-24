import 'package:flame/components.dart';

import '../../PlantGame.dart';

abstract class BossMonster extends SpriteAnimationComponent with HasGameRef<PlantGame> {
  int health;
  bool isAttacking = false;
  bool isTakingDamage = false;
  bool isDying = false;
  double xOffset;
  double yOffset;
  double scaling;
  int pixelHeight;
  int pixelWidth;

  late SpriteAnimation idleAnimation;
  late SpriteAnimation attackAnimation;
  late SpriteAnimation damageAnimation;
  late SpriteAnimation deathAnimation;

  BossMonster({
    this.health = 100,
    this.xOffset = 0,
    this.yOffset = 0,
    this.scaling = 0,
    this.pixelWidth = 192,
    this.pixelHeight = 128,
  }) : super(size: Vector2(pixelWidth.toDouble(), pixelHeight.toDouble()));

  @override
  Future<void> onLoad() async {
    await loadAnimations(); // Kindklasse muss diese Methode implementieren
    // Setze den initialen Zustand auf idle.
    animation = idleAnimation;
    xOffset += (size.x/2);
    yOffset += (size.x/2);
    // Optionale Standardpositionierung, kann auch von außen gesetzt werden.
    position = Vector2(xOffset.roundToDouble(), yOffset.roundToDouble());
    scale = Vector2.all(scaling);
  }

  // Diese abstrakte Methode wird von den Kindklassen implementiert, um Animationen zu laden.
  Future<void> loadAnimations();

  // Gemeinsame Methoden, z. B. idle, attack, takeDamage, die:
  void idle() {
    if (!isDying && !isAttacking && !isTakingDamage) {
      _setAnimation(idleAnimation);
    }
  }

  void attack() {
    if (!isDying && !isAttacking && !isTakingDamage) {
      isAttacking = true;
      _setAnimation(attackAnimation);
      print('Boss greift an!');
      Future.delayed(attackAnimation.totalDuration, () {
        isAttacking = false;
        idle();
      });
    }
  }

  void takeDamage(int damage) {
    if (isDying) return;
    health -= damage;
    print('Boss nimmt $damage Schaden. Verbleibende HP: $health');
    if (health > 0) {
      isTakingDamage = true;
      _setAnimation(damageAnimation);
      Future.delayed(damageAnimation.totalDuration, () {
        isTakingDamage = false;
        idle();
      });
    } else {
      die();
    }
  }

  void die() {
    if (!isDying) {
      isDying = true;
      _setAnimation(deathAnimation);
      Future.delayed(deathAnimation.totalDuration, () {
        print('Boss ist besiegt!');
        removeFromParent();
      });
    }
  }

  // Hilfsmethode zum Wechseln der Animation
  void _setAnimation(SpriteAnimation newAnimation) {
    if (animation != newAnimation) {
      animation = newAnimation;
    }
  }
}

extension SpriteAnimationExtension on SpriteAnimation {
  Duration get totalDuration {
    final totalSeconds = frames.fold<double>(0.0, (prev, frame) => prev + frame.stepTime);
    return Duration(milliseconds: (totalSeconds * 1000).round());
  }
}
