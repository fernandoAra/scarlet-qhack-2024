import 'package:flutter/foundation.dart';


class UserProvider with ChangeNotifier {
  String _username = '';

  String get username => _username;

  void setUsername(String username) {
    _username = username;
    notifyListeners(); // Notify listeners about the change.
  }
}
