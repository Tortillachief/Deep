import 'package:deep/database/database_helper.dart';
import 'package:deep/game_card.dart';
import 'dart:async';
import 'dart:math';

class CardService {
  final AppDatabase _database;
  final Completer<void> _initialized = Completer<void>();

  List<Card> cards = [];

  // Constructor: Initializes the cards by calling _initializeCards
  CardService(this._database) {
    _initializeCards();
  }

  // Method to initialize cards from the database
  Future<void> _initializeCards() async {
    var dbCards = await _database.getAllCards();

    var icebreakers = dbCards.where((element) => element.cardType == GameCardType.icebreaker);
    var confessions = dbCards.where((element) => element.cardType == GameCardType.confession);
    var deeps = dbCards.where((element) => element.cardType == GameCardType.deep);

    cards = [
      ...icebreakers,
      ...confessions,
      ...deeps,
    ];

    _initialized.complete(); // Complete the completer when initialization is done
  }

  // Method to get cards based on type, waits for initialization to complete
  Future<List<Card>> getCards({GameCardType type = GameCardType.none}) async {
    await _initialized.future; // Ensure initialization is complete
    switch (type) {
      case GameCardType.icebreaker:
        return cards.where((element) => element.cardType == GameCardType.icebreaker).toList();
      case GameCardType.confession:
        return cards.where((element) => element.cardType == GameCardType.confession).toList();
      case GameCardType.deep:
        return cards.where((element) => element.cardType == GameCardType.deep).toList();
      case GameCardType.none:
        return cards;
    }
  }

  // Method to get a card by ID, waits for initialization to complete
  Future<Card> getCardById(int id) async {
    await _initialized.future; // Ensure initialization is complete
    return cards.firstWhere((element) => element.id == id);
  }

  // Method to get a random card, waits for initialization to complete
  Future<Card> getRandomCard() async {
    await _initialized.future; // Ensure initialization is complete
    var randomIndex = Random().nextInt(cards.length);
    return cards[randomIndex];
  }
}