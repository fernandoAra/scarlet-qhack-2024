import 'package:flutter/foundation.dart';
import 'store.dart';

class InventoryProvider with ChangeNotifier {
  final List<StoreItem> _itemsOwned = [];

  List<StoreItem> get itemsOwned => List.unmodifiable(_itemsOwned);

  // Adds an item to the inventory if it's not already owned
  bool purchaseItem(StoreItem item, int cost, int currentCoins) {
    if (!_itemsOwned.contains(item) && currentCoins >= cost) {
      _itemsOwned.add(item);
      notifyListeners();
      return true;
    }
    return false;
  }

  // Check if an item is owned
  bool isItemOwned(StoreItem item) {
    return _itemsOwned.contains(item);
  }
}