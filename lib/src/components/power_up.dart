import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import '../brick_breaker.dart';
import 'bat.dart';

enum PowerUpType { extraLife, widerBat, multiBall, smallerBat }

class PowerUp extends PositionComponent with CollisionCallbacks, HasGameReference<BrickBreaker> {
  PowerUp({required this.type, required Vector2 position}) : super(position: position) {
    size = Vector2(30, 30); // Set size for the power-up
    add(RectangleHitbox());
  }

  final PowerUpType type;
  final double gravity = 300; // Gravity effect

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = _getColor();
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);
  }

  Color _getColor() {
    switch (type) {
      case PowerUpType.extraLife:
        return Colors.green;
      case PowerUpType.widerBat:
        return Colors.blue;
      case PowerUpType.multiBall:
        return Colors.red;
      case PowerUpType.smallerBat:
        return Colors.purple;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += gravity * dt; // fallin
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Bat) {
      _applyEffect(other);
      FlameAudio.play('sfx/powerup.mp3');
      removeFromParent();
    }
  }

  void _applyEffect(Bat bat) {
    switch (type) {
      case PowerUpType.extraLife:
        game.score.value++;
        break;
      case PowerUpType.widerBat:
        bat.size.x *= 1.2; 
        break;
      case PowerUpType.smallerBat:
        bat.size.x *= 0.8;
        game.add(
          TimerComponent(
        period: 5,
        removeOnFinish: true,
        onTick: () => bat.size.x /= 0.8,
          ),
        );
        break;
      case PowerUpType.multiBall:
        game.spawnMultipleBalls(1, bat.position, Vector2(0, 200));
        break;
    }
  }
}