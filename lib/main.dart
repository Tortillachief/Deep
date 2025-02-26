import 'package:deep/card_service.dart';
import 'package:deep/database/database_helper.dart' as db_helper;
import 'package:flutter/material.dart';
import 'package:deep/game_card.dart';
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
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deep',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  db_helper.Card? currentCard;

  @override
  void initState() {
    super.initState();
    _initializeRandomCard();
  }

  Future<void> _initializeRandomCard() async {
    var cardService = context.read<CardService>();
    currentCard = await cardService.getRandomCard();
    setState(() {});
  }

  Future<void> _getRandomCard() async {
    var cardService = context.read<CardService>();
    currentCard = await cardService.getRandomCard();
    setState(() {});
  }

  var backGroundColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        actions: [
          DeepButton(
            onPressed: () {
              print("object");
            },
            icon: Icons.settings,
          ),
        ],
      ),
      body: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.horizontal,
        onDismissed: (direction) {
          _getRandomCard();
        },
        child: Column(
          children: [
            if (currentCard != null)
              GameCard(
                description: currentCard!.description,
                config: getConfigForType(currentCard!.cardType),
              ),
          ],
        ),
      ),
    );
  }
}

class DeepButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;

  const DeepButton(
      {super.key, required this.onPressed, this.icon = Icons.settings});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0), // Add margin to the right
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: IconButton(
          icon: Icon(icon),
          color: Colors.black,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
