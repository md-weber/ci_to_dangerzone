import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class StartGridBody extends BodyComponent with ContactCallbacks {
  Vector2 initPosition;
  StartGridBody({required this.initPosition});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    var sprite = await Sprite.load('startgrid.png');
    add(
      SpriteComponent(sprite: sprite)
        ..size = Vector2.all(102)
        ..anchor = Anchor.center,
    );
  }

  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBoxXY(64, 64);
    renderBody = false;
    final fixtureDef = FixtureDef(shape, isSensor: true);

    final bodyDef = BodyDef(userData: this, position: initPosition);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
