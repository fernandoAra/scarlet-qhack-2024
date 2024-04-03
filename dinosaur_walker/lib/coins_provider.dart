import 'package:flutter/foundation.dart';

class CoinsProvider with ChangeNotifier {
  int _coins = 0;

  int get coins => _coins;

  void addCoins(int points) {
    _coins += points;
    notifyListeners();
  }
}