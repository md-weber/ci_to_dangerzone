import 'package:ci_dangerzone_app/components/obstacles.dart';
import 'package:ci_dangerzone_app/game.dart';
import 'package:ci_dangerzone_app/script_handler.dart';
import 'package:ci_dangerzone_app/script_loader.dart';
import 'package:flame/components.dart';

class RaceTrack extends SpriteComponent with HasGameReference<CIDangerZone> {
  late final ScriptHandler scriptHandler;

  RaceTrack()
      : super(
          position: Vector2.all(0),
          size: Vector2(924, 518),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('racetrack.png');

    scriptHandler = ScriptHandler(
      track: this,
      script: await loadScriptFromNetwork(),
    );
    scriptHandler.createObstacles();
  }

  Future<void> addObstacle(double x, double y, bool visible) async {
    if (visible) {
      await game.world.add(
        WitchesHatBody(
          initPosition: Vector2(x - game.size.x / 2, y - game.size.y / 2),
        ),
      );
    }
  }
}
