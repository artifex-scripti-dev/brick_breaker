import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import '../brick_breaker.dart';
import 'bat.dart';
import 'brick.dart';
import 'play_area.dart';

class Ball extends CircleComponent
    with CollisionCallbacks, HasGameReference<BrickBreaker> {
  Ball({
    required this.velocity,
    required super.position,
    required double radius,
    required this.difficultyModifier,
  }) : super(
          radius: radius,
          anchor: Anchor.center,
          paint: Paint()
            ..color = const Color(0xFF12851D)
            ..style = PaintingStyle.fill,
          children: [
            CircleComponent(
              radius: radius,
              paint: Paint()
                ..color = Colors.white
                ..style = PaintingStyle.stroke
                ..strokeWidth = 3,
            ),
            CircleHitbox(),
          ],
        );

  final Vector2 velocity;
  final double difficultyModifier;

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;

    // Ensure the trail is properly positioned
    final trail = ParticleSystemComponent(
      position: position.clone(),
      particle: Particle.generate(
        count: 1,
        lifespan: 0.1,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, 10),
          position: Vector2.zero(),
          child: CircleParticle(
            radius: radius * 0.6,
            paint: Paint()..color = const Color(0x6812851D),
          ),
        ),
      ),
    );

    game.world.add(trail);

    if (position.y > game.height) {
      removeFromParent();
      game.activeBallCount--;

      if (game.activeBallCount <= 0) {
        game.playState = PlayState.gameOver;
        FlameAudio.play('sfx/game_over.mp3');
      }
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is PlayArea) {
      if (intersectionPoints.first.y <= 0) {
        velocity.y = -velocity.y;
      } else if (intersectionPoints.first.x <= 0) {
        velocity.x = -velocity.x;
      } else if (intersectionPoints.first.x >= game.width) {
        velocity.x = -velocity.x;
      } else if (intersectionPoints.first.y >= game.height) {
        add(RemoveEffect(
            delay: 0.35,
            onComplete: () {
              removeFromParent();
              game.activeBallCount--;
              if (game.activeBallCount <= 0) {
                game.playState = PlayState.gameOver;
              }
            }));
      }
    } else if (other is Bat) {
      velocity.y = -velocity.y;
      velocity.x = velocity.x +
          (position.x - other.position.x) / other.size.x * game.width * 0.3;
    } else if (other is Brick) {
      if (position.y < other.position.y - other.size.y / 2) {
        velocity.y = -velocity.y;
      } else if (position.y > other.position.y + other.size.y / 2) {
        velocity.y = -velocity.y;
      } else if (position.x < other.position.x) {
        velocity.x = -velocity.x;
      } else if (position.x > other.position.x) {
        velocity.x = -velocity.x;
      }
      velocity.setFrom(velocity * difficultyModifier);
    }
  }
}
