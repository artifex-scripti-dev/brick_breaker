import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'components/components.dart';
import 'config.dart';

enum PlayState { welcome, playing, gameOver, won }

class BrickBreaker extends FlameGame
    with HasCollisionDetection, KeyboardEvents, TapDetector {
  BrickBreaker()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
        );

  final ValueNotifier<int> score = ValueNotifier(0);
  final rand = math.Random();
  double get width => size.x;
  double get height => size.y;
  int activeBallCount = 0;

  late PlayState _playState;
  PlayState get playState => _playState;
  set playState(PlayState playState) {
    _playState = playState;
    switch (playState) {
      case PlayState.welcome:
      case PlayState.gameOver:
      case PlayState.won:
        overlays.add(playState.name);
        break;
      case PlayState.playing:
        overlays.remove(PlayState.welcome.name);
        overlays.remove(PlayState.gameOver.name);
        overlays.remove(PlayState.won.name);
        break;
    }
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();


    FlameAudio.audioCache.loadAll([
      'sfx/ball_hit.wav',
      'sfx/block_destroyed.mp3',
      'sfx/powerup.mp3',
      'sfx/game_over.wav',
    ]);

    camera.viewfinder.anchor = Anchor.topLeft;
    world.add(PlayArea());
    playState = PlayState.welcome;
  }

  void startGame() {
    if (playState == PlayState.playing) return;
    

    world.removeAll(world.children.query<Ball>());
    world.removeAll(world.children.query<Bat>());
    world.removeAll(world.children.query<Brick>());

    activeBallCount = 0;
    playState = PlayState.playing;
    score.value = 0;

    world.add(Ball(
      difficultyModifier: difficultyModifier,
      radius: ballRadius,
      position: size / 2,
      velocity:
          Vector2((rand.nextDouble() - 0.5) * width, height * 0.2).normalized()
            ..scale(height / 2),
    ));
    activeBallCount++;

    world.add(Bat(
      size: Vector2(batWidth, batHeight),
      cornerRadius: const Radius.circular(ballRadius / 1),
      position: Vector2(width / 2, height * 0.95),
    ));

    world.addAll([
      for (var i = 0; i < brickColors.length; i++)
        for (var j = 1; j <= 8; j++)
          Brick(
            position: Vector2(
              (i + 0.5) * brickWidth + (i + 1) * brickGutter,
              (j + 2.0) * brickHeight + j * brickGutter,
            ),
            color: brickColors[
                (i + rand.nextInt(brickColors.length)) % brickColors.length],
          ),
    ]);
  }

  @override
  void onTap() {
    super.onTap();
    startGame();
  }

  void spawnMultipleBalls(
      int count, Vector2 position, Vector2 initialVelocity) {
    for (int i = 0; i < count; i++) {
      final ball = Ball(
        position: position + Vector2(i * 20, 0),
        velocity: Vector2((rand.nextDouble() - 0.5) * width, height * 0.2)
            .normalized()
          ..scale(height / 3),
        radius: ballRadius,
        difficultyModifier: difficultyModifier,
      );
      world.add(ball);
      activeBallCount++; // Increment counter
      print('Ball spawned, activeBallCount: $activeBallCount');
    }
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        world.children.query<Bat>().first.moveBy(-batStep);
        break;
      case LogicalKeyboardKey.arrowRight:
        world.children.query<Bat>().first.moveBy(batStep);
        break;
      case LogicalKeyboardKey.space:
      case LogicalKeyboardKey.enter:
        startGame();
        break;
    }
    return KeyEventResult.handled;
  }

  @override
  Color backgroundColor() => const Color.fromARGB(255, 0, 0, 0);
}
