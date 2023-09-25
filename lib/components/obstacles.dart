// @deprecated - This messes with the player object
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class WitchesHatBody extends BodyComponent {
  Vector2 initPosition;

  WitchesHatBody({required this.initPosition});

  @override
  Future<void> onLoad() {
    add(WitchesHat());
    return super.onLoad();
  }

  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBoxXY(16, 16);
    final fixtureDef = FixtureDef(shape, isSensor: true);
    final bodyDef = BodyDef(userData: this, position: initPosition);
    renderBody = false;
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class WitchesHat extends Obstacle {
  WitchesHat({super.position});

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load('witches_hat.png');
    size = Vector2.all(32);
    anchor = Anchor.center;
  }
}

abstract class Obstacle extends SpriteComponent {
  Obstacle({super.position})
      : super(
          priority: 1,
        );

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
  }
}
