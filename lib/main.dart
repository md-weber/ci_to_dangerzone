import 'package:ci_dangerzone_app/overlays/game_over_overlay.dart';
import 'package:ci_dangerzone_app/overlays/game_overlay.dart';
import 'package:ci_dangerzone_app/overlays/game_start_overlay.dart';
import 'package:ci_dangerzone_app/theme.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CI Dangerzone',
      theme: themeData,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final CIDangerZone _game;

  @override
  void initState() {
    super.initState();
    _game = CIDangerZone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GameWidget(
          game: _game,
          overlayBuilderMap: <String,
              Widget Function(BuildContext, CIDangerZone)>{
            Overlays.start.name: (context, game) => GameStartOverlay(game),
            Overlays.end.name: (context, game) => GameOverOverlay(game),
            Overlays.game.name: (context, game) => GameOverlay(game),
          },
          initialActiveOverlays: [Overlays.start.name],
        ),
      ),
    );
  }
}
