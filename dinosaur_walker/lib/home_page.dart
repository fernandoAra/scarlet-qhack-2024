import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'coins_provider.dart'; // Make sure this import points to where your CoinsProvider class is defined
import 'exp_provider.dart';
import 'inventory_provider.dart';
import 'store.dart';
import 'package:flutter/material.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _messages = [];
  String _selectedTransport = 'car';
  final TextEditingController _distanceController = TextEditingController();

  void _showAddMessageDialog() {
    String selectedTransport = _selectedTransport;
    final TextEditingController localDistanceController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a new trip'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: selectedTransport,
                    onChanged: (newValue) {
                      setDialogState(() => selectedTransport = newValue!);
                    },
                    items: ['car', 'train', 'bike']
                        .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                  ),
                  TextField(
                    controller: localDistanceController,
                    decoration: const InputDecoration(
                    hintText: 'Enter distance traveled',
                    suffixText: '(Km)',
                    ),
                    keyboardType: TextInputType.number, // Ensure numeric keyboard for numbers
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))],
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                double distance = double.tryParse(localDistanceController.text) ?? 0;
                int points = 0;
                int expPoints = 0;
                switch (selectedTransport) {
                  case 'car':
                    points = expPoints = distance.round(); // Assuming EXP is awarded the same way as coins
                    break;
                  case 'train':
                    points = expPoints = distance.round() * 2;
                    break;
                  case 'bike':
                    points = expPoints = distance.round() * 5;
                    break;
                }
                Provider.of<CoinsProvider>(context, listen: false).addCoins(points.round()); // Add coins using the Provider
                Provider.of<ExpProvider>(context, listen: false).addExp(expPoints); // Add EXP using the Provider

                setState(() {
                  _messages.add("Used $selectedTransport, traveled $distance km, gaining $points coins and $expPoints EXP");
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

 @override
  Widget build(BuildContext context) {
    final isTopHatEquipped = Provider.of<InventoryProvider>(context).isItemEquipped(StoreItem(name: "Top Hat", cost: 10, levelRequirement: 1)); // Example check

    return Scaffold(
      body: Column(
        children: <Widget>[
          Center(
            child: Stack(
              alignment: Alignment.bottomCenter, // Adjust based on how you want to position the hat relative to the character
              children: [
                // Your character image
                Image.asset('assets/animations/dino_run2.gif', height: 384.0, width: 384.0),
                // Conditionally display the top hat
                if (isTopHatEquipped) 
                  Positioned(
                    bottom: 300, // Adjust positioning based on your images
                    child: Image.asset('assets/images/top_hat.png', height: 50), // Adjust size as needed
                  ),
              ],
            ),
          ),
          SizedBox(height: 0), // Space between the GIF and the card list
          Container(
            // Set a height for the horizontal list container
            height: 120.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10, // Example item count
              itemBuilder: (context, index) {
                return Container(
                  width: 200.0, // Set card width
                  height: 10.0, // Set card height, though it's dictated by the ListView height
                  margin: EdgeInsets.all(3.0), // Add some spacing around each card
                  color: Colors.accents[index % Colors.accents.length], // Example colorful background
                  child: Center(
                    child: Text(
                      'Card $index',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(_messages[index]),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMessageDialog,
        tooltip: 'Add Trip',
        child: Icon(Icons.add),
      ),
    );
  }


  @override
  void dispose() {
    _distanceController.dispose();
    super.dispose();
  }
}
