import 'package:deep/game_card.dart';
import 'package:deep/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:math';

// Use a specific import with alias to avoid conflicts
import 'package:deep/database/database_helper.dart' as db_helper;

class CardService {
  final db_helper.AppDatabase _database;
  final Completer<void> _initialized = Completer<void>();
  SettingsProvider? _settingsProvider;

  // Use a more specific type name to avoid conflicts
  List<db_helper.Card> cards = [];
  List<db_helper.Card> filteredCards = [];
  int currentIndex = 0;
  
  // Getter for shuffle state
  bool get shuffleEnabled => 
      _settingsProvider?.shuffleEnabled ?? true;
  
  // Card type filter getters
  bool get showIcebreakers => 
      _settingsProvider?.showIcebreakers ?? true;
  bool get showConfessions => 
      _settingsProvider?.showConfessions ?? true;
  bool get showDeeps => 
      _settingsProvider?.showDeeps ?? true;

  // Constructor: Initializes the cards by calling _initializeCards
  CardService(this._database) {
    _initializeCards();
  }
  
  // Set the settings provider 
  void setSettingsProvider(BuildContext context) {
    if (_settingsProvider == null) {
      _settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
      _updateFilteredCards();
      
      // Listen for changes to update filtered cards
      _settingsProvider!.addListener(() {
        _updateFilteredCards();
      });
    }
  }

  // Method to initialize cards from the database
  Future<void> _initializeCards() async {
    var dbCards = await _database.getAllCards();

    cards = dbCards;
    _updateFilteredCards();
    
    _initialized.complete(); // Complete the completer when initialization is done
  }

  // Method to get cards based on type, waits for initialization to complete
  Future<List<db_helper.Card>> getCards({GameCardType type = GameCardType.none}) async {
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
  Future<db_helper.Card> getCardById(int id) async {
    await _initialized.future; // Ensure initialization is complete
    return cards.firstWhere((element) => element.id == id);
  }

  // Update the filtered cards based on current filter settings
  void _updateFilteredCards() {
    filteredCards = cards.where((card) {
      switch (card.cardType) {
        case GameCardType.icebreaker:
          return showIcebreakers;
        case GameCardType.confession:
          return showConfessions;
        case GameCardType.deep:
          return showDeeps;
        default:
          return true;
      }
    }).toList();
    
    // Reset index if out of bounds
    if (currentIndex >= filteredCards.length && filteredCards.isNotEmpty) {
      currentIndex = 0;
    }
  }

  // Toggle filter for a specific card type
  void toggleCardTypeFilter(GameCardType type, bool value) {
    if (_settingsProvider != null) {
      _settingsProvider!.toggleCardType(type, value);
      _updateFilteredCards();
    }
  }

  // Toggle shuffle mode
  void toggleShuffle(bool value) {
    if (_settingsProvider != null) {
      _settingsProvider!.toggleShuffle(value);
    }
  }

  // Get the next card (either randomly or sequentially)
  Future<db_helper.Card?> getNextCard() async {
    await _initialized.future; // Ensure initialization is complete
    
    if (filteredCards.isEmpty) {
      return null;
    }
    
    if (shuffleEnabled) {
      return getRandomCard();
    } else {
      final card = filteredCards[currentIndex];
      currentIndex = (currentIndex + 1) % filteredCards.length;
      return card;
    }
  }

  // Method to get a random card, waits for initialization to complete
  Future<db_helper.Card> getRandomCard() async {
    await _initialized.future; // Ensure initialization is complete
    
    if (filteredCards.isEmpty) {
      throw Exception('No cards available with current filters');
    }
    
    var randomIndex = Random().nextInt(filteredCards.length);
    return filteredCards[randomIndex];
  }
}