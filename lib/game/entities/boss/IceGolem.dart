import 'package:flame/components.dart';
import 'package:green_guardian/game/entities/boss/BossMonster.dart';

class IceGolem extends BossMonster {
  IceGolem({
    double attackDamage = 10,
    required int level,
    String bossName = "Eisgolem",
    double xpAmount = 10,
    double health = 100,
    double xOffsetFactor = 0.025,
    double yOffsetFactor = 0.35,
    double scalingFactor = 1,
    int pixelWidth = 192,
    int pixelHeight = 128,

  }) : super(
    labelXOffsetFactor: 0.36,
    labelYOffsetFactor: yOffsetFactor,
    attackSoundSrc: "golem_attack.mp3",
    deathSoundSrc: "golem_death.mp3",
    attackDamage: attackDamage + level * 1.25,
    health: health + 25 * level,
    maxHealth: (100 + 25 * level).toDouble(),
    xOffsetFactor: xOffsetFactor,
    yOffsetFactor: yOffsetFactor,
    scalingFactor: scalingFactor,
    pixelWidth: pixelWidth,
    pixelHeight: pixelHeight,
    bossName: "$bossName LV. $level",
    level: level,
    xpAmount: xpAmount + level * 5
  );

  IceGolem.byDatabase({
    double attackDamage = 10,
    required int level,
    String bossName = "Eisgolem",
    double xpAmount = 10,
    required super.health,
    double xOffsetFactor = 0.025,
    double yOffsetFactor = 0.35,
    double scalingFactor = 1,
    int pixelWidth = 192,
    int pixelHeight = 128,

  }) : super(
      labelXOffsetFactor: 0.36,
      labelYOffsetFactor: yOffsetFactor,
      attackSoundSrc: "golem_attack.mp3",
      deathSoundSrc: "golem_death.mp3",
      attackDamage: attackDamage + level * 1.25,
      xOffsetFactor: xOffsetFactor,
      yOffsetFactor: yOffsetFactor,
      scalingFactor: scalingFactor,
      pixelWidth: pixelWidth,
      pixelHeight: pixelHeight,
      bossName: "$bossName LV. $level",
      level: level,
      xpAmount: xpAmount + level * 5,
      maxHealth: (100 + 25 * level).toDouble()
  );

  @override
  Future<void> loadAnimations() async {
    final idleSprites = await Future.wait([
      Sprite.load('boss1/idle/idle_1.png'),
      Sprite.load('boss1/idle/idle_2.png'),
      Sprite.load('boss1/idle/idle_3.png'),
      Sprite.load('boss1/idle/idle_4.png'),
      Sprite.load('boss1/idle/idle_5.png'),
      Sprite.load('boss1/idle/idle_6.png'),
    ]);
    final attackSprites = await Future.wait([
      Sprite.load('boss1/attack/1_atk_1.png'),
      Sprite.load('boss1/attack/1_atk_2.png'),
      Sprite.load('boss1/attack/1_atk_3.png'),
      Sprite.load('boss1/attack/1_atk_4.png'),
      Sprite.load('boss1/attack/1_atk_5.png'),
      Sprite.load('boss1/attack/1_atk_6.png'),
      Sprite.load('boss1/attack/1_atk_7.png'),
      Sprite.load('boss1/attack/1_atk_8.png'),
      Sprite.load('boss1/attack/1_atk_9.png'),
      Sprite.load('boss1/attack/1_atk_10.png'),
      Sprite.load('boss1/attack/1_atk_11.png'),
      Sprite.load('boss1/attack/1_atk_12.png'),
      Sprite.load('boss1/attack/1_atk_13.png'),
      Sprite.load('boss1/attack/1_atk_14.png'),
    ]);
    final deathSprites = await Future.wait([
      Sprite.load('boss1/death/death_1.png'),
      Sprite.load('boss1/death/death_2.png'),
      Sprite.load('boss1/death/death_3.png'),
      Sprite.load('boss1/death/death_4.png'),
      Sprite.load('boss1/death/death_5.png'),
      Sprite.load('boss1/death/death_6.png'),
      Sprite.load('boss1/death/death_7.png'),
      Sprite.load('boss1/death/death_8.png'),
      Sprite.load('boss1/death/death_9.png'),
      Sprite.load('boss1/death/death_10.png'),
      Sprite.load('boss1/death/death_11.png'),
      Sprite.load('boss1/death/death_12.png'),
      Sprite.load('boss1/death/death_13.png'),
      Sprite.load('boss1/death/death_14.png'),
      Sprite.load('boss1/death/death_15.png'),
      Sprite.load('boss1/death/death_16.png'),
    ]);
    final takeHitSprites = await Future.wait([
      Sprite.load('boss1/take_hit/take_hit_1.png'),
      Sprite.load('boss1/take_hit/take_hit_2.png'),
      Sprite.load('boss1/take_hit/take_hit_3.png'),
      Sprite.load('boss1/take_hit/take_hit_4.png'),
      Sprite.load('boss1/take_hit/take_hit_5.png'),
      Sprite.load('boss1/take_hit/take_hit_6.png'),
      Sprite.load('boss1/take_hit/take_hit_7.png'),
    ]);

    idleAnimation = SpriteAnimation.spriteList(idleSprites, stepTime: 0.175);
    attackAnimation = SpriteAnimation.spriteList(attackSprites, stepTime: 0.1, loop: false);
    deathAnimation = SpriteAnimation.spriteList(deathSprites, stepTime: 0.125, loop: false);
    damageAnimation = SpriteAnimation.spriteList(takeHitSprites, stepTime: 0.125, loop: false);
  }
}