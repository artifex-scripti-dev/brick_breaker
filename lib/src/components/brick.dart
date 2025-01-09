import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../brick_breaker.dart';
import '../config.dart';
import 'ball.dart';
import 'bat.dart';
import 'power_up.dart';

class Brick extends RectangleComponent
    with CollisionCallbacks, HasGameReference<BrickBreaker> {
  int health; 
  final int maxHealth;
  
  Brick({
    required super.position,
    required Color color,
    Color red = const Color(0xfff94144),
    Color orange  = const Color(0xfff3722c),
    Color orange2 = const Color(0xfff8961e),
    Color orangre3 = const Color(0xfff9844a),
    Color yellow = const Color(0xfff9c74f),
    Color green = const Color(0xff90be6d),
    Color lightGreen = const Color(0xff43aa8b),
    Color teal = const Color(0xff4d908e),
    Color blue = const Color(0xff277da1),
    Color blue2 = const Color(0xff577590),
  })  : health = (color == red) ? 3 : (color == yellow) ? 2 : 1, 
        maxHealth = (color ==  red) ? 3 : (color == yellow) ? 2 : 1,
        super(
          size: Vector2(brickWidth, brickHeight),
          anchor: Anchor.center,
          paint: Paint()
            ..color = color.withOpacity(1.0) // Start with full opacity
            ..style = PaintingStyle.fill,
          children: [RectangleHitbox()],
        );

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Ball) {
      health--; // Decrease health
      updateOpacity(); // opacity decreases based on remaining health

      if (health <= 0) {
        // Remove the brick if health reached 0
        removeFromParent();
        game.score.value++;

        // Spawn power-up based on chance
        if (game.rand.nextDouble() < 0.15) { // 15% chance to spawn a power-up
          final powerUpType = PowerUpType.values[game.rand.nextInt(PowerUpType.values.length)];
          game.world.add(PowerUp(type: powerUpType, position: position.clone()..y += 30));
        }

        // Check if it was the last brick
        if (game.world.children.query<Brick>().length == 1) {
          game.playState = PlayState.won;
          game.world.removeAll(game.world.children.query<Ball>());
          game.world.removeAll(game.world.children.query<Bat>());
        }
      }
    }
  }

  // lower opacity = lower health
  void updateOpacity() {
    final newOpacity = health / maxHealth;
    paint.color = paint.color.withOpacity(newOpacity.clamp(0.0, 1.0));
  }
}