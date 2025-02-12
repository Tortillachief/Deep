import 'package:flutter/material.dart';

class GameCard extends StatelessWidget {
  final String description;
  final double paddingVal = 20;
  final GameCardConfig config;

  const GameCard({
    super.key,
    required this.description,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
            bottom: paddingVal, left: paddingVal, right: paddingVal),
        child: Card(
          color: config.backgroundColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Add padding inside the Card
            child: Center(
              child: Text(
                description,
                style: TextStyle(fontSize: 40, color: config.textColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GameCardConfig {
  final Color textColor;
  final Color backgroundColor;

  const GameCardConfig({
    this.textColor = Colors.black,
    this.backgroundColor = Colors.white,
  });

  static const GameCardConfig icebreaker = GameCardConfig(
    textColor: Colors.black,
    backgroundColor: Colors.white,
  );

  static const GameCardConfig confession = GameCardConfig(
    textColor: Colors.black,
    backgroundColor: Colors.grey,
  );

  static const GameCardConfig deep = GameCardConfig(
    textColor: Colors.white,
    backgroundColor: Colors.black,
  );
}

enum GameCardType { icebreaker, confession, deep }

GameCardConfig getConfigForType(GameCardType type) {
  switch (type) {
    case GameCardType.icebreaker:
      return GameCardConfig.icebreaker;
    case GameCardType.confession:
      return GameCardConfig.confession;
    case GameCardType.deep:
      return GameCardConfig.deep;
  }
}
