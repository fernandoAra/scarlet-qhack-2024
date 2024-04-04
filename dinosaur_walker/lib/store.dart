// store.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'coins_provider.dart'; // Import your CoinsProvider
import 'inventory_provider.dart';
import 'exp_provider.dart';
// import 'store_item.dart'; // Import StoreItem model

class StoreItem {
  final String name;
  final int cost;
  final int levelRequirement; // New property

  StoreItem({required this.name, required this.cost, required this.levelRequirement});
}

class Store extends StatelessWidget {
  // Example store items
  final List<StoreItem> items = [
    StoreItem(name: "Top Hat", cost: 10, levelRequirement: 1),
    StoreItem(name: "Sombrero", cost: 200, levelRequirement: 12),
    StoreItem(name: "Bird Pet (Coming Soon)", cost: 310, levelRequirement: 50),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          title: Text(item.name),
          subtitle: Text("Cost: ${item.cost} coins \n Level Requirement = ${item.levelRequirement}"),
          trailing: Consumer<InventoryProvider>(
            builder: (context, inventoryProvider, child) {
              final isOwned = inventoryProvider.isItemOwned(item);
              final isEquipped = inventoryProvider.isItemEquipped(item);
              final coinsProvider = Provider.of<CoinsProvider>(context, listen: false);
              
              return ElevatedButton(
                onPressed: () {
                  if (!isOwned && coinsProvider.coins >= item.cost) {
                    // Deduct coins and add the item to inventory
                    coinsProvider.addCoins(-item.cost);
                    inventoryProvider.purchaseItem(item, item.cost, coinsProvider.coins);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Purchased ${item.name}!')),
                    );
                  } else if (isOwned) {
                    inventoryProvider.equipItem(item); // Equip or Unequip the item
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Not enough coins.')),
                    );
                  }
                },
                child: Text(isOwned ? isEquipped ? "Unequip" : "Equip" : "Buy"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEquipped ? Colors.green : null,
                ),
              );
            },
          ),

        );
      },
    );
  }
}
