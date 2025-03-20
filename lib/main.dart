import 'package:deep/card_service.dart';
import 'package:deep/constants.dart';
import 'package:deep/database/database_helper.dart' as db_helper;
import 'package:flutter/material.dart';
import 'package:deep/widgets/game_card.dart';
import 'package:deep/widgets/options_menu.dart';
import 'package:deep/settings_provider.dart';
import 'package:deep/utils/color_utils.dart';
import 'package:deep/widgets/deep_button.dart';
import 'package:provider/provider.dart';
import 'package:deep/database/database_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(providers: [
    Provider<AppDatabase>(
      create: (_) => AppDatabase(),
      dispose: (_, db) => db.close(),
    ),
    Provider<CardService>(
        create: (context) => CardService(context.read<AppDatabase>())),
    ChangeNotifierProvider<SettingsProvider>(create: (_) => SettingsProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deep',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: icebreakerBackgroundColor,
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.grey.shade900,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: icebreakerBackgroundColor,
            foregroundColor: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.selected)) {
              return icebreakerTextColor;
            }
            return Colors.grey.shade400;
          }),
          trackColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.selected)) {
              return icebreakerBackgroundColor.withOpacity(0.5);
            }
            return Colors.grey.shade700;
          }),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: icebreakerBackgroundColor,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.dark,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  db_helper.Card? currentCard;

  // For swipe animation
  late AnimationController _swipeController;
  Offset _dragOffset = Offset.zero;
  bool _isDragging = false;

  // Helper to convert card type to display text
  String _getCardTypeText(GameCardType type) {
    switch (type) {
      case GameCardType.icebreaker:
        return icebreakerText.toUpperCase();
      case GameCardType.confession:
        return confessionText.toUpperCase();
      case GameCardType.deep:
        return deepText.toUpperCase();
      default:
        return '';
    }
  }

  // Helper to get card type color
  Color _getCardTypeColor(GameCardType type) {
    switch (type) {
      case GameCardType.icebreaker:
        return icebreakerBackgroundColor;
      case GameCardType.confession:
        return confessionBackgroundColor;
      case GameCardType.deep:
        return deepBackgroundColor;
      default:
        return Colors.grey;
    }
  }

  // Build swipeable card with visual feedback
  Widget _buildSwipeableCard() {
    if (currentCard == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: _getNextCard,
      onHorizontalDragStart: (details) {
        setState(() {
          _isDragging = true;
          _dragOffset = Offset.zero;
        });
      },
      onHorizontalDragUpdate: (details) {
        setState(() {
          _dragOffset += Offset(details.delta.dx, 0);
          // Limit the drag distance
          if (_dragOffset.dx.abs() > 150) {
            _dragOffset = Offset(_dragOffset.dx.sign * 150, 0);
          }
        });
      },
      onHorizontalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;

        // If dragged far enough or with enough velocity, go to next card
        if (_dragOffset.dx.abs() > 100 || velocity.abs() > 300) {
          _getNextCard();
        }

        // Reset position with animation
        setState(() {
          _isDragging = false;
          _dragOffset = Offset.zero;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.translationValues(_dragOffset.dx, 0, 0)
          ..rotateZ(_dragOffset.dx / 1000), // Slight rotation for better effect
        curve: Curves.easeOut,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: Column(
            key: ValueKey<int>(currentCard!.id),
            children: [
              // Swipe direction indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left swipe indicator
                  AnimatedOpacity(
                    opacity:
                        _dragOffset.dx < -20 ? (_dragOffset.dx.abs() / 150) : 0,
                    duration: const Duration(milliseconds: 50),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ColorUtils.withOpacity(Colors.white, 0.8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),

                  // Right swipe indicator
                  AnimatedOpacity(
                    opacity:
                        _dragOffset.dx > 20 ? (_dragOffset.dx.abs() / 150) : 0,
                    duration: const Duration(milliseconds: 50),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ColorUtils.withOpacity(Colors.white, 0.8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),

              // The actual card
              GameCard(
                description: currentCard!.description,
                config: getConfigForType(currentCard!.cardType),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // Initialize swipe animation controller
    _swipeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Use a post-frame callback to ensure the context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cardService = context.read<CardService>();
      // Connect CardService to SettingsProvider
      cardService.setSettingsProvider(context);
      _initializeCard();
    });
  }

  @override
  void dispose() {
    _swipeController.dispose();
    super.dispose();
  }

  Future<void> _initializeCard() async {
    var cardService = context.read<CardService>();
    currentCard = await cardService.getNextCard();
    setState(() {});
  }

  Future<void> _getNextCard() async {
    var cardService = context.read<CardService>();
    currentCard = await cardService.getNextCard();
    setState(() {});
  }

  // No internal options menu implementation since we're using the separate module

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text('Deep Conversations...',
            style: TextStyle(color: Colors.white)),
        actions: [
          DeepButton(
            onPressed: () => showOptionsMenu(context, _getNextCard),
            icon: Icons.tune,
          ),
        ],
      ),
      body: currentCard == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // Main card display with swiper
                Column(
                  children: [
                    Expanded(
                      child: _buildSwipeableCard(),
                    ),

                    // Swipe instructions
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Card counter
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: ColorUtils.withOpacity(Colors.white, 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Consumer<CardService>(
                              builder: (context, cardService, _) {
                                return Text(
                                  'Cards: ${cardService.filteredCards.length}',
                                  style: TextStyle(
                                    color: ColorUtils.withOpacity(
                                        Colors.white, 0.7),
                                    fontSize: 12,
                                  ),
                                );
                              },
                            ),
                          ),

                          // Swipe hint
                          Row(
                            children: [
                              Icon(
                                Icons.swipe,
                                color:
                                    ColorUtils.withOpacity(Colors.white, 0.6),
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Swipe or tap for next card',
                                style: TextStyle(
                                  color:
                                      ColorUtils.withOpacity(Colors.white, 0.6),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          // Shuffle indicator
                          Consumer<SettingsProvider>(
                            builder: (context, settings, _) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: settings.shuffleEnabled
                                      ? Colors.deepPurple.withOpacity(0.3)
                                      : Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      settings.shuffleEnabled
                                          ? Icons.shuffle
                                          : Icons.sort,
                                      color: Colors.white.withOpacity(0.7),
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      settings.shuffleEnabled
                                          ? 'Random'
                                          : 'Sequential',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Type indicator pill at bottom
                Positioned(
                  bottom: 70,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getCardTypeColor(currentCard!.cardType),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        _getCardTypeText(currentCard!.cardType),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
