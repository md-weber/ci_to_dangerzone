import 'package:ci_dangerzone_app/game.dart';
import 'package:ci_dangerzone_app/vehicle_widget.dart';
import 'package:flutter/material.dart';

class GameStartOverlay extends StatelessWidget {
  final CIDangerZone _game;
  const GameStartOverlay(this._game, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: const EdgeInsets.symmetric(vertical: 36.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "CI to the",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              "Danger Zone",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 32,
            ),
            VehicleSelector(selectVehicle: (name) => _game.vehicle = name),
            const SizedBox(
              height: 64,
            ),
            MaterialButton(
              color: Colors.amberAccent,
              onPressed: () => _game.startGame(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Start Game',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
