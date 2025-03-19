import 'package:flutter/material.dart';
import 'package:deep/game_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  late SharedPreferences _prefs;
  bool _isInitialized = false;

  // Default values
  bool _shuffleEnabled = true;
  bool _showIcebreakers = true;
  bool _showConfessions = true;
  bool _showDeeps = true;
  
  // Getters
  bool get isInitialized => _isInitialized;
  bool get shuffleEnabled => _shuffleEnabled;
  bool get showIcebreakers => _showIcebreakers;
  bool get showConfessions => _showConfessions;
  bool get showDeeps => _showDeeps;
  
  // Constructor that initializes SharedPreferences
  SettingsProvider() {
    _initPrefs();
  }
  
  // Keys for SharedPreferences
  static const String _shuffleKey = 'shuffle_enabled';
  static const String _icebreakersKey = 'show_icebreakers';
  static const String _confessionsKey = 'show_confessions';
  static const String _deepsKey = 'show_deeps';
  
  // Initialize and load settings
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadSettings();
    _isInitialized = true;
    notifyListeners();
  }
  
  // Load settings from SharedPreferences
  void _loadSettings() {
    _shuffleEnabled = _prefs.getBool(_shuffleKey) ?? true;
    _showIcebreakers = _prefs.getBool(_icebreakersKey) ?? true;
    _showConfessions = _prefs.getBool(_confessionsKey) ?? true;
    _showDeeps = _prefs.getBool(_deepsKey) ?? true;
  }
  
  // Toggle shuffle mode
  void toggleShuffle(bool value) {
    _shuffleEnabled = value;
    _prefs.setBool(_shuffleKey, value);
    notifyListeners();
  }
  
  // Toggle card type filter
  void toggleCardType(GameCardType type, bool value) {
    switch (type) {
      case GameCardType.icebreaker:
        _showIcebreakers = value;
        _prefs.setBool(_icebreakersKey, value);
        break;
      case GameCardType.confession:
        _showConfessions = value;
        _prefs.setBool(_confessionsKey, value);
        break;
      case GameCardType.deep:
        _showDeeps = value;
        _prefs.setBool(_deepsKey, value);
        break;
      default:
        break;
    }
    notifyListeners();
  }
  
  // Get card type filter value
  bool getCardTypeFilter(GameCardType type) {
    switch (type) {
      case GameCardType.icebreaker:
        return _showIcebreakers;
      case GameCardType.confession:
        return _showConfessions;
      case GameCardType.deep:
        return _showDeeps;
      default:
        return true;
    }
  }
  
  // Reset all settings to defaults
  void resetSettings() {
    _shuffleEnabled = true;
    _showIcebreakers = true;
    _showConfessions = true;
    _showDeeps = true;
    
    _prefs.setBool(_shuffleKey, true);
    _prefs.setBool(_icebreakersKey, true);
    _prefs.setBool(_confessionsKey, true);
    _prefs.setBool(_deepsKey, true);
    
    notifyListeners();
  }
}