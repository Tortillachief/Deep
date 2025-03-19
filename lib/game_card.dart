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
        child: Hero(
          tag: 'cardHero',
          child: Card(
            color: config.backgroundColor,
            elevation: 8,
            shadowColor: config.backgroundColor.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: config.textColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Stack(
                children: [
                  // Card type indicator
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getCardTypeColor(),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
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
                  // Swipe hint at bottom
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.swipe, 
                          color: config.textColor.withOpacity(0.3),
                          size: 16,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Color _getCardTypeColor() {
    if (config == GameCardConfig.icebreaker) {
      return Colors.blue;
    } else if (config == GameCardConfig.confession) {
      return Colors.amber;
    } else if (config == GameCardConfig.deep) {
      return Colors.deepPurple;
    }
    return Colors.grey;
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
    backgroundColor: Color.fromARGB(255, 124, 124, 124),
  );

  static const GameCardConfig deep = GameCardConfig(
    textColor: Colors.white,
    backgroundColor: Colors.black,
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
