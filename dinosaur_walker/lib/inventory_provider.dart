import 'package:flutter/foundation.dart';
import 'store.dart';

class InventoryProvider with ChangeNotifier {
  final List<StoreItem> _itemsOwned = [];
  StoreItem? _equippedItem;

  List<StoreItem> get itemsOwned => List.unmodifiable(_itemsOwned);
  StoreItem? get equippedItem => _equippedItem;

bool purchaseItem(StoreItem item, int cost, int currentCoins) {
  if (!isItemOwned(item)) {
    _itemsOwned.add(item);
    notifyListeners();
    return true; // Item successfully purchased
  }
  return false; // Item was not purchased (already owned)
}


  void equipItem(StoreItem item) {
    if (isItemOwned(item)) {
      _equippedItem = _equippedItem == item ? null : item;
      notifyListeners();
    }
  }

  bool isItemEquipped(StoreItem item) {
    return _equippedItem?.name == item.name;
  }

  bool isItemOwned(StoreItem item) {
    return _itemsOwned.any((ownedItem) => ownedItem.name == item.name);
  }
}
