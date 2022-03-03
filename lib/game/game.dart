import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/input.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter_platformer_game/game/level/level.dart';

class FlutterPlatformerGame extends FlameGame
    with HasCollidables, HasKeyboardHandlerComponents {

  Level? _currentLevel;
  late Image spriteSheet;

  @override
  Future<void>? onLoad() async {

    await Flame.device.fullScreen();
    await Flame.device.setLandscape();
    
    spriteSheet = await images.load("spritesheet.png");

    camera.viewport = FixedResolutionViewport(Vector2(640, 330));

    loadLevel("level_2.tmx");

    return super.onLoad();
  }

  void loadLevel(String levelName){
    _currentLevel?.removeFromParent();
    _currentLevel = Level(levelName);
    add(_currentLevel!);
  }

}