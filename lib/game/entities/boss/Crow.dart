import 'package:flame/components.dart';
import 'package:green_guardian/game/entities/boss/BossMonster.dart';

class Crow extends BossMonster {
  Crow({
    double attackDamage = 15,
    required int level,
    String bossName = "Crow",
    double xpAmount = 7,
    double health = 100,
    double xOffsetFactor = 0.16,
    double yOffsetFactor = 0.35,
    double scalingFactor = 2.25,
    int pixelWidth = 64,
    int pixelHeight = 64,
  }) : super(
      labelXOffsetFactor: 0.35,
      labelYOffsetFactor: 0.4,
      attackSoundSrc: "crow_attack.mp3",
      deathSoundSrc: "crow_death.wav",
      attackDamage: attackDamage + level * 1.5,
      health: health + 5 * level,
      maxHealth: (100 + 5 * level).toDouble(),
      xOffsetFactor: xOffsetFactor,
      yOffsetFactor: yOffsetFactor,
      scalingFactor: scalingFactor,
      pixelWidth: pixelWidth,
      pixelHeight: pixelHeight,
      bossName: "$bossName LV. $level",
      level: level,
      xpAmount: xpAmount + level * 5
  );

  Crow.byDatabase({
    double attackDamage = 15,
    required int level,
    String bossName = "Crow",
    double xpAmount = 7,
    required super.health,
    double xOffsetFactor = 0.16,
    double yOffsetFactor = 0.35,
    double scalingFactor = 2.25,
    int pixelWidth = 64,
    int pixelHeight = 64,
  }) : super(
      labelXOffsetFactor: 0.35,
      labelYOffsetFactor: 0.4,
      attackSoundSrc: "crow_attack.mp3",
      deathSoundSrc: "crow_death.wav",
      attackDamage: attackDamage + level * 1.5,
      xOffsetFactor: xOffsetFactor,
      yOffsetFactor: yOffsetFactor,
      scalingFactor: scalingFactor,
      pixelWidth: pixelWidth,
      pixelHeight: pixelHeight,
      bossName: "$bossName LV. $level",
      level: level,
      xpAmount: xpAmount + level * 5,
      maxHealth: (100 + 5 * level).toDouble()
  );

  @override
  Future<void> loadAnimations() async {
    final idleSprites = await Future.wait([
      Sprite.load('boss2/idle/crow_idle1.png'),
      Sprite.load('boss2/idle/crow_idle2.png'),
      Sprite.load('boss2/idle/crow_idle3.png'),
      Sprite.load('boss2/idle/crow_idle4.png'),
    ]);
    final attackSprites = await Future.wait([
      Sprite.load('boss2/attack/crow_attack1.png'),
      Sprite.load('boss2/attack/crow_attack2.png'),
      Sprite.load('boss2/attack/crow_attack3.png'),
      Sprite.load('boss2/attack/crow_attack4.png'),
      Sprite.load('boss2/attack/crow_attack5.png'),

    ]);
    final deathSprites = await Future.wait([
      Sprite.load('boss2/death/crow_death1.png'),
      Sprite.load('boss2/death/crow_death2.png'),
      Sprite.load('boss2/death/crow_death3.png'),
      Sprite.load('boss2/death/crow_death4.png'),
      Sprite.load('boss2/death/crow_death5.png'),
    ]);
    final takeHitSprites = await Future.wait([
      Sprite.load('boss2/take_hit/crow_take_damage1.png'),
      Sprite.load('boss2/take_hit/crow_take_damage2.png'),
      Sprite.load('boss2/take_hit/crow_take_damage3.png'),
    ]);

    idleAnimation = SpriteAnimation.spriteList(idleSprites, stepTime: 0.2);
    attackAnimation = SpriteAnimation.spriteList(attackSprites, stepTime: 0.1, loop: false);
    deathAnimation = SpriteAnimation.spriteList(deathSprites, stepTime: 0.15, loop: false);
    damageAnimation = SpriteAnimation.spriteList(takeHitSprites, stepTime: 0.125, loop: false);
  }
}