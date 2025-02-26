import 'package:flame/components.dart';
import 'package:green_guardian/game/entities/boss/BossMonster.dart';

class FireDemon extends BossMonster {
  FireDemon({
    double attackDamage = 20,
    required super.level,
    String bossName = "Feuerdämon",
    double xpAmount = 15,
    double health = 200,
    super.xOffset = -200,
    super.yOffset = 100,
    super.scaling = 2,
    super.pixelWidth = 288,
    super.pixelHeight = 160,
  }) : super(
      labelXOffset: 125,
      labelYOffset: 300,
      attackSoundSrc: "fire_attack.mp3",
      deathSoundSrc: "fire_death.mp3",
      attackDamage: attackDamage + level * 1.1,
      health: health + 10 * level,
      bossName: "$bossName LV. $level",
      xpAmount: xpAmount + level * 10
  );

  @override
  Future<void> loadAnimations() async {
    final idleSprites = await Future.wait([
      Sprite.load('boss3/idle/fire_idle1.png'),
      Sprite.load('boss3/idle/fire_idle2.png'),
      Sprite.load('boss3/idle/fire_idle3.png'),
      Sprite.load('boss3/idle/fire_idle4.png'),
      Sprite.load('boss3/idle/fire_idle5.png'),
      Sprite.load('boss3/idle/fire_idle6.png'),
    ]);
    final attackSprites = await Future.wait([
      Sprite.load('boss3/attack/fire_attack1.png'),
      Sprite.load('boss3/attack/fire_attack2.png'),
      Sprite.load('boss3/attack/fire_attack3.png'),
      Sprite.load('boss3/attack/fire_attack4.png'),
      Sprite.load('boss3/attack/fire_attack5.png'),
      Sprite.load('boss3/attack/fire_attack6.png'),
      Sprite.load('boss3/attack/fire_attack7.png'),
      Sprite.load('boss3/attack/fire_attack8.png'),
      Sprite.load('boss3/attack/fire_attack9.png'),
      Sprite.load('boss3/attack/fire_attack10.png'),
      Sprite.load('boss3/attack/fire_attack11.png'),
      Sprite.load('boss3/attack/fire_attack12.png'),
      Sprite.load('boss3/attack/fire_attack13.png'),
      Sprite.load('boss3/attack/fire_attack14.png'),
      Sprite.load('boss3/attack/fire_attack15.png'),
    ]);
    final deathSprites = await Future.wait([
      Sprite.load('boss3/death/fire_death1.png'),
      Sprite.load('boss3/death/fire_death2.png'),
      Sprite.load('boss3/death/fire_death3.png'),
      Sprite.load('boss3/death/fire_death4.png'),
      Sprite.load('boss3/death/fire_death5.png'),
      Sprite.load('boss3/death/fire_death6.png'),
      Sprite.load('boss3/death/fire_death7.png'),
      Sprite.load('boss3/death/fire_death8.png'),
      Sprite.load('boss3/death/fire_death9.png'),
      Sprite.load('boss3/death/fire_death10.png'),
      Sprite.load('boss3/death/fire_death11.png'),
      Sprite.load('boss3/death/fire_death12.png'),
      Sprite.load('boss3/death/fire_death13.png'),
      Sprite.load('boss3/death/fire_death14.png'),
      Sprite.load('boss3/death/fire_death15.png'),
      Sprite.load('boss3/death/fire_death16.png'),
      Sprite.load('boss3/death/fire_death17.png'),
      Sprite.load('boss3/death/fire_death18.png'),
      Sprite.load('boss3/death/fire_death19.png'),
      Sprite.load('boss3/death/fire_death20.png'),
      Sprite.load('boss3/death/fire_death21.png'),
      Sprite.load('boss3/death/fire_death22.png'),
    ]);
    final takeHitSprites = await Future.wait([
      Sprite.load('boss3/take_hit/fire_take_hit1.png'),
      Sprite.load('boss3/take_hit/fire_take_hit2.png'),
      Sprite.load('boss3/take_hit/fire_take_hit3.png'),
      Sprite.load('boss3/take_hit/fire_take_hit4.png'),
      Sprite.load('boss3/take_hit/fire_take_hit5.png'),
    ]);

    idleAnimation = SpriteAnimation.spriteList(idleSprites, stepTime: 0.2);
    attackAnimation = SpriteAnimation.spriteList(attackSprites, stepTime: 0.1, loop: false);
    deathAnimation = SpriteAnimation.spriteList(deathSprites, stepTime: 0.15, loop: false);
    damageAnimation = SpriteAnimation.spriteList(takeHitSprites, stepTime: 0.125, loop: false);
  }
}