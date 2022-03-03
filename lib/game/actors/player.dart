import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platformer_game/game/actors/platform.dart';

class Player extends SpriteComponent with HasHitboxes, Collidable, KeyboardHandler {

  /// horizontal axis input
  /// left : -1
  /// idle: 0
  /// right: +1
  int _hAxisInput = 0;
  final double _gravity = 10;
  final double _jumpSpeed = 520;
  final double _moveSpeed = 200;
  bool _jumpInput = false;
  final Vector2 _up = Vector2(0, -1);
  bool _isOnGround = false;

  late Vector2 _minClamp;
  late Vector2 _maxClamp;

  final Vector2 _velocity = Vector2.zero();

  Player(
      Image image, {
        required Rect levelBounds,
        Vector2? srcPosition,
        Vector2? srcSize,
        Vector2? position,
        Vector2? size,
        Vector2? scale,
        double? angle,
        Anchor? anchor,
        int? priority,
      }) : super.fromImage(
      image,
      srcPosition: Vector2.zero(),
      srcSize: Vector2.all(32),
      position: position,
      size: size,
      scale: scale,
      angle: angle,
      anchor: anchor,
      priority: priority
  ){

    final halfSize = size! / 2;
    _minClamp = levelBounds.topLeft.toVector2() + halfSize;
    _maxClamp = levelBounds.bottomRight.toVector2() - halfSize;
  }

  @override
  Future<void>? onLoad() {
    debugMode = true;
    addHitbox(HitboxCircle());
    return super.onLoad();
  }

  @override
  void update(double dt) {

    /// Set the velocity on walk left/right
    _velocity.x = _hAxisInput * _moveSpeed;
    /// Set the gravity to fall
    _velocity.y += _gravity;

    if(_jumpInput){

      if(_isOnGround){
        _velocity.y += -_jumpSpeed;
        _isOnGround = false;
      }

      _jumpInput = false;
    }

    /// Stop falling when touches the ground (need to onCollision method)
    _velocity.y = _velocity.y.clamp(-_jumpSpeed, 150);
    position += _velocity * dt;
    
    position.clamp(_minClamp, _maxClamp);

    /// Flip the player (sprite) to left and right
    if(_hAxisInput < 0 && scale.x > 0){
      flipHorizontallyAroundCenter();
    } else if(_hAxisInput > 0 && scale.x < 0){
      flipHorizontallyAroundCenter();
    }

    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed){
    _hAxisInput = 0;

    _hAxisInput += keysPressed.contains(LogicalKeyboardKey.keyA) ? -1 : 0;
    _hAxisInput += keysPressed.contains(LogicalKeyboardKey.keyD) ? 1 : 0;
    _jumpInput = keysPressed.contains(LogicalKeyboardKey.space);

    return true;
  }


  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {

    if(other is Platform){
      if(intersectionPoints.length == 2){
        final mid = (intersectionPoints.elementAt(0) + intersectionPoints.elementAt(1)) / 2;
        final collisionNormal = absoluteCenter - mid;
        final separationDistance = (size.x/2) - collisionNormal.length;
        collisionNormal.normalize();

        /// Check if the player is on the ground
        if(_up.dot(collisionNormal) > 0.9){
          _isOnGround = true;
        }

        position += collisionNormal.scaled(separationDistance);
      }
    }

    super.onCollision(intersectionPoints, other);
  }

}