// ignore_for_file: avoid_print

import 'dart:math' as math;
import 'dart:math';

import 'package:ci_dangerzone_app/components/race_track.dart';
import 'package:ci_dangerzone_app/components/start_grid.dart';
import 'package:flame/events.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart' as forge2d;
import 'components/player.dart';
import 'race_track.dart';

Random rnd = Random();

const vehicles = [
  'BlueCar',
  'YellowCar',
  'GreenBigCar',
  'RedMotorcycle',
  'WhiteMotorcycle'
];

enum Overlays { start, end, game }

class CIDangerZone extends forge2d.Forge2DGame
    with HasKeyboardHandlerComponents, HasCollisionDetection, DragCallbacks {
  CIDangerZone() : super(zoom: 1.0, gravity: Vector2.all(0)) {
    initializeGameStart();
  }

  String _vehicleName = vehicles[0];

  PlayerBody? playerOne;
  RaceTrack _raceTrack = RaceTrack();
  LapDisplay _lapDisplay = LapDisplay();
  StartGridBody? _startGrid;

  int _lapCount = -1;

  double _gameTimer = 0;

  double get gameStartTime => _gameTimer;

  // first time past we count that first lap started
  int get laps => _lapCount;

  set vehicle(String name) => _vehicleName = name;

  String resultText = "";
  double courseTime = 0;

  void startGame() {
    initializeGameStart();
    overlays.remove(Overlays.start.name);
    overlays.add(Overlays.game.name);
  }

  void initializeGameStart() {
    if (playerOne != null && playerOne!.isMounted) {
      world.remove(playerOne!);
    }
    if (_raceTrack.isMounted) {
      world.remove(_raceTrack);
    }
    if (_lapDisplay.isMounted) {
      world.remove(_lapDisplay);
    }

    _lapCount = -1;

    playerOne = PlayerBody(
      flameGame: this,
      name: _vehicleName,
    );

    _raceTrack = RaceTrack();
    _lapDisplay = LapDisplay();
    _startGrid = StartGridBody(
      initPosition: Vector2(-250, 140),
    );

    world.addAll([_raceTrack, _lapDisplay, _startGrid!, playerOne!]);
  }

  void lap() {
    _lapCount++;
    print("LAP! $_lapCount");
    if (_lapCount == 0) {
      _gameTimer = currentTime();
    }
    if (_lapCount > 3) {
      endGame(win: true);
    }
  }

  void endGame({bool win = false}) {
    world.remove(playerOne!);
    world.remove(_raceTrack);
    world.remove(_startGrid!);
    world.remove(_lapDisplay);

    courseTime = currentTime() - _gameTimer;
    _gameTimer = 0;

    overlays.remove(Overlays.game.name);
    if (win) {
      resultText = "🏆 FINISHED 🏆";
    } else {
      resultText = "⚠️ CRASHED ⚠️";
    }
    overlays.add(Overlays.end.name);
  }

  @override
  Future<void> onLoad() async {
    // NA for now
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);

    final evtX = event.canvasPosition.x - (size.x / 2);
    final evtY = event.canvasPosition.y - (size.y / 2);

    final player = playerOne;

    if (player == null) {
      return;
    }

    (player.children.first as PositionComponent).angle =
        math.atan2(evtY - player.position.y, evtX - player.position.x) *
            degrees2Radians;

    final delta = Vector2(evtX - player.position.x, evtY - player.position.y);
    player.move(delta);
  }
}
