import 'package:flame/components.dart';

import 'package:flutter/painting.dart';

import 'game.dart';

class LapDisplay extends PositionComponent with HasGameRef<CIDangerZone> {
  int _lap = 0;
  late TextComponent _lapText = _buildLapText;

  TextComponent get _buildLapText => TextComponent(
      text: 'LAPS:${_lap < 0 ? 0 : _lap}', textRenderer: textPaint)
    ..x = 80 - game.size.x / 2
    ..y = 100 - game.size.y / 2;

  TextPaint get textPaint => TextPaint(
        style: const TextStyle(
          fontSize: 48.0,
          fontFamily: 'FutilePro',
        ),
      );

  @override
  Future<void> onLoad() async {
    _lap = game.laps;

    add(_lapText..anchor = Anchor.topLeft);
    add(TimerText()
      ..x = 80 - game.size.x / 2
      ..y = 60 - game.size.y / 2);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.laps != _lap) {
      _lap = game.laps;
      if (_lapText.isMounted) {
        remove(_lapText);
      }
      _lapText = _buildLapText;
      add(_lapText);
    }
  }
}

class TimerText extends TextComponent with HasGameRef<CIDangerZone> {
  TimerText()
      : super(
          text: "",
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 48.0,
              fontFamily: 'FutilePro',
            ),
          ),
        );

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (game.laps < 0) {
      textRenderer.render(canvas, "Time: 00:00", Vector2(0, 0));
    } else {
      final double time = game.currentTime() - game.gameStartTime;

      textRenderer.render(canvas, "Time: ${formatedTime(time)}", Vector2(0, 0));
    }
  }
}

String formatedTime(double time) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");

  final ms = time.toString().split(".")[1].substring(0, 3);
  return "${twoDigits(time.round())}:$ms";
}
