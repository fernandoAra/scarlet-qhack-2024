import 'package:flutter/foundation.dart';

class ExpProvider with ChangeNotifier {
  int _exp = 0;
  int _level = 1;

  int get exp => _exp;
  int get level => _level;

  final List<int> _expThresholds = [100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000];

  void addExp(int points) {
    _exp += points;
    while (_level < _expThresholds.length - 1 && _exp >= _expThresholds[_level]) {
      _level++;
      // Additional logic for leveling up
    }
    notifyListeners();
  }

  int get expToNextLevel => _level < _expThresholds.length ? _expThresholds[_level] - _exp : 0;
  double get progressToNextLevel {
    if (_level >= _expThresholds.length - 1) {
      return 1.0; // Max level reached
    }
    int currentLevelExp = _expThresholds[_level - 1];
    int nextLevelExp = _expThresholds[_level];
    return (_exp - currentLevelExp) / (nextLevelExp - currentLevelExp);
  }
}

