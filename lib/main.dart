import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platformer_game/game/game.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // TODO
  final _game  = FlutterPlatformerGame();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: GameWidget(game: kDebugMode ? FlutterPlatformerGame() : _game),
    );
  }
}

