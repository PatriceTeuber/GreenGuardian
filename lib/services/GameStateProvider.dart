import 'package:flutter/material.dart';

class GameStateProvider with ChangeNotifier {
  double _playerHealth = 100;
  double _maxPlayerHealth = 100;
  int _currency = 1000;
  double _playerXP = 0;
  double _bossHealth = 100;

  double get playerHealth => _playerHealth;
  int get currency => _currency;
  double get playerXP => _playerXP;
  double get bossHealth => _bossHealth;
  double get maxPlayerHealth => _maxPlayerHealth;

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
}
