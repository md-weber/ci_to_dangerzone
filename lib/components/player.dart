import 'package:ci_dangerzone_app/components/start_grid.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';
import 'package:flutter/src/services/raw_keyboard.dart';

import '../game.dart';
import '../stacked_sprite_component.dart';

class PlayerBody extends BodyComponent with ContactCallbacks, KeyboardHandler {
  final Game flameGame;
  final String name;

  double speed = 120.0;
  double maxSpeed = 120.0;
  double rotationSpeed = 5.5;
  double driftFactor = 10;
  double velocityVsUp = 0;
  double accelerationInput = 0;
  double steeringInput = 0;
  double rotationAngle = 0;

  bool _pendingLap = false; // approx hitbox for our player stackedsprites

  PlayerBody({required this.flameGame, required this.name});

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    updateDirection(keysPressed);
    return true;
  }

  @override
  Future<void> onLoad() {
    var player = Player(game, name)..scale = Vector2.all(4);
    add(player);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    applyEngineForce();
    killOrthogonalVelocity();
    applySteering();

    super.update(dt);
  }

  void move(Vector2 delta) {
    position.add(delta / 4); // makes movements smaller, smoother, less jerky
  }

  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBoxXY(16 * 2, 16 * 2);
    final fixtureDef = FixtureDef(shape, density: 1, friction: 0.3);
    final bodyDef = BodyDef(
      userData: this,
      position: Vector2(-320, 150),
      type: BodyType.dynamic,
    );
    renderBody = false;
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is StartGridBody) {
      _pendingLap = true;
      super.beginContact(other, contact);
    }

    if (other is! StartGridBody) {
      findParent<CIDangerZone>()!.endGame();
    }
    super.beginContact(other, contact);
  }

  @override
  void endContact(Object other, Contact contact) {
    if (other is StartGridBody && _pendingLap) {
      findParent<CIDangerZone>()!.lap();
      _pendingLap = false;
    }
    super.endContact(other, contact);
  }

  void updateDirection(Set<LogicalKeyboardKey> keysPressed) {
    steeringInput = 0;
    accelerationInput = 0;
    steeringInput += (keysPressed.contains(LogicalKeyboardKey.keyA) ||
            keysPressed.contains(LogicalKeyboardKey.arrowLeft))
        ? -1
        : 0;
    steeringInput += (keysPressed.contains(LogicalKeyboardKey.keyD) ||
            keysPressed.contains(LogicalKeyboardKey.arrowRight))
        ? 1
        : 0;
    accelerationInput += (keysPressed.contains(LogicalKeyboardKey.keyS) ||
            keysPressed.contains(LogicalKeyboardKey.arrowLeft))
        ? -1
        : 0;
    accelerationInput += (keysPressed.contains(LogicalKeyboardKey.keyW) ||
            keysPressed.contains(LogicalKeyboardKey.arrowRight))
        ? 1
        : 0;

    print(accelerationInput);
  }

  void applyEngineForce() {
    Vector2 forward =
        Vector2(1, 0); // Assuming the player faces to the right initially.
    forward.rotate(body.angle);
    if (velocityVsUp > maxSpeed && accelerationInput > 0) {
      return;
    }

    if (velocityVsUp < -maxSpeed * 0.2 && accelerationInput < 0) {
      return;
    }

    if (accelerationInput == 0) {
      body.linearDamping = 1.5;
    } else {
      body.linearDamping = 0;
    }

    Vector2 engineForward = forward * accelerationInput * speed * body.mass;
    print(engineForward);

    body.applyForce(engineForward, point: body.position);
  }

  void killOrthogonalVelocity() {
    Vector2 forward =
        Vector2(1, 0); // Assuming the player faces to the right initially.
    Vector2 up =
        Vector2(0, -1); // Assuming the player faces to the right initially.
    Vector2 forwardVelocity = forward * body.linearVelocity.dot(forward);
    Vector2 upVelocity = up * body.linearVelocity.dot(up);

    body.applyForce(forwardVelocity + upVelocity * driftFactor);
  }

  void applySteering() {
    if (steeringInput == 0) {
      body.angularDamping = 5;
    }

    double minSpeedBeforeAllowTurningFactor = body.linearVelocity.length / 4;

    double targetRotationAngle = steeringInput *
        rotationSpeed *
        minSpeedBeforeAllowTurningFactor *
        body.mass /
        2;

    double rotationDiff = targetRotationAngle - rotationAngle;
    body.applyAngularImpulse(rotationDiff);
  }
}

class Player extends StackedSpriteComponent with HasGameRef<CIDangerZone> {
  Player(super.game, super.name);

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
  }
}
