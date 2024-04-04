import 'package:flutter/foundation.dart';

class CoinsProvider with ChangeNotifier {
  int _coins = 0;
  int _exp = 0;

  int get coins => _coins;
  int get exp => _exp;

  void addCoins(int points) {
    _coins += points;
    notifyListeners();
  }

  void addExp(int points) {
    _exp += points;
    notifyListeners();
  }

  void addDeutschBahnRewards() {
    _coins += 50;
    _exp += 105;
    notifyListeners();
    // This method simplifies adding the specific Deutsch Bahn rewards
  }
}
