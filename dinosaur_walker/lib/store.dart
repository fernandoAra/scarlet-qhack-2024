// store.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'coins_provider.dart'; // Import your CoinsProvider
import 'inventory_provider.dart';
// import 'store_item.dart'; // Import StoreItem model

class StoreItem {
  final String name;
  final int cost;

  StoreItem({required this.name, required this.cost});
}

class Store extends StatelessWidget {
  // Example store items
  final List<StoreItem> items = [
    StoreItem(name: "Item 1", cost: 10),
    StoreItem(name: "Item 2", cost: 20),
    StoreItem(name: "Item 3", cost: 30),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          title: Text(item.name),
          subtitle: Text("Cost: ${item.cost} coins"),
          trailing: ElevatedButton(
            onPressed: () {
                final coinsProvider = Provider.of<CoinsProvider>(context, listen: false);
                final inventoryProvider = Provider.of<InventoryProvider>(context, listen: false);
                
                if (inventoryProvider.isItemOwned(item)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("You already own this item.")),
                  );
                } else if (inventoryProvider.purchaseItem(item, item.cost, coinsProvider.coins)) {
                  coinsProvider.addCoins(-item.cost);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Purchased ${item.name}!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Not enough coins.')),
                  );
              }
            },
            child: Text('Buy'),
          ),
        );
      },
    );
  }
}
