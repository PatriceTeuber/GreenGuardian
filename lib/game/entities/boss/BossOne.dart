import 'package:flame/components.dart';
import 'package:green_guardian/game/entities/boss/BossMonster.dart';

class BossOne extends BossMonster {
  BossOne({
    required String bossName,
    double health = 100,
    double xOffset = -100,
    double yOffset = 200,
    double scaling = 2.5,
    int pixelWidth = 192,
    int pixelHeight = 128,
  }) : super(
    health: health,
    xOffset: xOffset,
    yOffset: yOffset,
    scaling: scaling,
    pixelWidth: pixelWidth,
    pixelHeight: pixelHeight,
    bossName: bossName,
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