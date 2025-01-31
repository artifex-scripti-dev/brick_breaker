import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../brick_breaker.dart';

class Bat extends PositionComponent
    with DragCallbacks, HasGameReference<BrickBreaker> {
  Bat({
    required this.cornerRadius,
    required super.position,
    required super.size,
  }) : super(
          anchor: Anchor.center,
          children: [RectangleHitbox()],
        );

  final Radius cornerRadius;

  final _fillPaint = Paint()
    ..color = const Color(0xFF12851D)
    ..style = PaintingStyle.fill;

  final _borderPaint = Paint()
    ..color = Colors.white // Set border color
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3.0; // Adjust thickness

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size.toSize(),
      cornerRadius,
    );

    canvas.drawRRect(rrect, _fillPaint); // Draw fill
    canvas.drawRRect(rrect, _borderPaint); // Draw border
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    position.x = (position.x + event.localDelta.x).clamp(0, game.width);
  }

  void moveBy(double dx) {
    add(MoveToEffect(
      Vector2((position.x + dx).clamp(0, game.width), position.y),
      EffectController(duration: 0.1),
    ));
  }
}
