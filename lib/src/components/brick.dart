import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';

import '../brick_breaker.dart';
import '../config.dart';
import 'ball.dart';
import 'bat.dart';
import 'power_up.dart';

class Brick extends RectangleComponent
    with CollisionCallbacks, HasGameReference<BrickBreaker> {
  int health;
  final int maxHealth;

  final Paint _borderPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3.0;

  final Paint _fillPaint;

  Brick({
    required super.position,
    required Color color,
  })  : health = (color == const Color(0xfff94144))
            ? 3
            : (color == const Color(0xfff9c74f))
                ? 2
                : 1,
        maxHealth = (color == const Color(0xfff94144))
            ? 3
            : (color == const Color(0xfff9c74f))
                ? 2
                : 1,
        _fillPaint = Paint()
          // ignore: deprecated_member_use
          ..color = color.withOpacity(1.0)
          ..style = PaintingStyle.fill,
        super(
          size: Vector2(brickWidth, brickHeight),
          anchor: Anchor.center,
          children: [RectangleHitbox()],
        );

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final rect = Rect.fromLTWH(0, 0, size.x, size.y);

    canvas.drawRect(rect, _fillPaint);
    canvas.drawRect(rect, _borderPaint);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Ball) {
      health--;
      updateOpacity();
      FlameAudio.play('sfx/ball_hit.wav');

      if (health <= 0) {
        FlameAudio.play('sfx/block_destroyed.mp3');

        final fallDistance = game.size.y - position.y;
        add(
          MoveByEffect(
            Vector2(0, fallDistance),
            EffectController(duration: 1.0, curve: Curves.easeIn),
            onComplete: () => removeFromParent(),
          ),
        );
        game.score.value++;

        if (game.rand.nextDouble() < 0.15) {
          final powerUpType =
              PowerUpType.values[game.rand.nextInt(PowerUpType.values.length)];
          game.world.add(
              PowerUp(type: powerUpType, position: position.clone()..y += 30));
        }

        if (game.world.children.query<Brick>().length == 1) {
          game.playState = PlayState.won;
          game.world.removeAll(game.world.children.query<Ball>());
          game.world.removeAll(game.world.children.query<Bat>());
        }
      }
    }
  }

  void updateOpacity() {
    final newOpacity = health / maxHealth;
    // ignore: deprecated_member_use
    _fillPaint.color = _fillPaint.color.withOpacity(newOpacity.clamp(0.0, 1.0));
  }
}
