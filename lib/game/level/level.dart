import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter_platformer_game/game/actors/coin.dart';
import 'package:flutter_platformer_game/game/actors/door.dart';
import 'package:flutter_platformer_game/game/actors/enemy.dart';
import 'package:flutter_platformer_game/game/actors/platform.dart';
import 'package:flutter_platformer_game/game/actors/player.dart';
import 'package:flutter_platformer_game/game/game.dart';

class Level extends Component with HasGameRef<FlutterPlatformerGame>{
  final String levelName;
  late Player player;
  late Rect _levelBounds;

  Level(this.levelName): super();


  @override
  Future<void>? onLoad() async {

    final level = await TiledComponent.load(
        levelName,
        Vector2.all(32)
    );

    add(level);

    /// Get and set the level width and height to the Rect
    _levelBounds = Rect.fromLTWH(
        0,
        0,
        (level.tileMap.map.width * level.tileMap.map.tileWidth).toDouble(),
        (level.tileMap.map.height * level.tileMap.map.tileHeight).toDouble(),
    );

    _spawnActors(level.tileMap);
    _setupCamera();

    return super.onLoad();
  }

  // This method takes care of spawning
  // all the actors in the game world.
  void _spawnActors(RenderableTiledMap tileMap){

    /// Platforms to detect hitbox
    final platformsLayers = tileMap.getObjectGroupFromLayer("Platforms");

    for(final platformObject in platformsLayers.objects){

      final platform = Platform(
          position: Vector2(platformObject.x, platformObject.y),
          size: Vector2(platformObject.width, platformObject.height),
      );
      add(platform);
    }

    final spawnPointsLayer = tileMap.getObjectGroupFromLayer("SpawnPoints");

    for(final spawnPoint in spawnPointsLayer.objects){
      switch(spawnPoint.type){
        case "Player":

          player = Player(
            gameRef.spriteSheet,
            levelBounds: _levelBounds,
            anchor: Anchor.center,
            position: Vector2(spawnPoint.x, spawnPoint.y),
            size: Vector2(spawnPoint.width, spawnPoint.height),
          );

          add(player);
          break;

        case "Coin":

          final coin = Coin(
            gameRef.spriteSheet,
            position: Vector2(spawnPoint.x, spawnPoint.y),
            size: Vector2(spawnPoint.width, spawnPoint.height),
          );

          add(coin);
          break;

        case 'Enemy':
          final enemy = Enemy(
            gameRef.spriteSheet,
            position: Vector2(spawnPoint.x, spawnPoint.y),
            size: Vector2(spawnPoint.width, spawnPoint.height),
          );
          add(enemy);

          break;

        case 'Door':
          final door = Door(
            gameRef.spriteSheet,
            position: Vector2(spawnPoint.x, spawnPoint.y),
            size: Vector2(spawnPoint.width, spawnPoint.height),
          );
          add(door);

          break;
      }
    }

  }

  void _setupCamera(){
    gameRef.camera.followComponent(player);
    gameRef.camera.worldBounds = _levelBounds;
  }

}