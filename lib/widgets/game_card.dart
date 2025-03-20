import 'package:deep/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:deep/constants.dart';

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
        child: Hero(
          tag: 'cardHero',
          child: Card(
            color: config.backgroundColor,
            elevation: 6,
            shadowColor: ColorUtils.withOpacity(Colors.white, 0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              //Stroke
              side: BorderSide(
                color: ColorUtils.withOpacity(config.textColor, 0.5),
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Stack(
                children: [
                  // Main content
                  Center(
                    child: Text(
                      description.toUpperCase(),
                      style: TextStyle(
                        fontSize: 32,
                        color: config.textColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
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

  static GameCardConfig icebreaker = GameCardConfig(
    textColor: icebreakerTextColor,
    backgroundColor: icebreakerBackgroundColor,
  );

  static GameCardConfig confession = GameCardConfig(
    textColor: confessionTextColor,
    backgroundColor: confessionBackgroundColor,
  );

  static GameCardConfig deep = GameCardConfig(
    textColor: deepTextColor,
    backgroundColor: deepBackgroundColor,
  );
}

enum GameCardType {
  icebreaker, //0
  confession, //1
  deep, //2
  none //3
}

GameCardConfig getConfigForType(GameCardType type) {
  switch (type) {
    case GameCardType.icebreaker:
      return GameCardConfig.icebreaker;
    case GameCardType.confession:
      return GameCardConfig.confession;
    case GameCardType.deep:
      return GameCardConfig.deep;
    default:
      return const GameCardConfig();
  }
}
