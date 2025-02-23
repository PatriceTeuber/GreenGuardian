import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:green_guardian/game/PlantGame.dart';

class BossMonster extends SpriteAnimationComponent with HasGameRef<PlantGame> {
  int health;
  bool isAttacking = false;
  bool isTakingDamage = false;
  bool isDying = false;

  late SpriteAnimation idleAnimation;
  late SpriteAnimation attackAnimation;
  late SpriteAnimation damageAnimation;
  late SpriteAnimation deathAnimation;

  BossMonster({this.health = 100})
      : super(size: Vector2(192, 128)); // Beispielgröße

  @override
  Future<void> onLoad() async {
    final idleSprites = await Future.wait([
      Sprite.load('boss1/idle/idle_1.png'),
      Sprite.load('boss1/idle/idle_2.png'),
      Sprite.load('boss1/idle/idle_3.png'),
      Sprite.load('boss1/idle/idle_4.png'),
      Sprite.load('boss1/idle/idle_5.png'),
      Sprite.load('boss1/idle/idle_6.png'),
    ]);
    // Lade die Animationen – stelle sicher, dass die Bilder in deinem assets/images-Ordner liegen.
    idleAnimation = SpriteAnimation.spriteList(idleSprites, stepTime: 0.25);



    // Setze den initialen Zustand auf idle.
    animation = idleAnimation;

    // Positioniere den Boss in der Mitte des Bildschirms.
    double x = (size.x/2)-100;
    double y = (size.y/2)+200;
    position = Vector2(x.roundToDouble(), y.roundToDouble());
    scale = Vector2.all(2.5);
  }

  // Hilfsmethode zum Wechseln der Animation
  void _setAnimation(SpriteAnimation newAnimation) {
    // Setze die Animation neu, falls sie nicht bereits aktiv ist.
    if (animation != newAnimation) {
      animation = newAnimation;
    }
  }

  // Idle-Zustand: Boss macht nichts und zeigt die Idle-Animation.
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
}

extension SpriteAnimationExtension on SpriteAnimation {
  Duration get totalDuration {
    // Summiere alle stepTime-Werte (als Sekunden) und konvertiere in Duration.
    final totalSeconds = frames.fold<double>(0.0, (prev, frame) => prev + frame.stepTime);
    return Duration(milliseconds: (totalSeconds * 1000).round());
  }
}
