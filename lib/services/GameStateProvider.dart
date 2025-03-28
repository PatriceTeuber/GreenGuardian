import 'package:flutter/material.dart';
import 'package:green_guardian/game/entities/items/Item.dart';

import '../models/gameData.dart';

class GameStateProvider with ChangeNotifier {

  double _playerHealth = 100;
  double _maxPlayerHealth = 100;
  int _currency = 1000;
  double _playerXP = 0;
  double _bossHealth = 100;
  String _bossName = "Placeholder";
  int _bossLevel = 1;
  List<Item> _items = [];

  double get playerHealth => _playerHealth;
  int get currency => _currency;
  double get playerXP => _playerXP;
  double get bossHealth => _bossHealth;
  double get maxPlayerHealth => _maxPlayerHealth;
  List<Item> get items => _items;
  int get bossLevel => _bossLevel;
  String get bossName => _bossName;

  GameData get currentGameData => GameData(
    playerHealth: _playerHealth,
    maxPlayerHealth: _maxPlayerHealth,
    currency: _currency,
    playerXP: _playerXP,
    bossHealth: _bossHealth,
    bossName: _bossName,
    bossLevel: _bossLevel,
    items: _items,
  );

  void setGameData(GameData newData) {
    _playerHealth = newData.playerHealth;
    _maxPlayerHealth = newData.maxPlayerHealth;
    _currency = newData.currency;
    _playerXP = newData.playerXP;
    _bossHealth = newData.bossHealth;
    _bossName = newData.bossName;
    _bossLevel = newData.bossLevel;
    _items = newData.items;
    notifyListeners();
  }

  void updatePlayerHealth(double newHealth) {
    _playerHealth = newHealth;
    notifyListeners();
  }

  void updateCurrency(int newCurrency) {
    _currency = newCurrency;
    notifyListeners();
  }

  void updatePlayerXP(double newXP) {
    _playerXP = newXP;
    notifyListeners();
  }

  void updateBossHealth(double newHealth) {
    _bossHealth = newHealth;
    notifyListeners();
  }

  void updateItmes(List<Item> items) {
    _items = items;
    notifyListeners();
  }

  void updateBoss(int bossLevel, String bossName) {
    _bossLevel = bossLevel;
    _bossName = bossName;
    notifyListeners();
  }
}
