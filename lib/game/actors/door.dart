import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';

class Door extends SpriteComponent {
  Door(
      Image image, {
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
      srcPosition: Vector2(2 * 32, 0),
      srcSize: Vector2.all(32),
      position: position,
      size: size,
      scale: scale,
      angle: angle,
      anchor: anchor,
      priority: priority
  );
}