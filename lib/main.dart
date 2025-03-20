import 'package:deep/card_service.dart';
import 'package:deep/constants.dart';
import 'package:deep/database/database_helper.dart' as db_helper;
import 'package:flutter/material.dart';
import 'package:deep/game_card.dart';
import 'package:deep/settings_provider.dart';
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
    ChangeNotifierProvider<SettingsProvider>(
        create: (_) => SettingsProvider()),
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

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  db_helper.Card? currentCard;
  final backgroundColor = Colors.grey.shade900;
  
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
        return Colors.blue;
      case GameCardType.confession:
        return Colors.amber.shade700;
      case GameCardType.deep:
        return Colors.deepPurple;
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
                    opacity: _dragOffset.dx < -20 ? (_dragOffset.dx.abs() / 150) : 0,
                    duration: const Duration(milliseconds: 50),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
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
                    opacity: _dragOffset.dx > 20 ? (_dragOffset.dx.abs() / 150) : 0,
                    duration: const Duration(milliseconds: 50),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
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

  void _showOptionsMenu() {
    final cardService = context.read<CardService>();
    final settingsProvider = context.read<SettingsProvider>();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade800,
      isScrollControlled: true,
      elevation: 20,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Card Options',
                        style: TextStyle(
                          fontSize: 24, 
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Stats section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatTile(
                          title: 'Total Cards', 
                          value: cardService.cards.length.toString(),
                          icon: Icons.library_books,
                        ),
                        _buildStatTile(
                          title: 'Active Cards', 
                          value: cardService.filteredCards.length.toString(),
                          icon: Icons.check_circle_outline,
                        ),
                        _buildStatTile(
                          title: 'Filters Active', 
                          value: (!settingsProvider.showIcebreakers || 
                                 !settingsProvider.showConfessions || 
                                 !settingsProvider.showDeeps) ? 'Yes' : 'No',
                          icon: Icons.filter_list,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Shuffle toggle
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: settingsProvider.shuffleEnabled 
                          ? Colors.deepPurple.withOpacity(0.3) 
                          : Colors.black26,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SwitchListTile(
                      title: Row(
                        children: [
                          Icon(
                            settingsProvider.shuffleEnabled 
                                ? Icons.shuffle 
                                : Icons.sort,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Shuffle Cards',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        settingsProvider.shuffleEnabled
                            ? 'Cards will appear in random order'
                            : 'Cards will appear in sequence',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      value: settingsProvider.shuffleEnabled,
                      onChanged: (value) {
                        setModalState(() {
                          settingsProvider.toggleShuffle(value);
                          cardService.toggleShuffle(value);
                        });
                      },
                      activeColor: Colors.deepPurple,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white24),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Card Types',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      
                      // Reset filters button
                      TextButton.icon(
                        onPressed: () {
                          setModalState(() {
                            settingsProvider.resetSettings();
                            // Update CardService with new settings
                            cardService.toggleCardTypeFilter(GameCardType.icebreaker, true);
                            cardService.toggleCardTypeFilter(GameCardType.confession, true);
                            cardService.toggleCardTypeFilter(GameCardType.deep, true);
                            cardService.toggleShuffle(true);
                          });
                        },
                        icon: const Icon(Icons.refresh, size: 16, color: Colors.white70),
                        label: const Text('Reset', style: TextStyle(color: Colors.white70)),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Card type selectors
                  _buildCardTypeSelector(
                    setModalState: setModalState,
                    title: 'Icebreakers',
                    subtitle: 'Casual conversation starters',
                    color: Colors.blue,
                    isActive: settingsProvider.showIcebreakers,
                    onToggle: (value) {
                      cardService.toggleCardTypeFilter(GameCardType.icebreaker, value);
                      settingsProvider.toggleCardType(GameCardType.icebreaker, value);
                    },
                  ),
                  
                  const SizedBox(height: 10),
                  
                  _buildCardTypeSelector(
                    setModalState: setModalState,
                    title: 'Confessions',
                    subtitle: 'Personal experiences and stories',
                    color: Colors.amber.shade700,
                    isActive: settingsProvider.showConfessions,
                    onToggle: (value) {
                      cardService.toggleCardTypeFilter(GameCardType.confession, value);
                      settingsProvider.toggleCardType(GameCardType.confession, value);
                    },
                  ),
                  
                  const SizedBox(height: 10),
                  
                  _buildCardTypeSelector(
                    setModalState: setModalState,
                    title: 'Deep',
                    subtitle: 'Thought-provoking questions',
                    color: Colors.deepPurple,
                    isActive: settingsProvider.showDeeps,
                    onToggle: (value) {
                      cardService.toggleCardTypeFilter(GameCardType.deep, value);
                      settingsProvider.toggleCardType(GameCardType.deep, value);
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _getNextCard(); // Get next card with new filters
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        elevation: 5,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check),
                          SizedBox(width: 8),
                          Text('Apply Filters', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  
  // Helper method to build stats tiles
  Widget _buildStatTile({required String title, required String value, required IconData icon}) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 22),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
  
  // Helper method to build card type selectors
  Widget _buildCardTypeSelector({
    required StateSetter setModalState,
    required String title,
    required String subtitle,
    required Color color,
    required bool isActive,
    required Function(bool) onToggle,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isActive ? color.withOpacity(0.3) : Colors.black26,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        title: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.white70),
        ),
        value: isActive,
        onChanged: (value) {
          setModalState(() {
            onToggle(value);
          });
        },
        activeColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text('Deep Cards', style: TextStyle(color: Colors.white)),
        actions: [
          DeepButton(
            onPressed: _showOptionsMenu,
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
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Card counter
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Consumer<CardService>(
                              builder: (context, cardService, _) {
                                return Text(
                                  'Cards: ${cardService.filteredCards.length}',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
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
                                color: Colors.white.withOpacity(0.6),
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Swipe or tap for next card',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          
                          // Shuffle indicator
                          Consumer<SettingsProvider>(
                            builder: (context, settings, _) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                                      settings.shuffleEnabled ? 'Random' : 'Sequential',
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
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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

class DeepButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;

  const DeepButton({
    super.key, 
    required this.onPressed, 
    this.icon = Icons.settings,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20.0),
            onTap: onPressed,
            child: Center(
              child: Icon(
                icon,
                color: Colors.black,
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
