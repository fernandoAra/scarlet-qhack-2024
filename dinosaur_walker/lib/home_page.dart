import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'coins_provider.dart'; // Make sure this import points to where your CoinsProvider class is defined

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
                    decoration: InputDecoration(hintText: 'Enter distance traveled'),
                    keyboardType: TextInputType.number,
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
                int distance = int.tryParse(localDistanceController.text) ?? 0;
                int points = 0;
                switch (selectedTransport) {
                  case 'car':
                    points = distance;
                    break;
                  case 'train':
                    points = distance * 2;
                    break;
                  case 'bike':
                    points = distance * 5;
                    break;
                }
                Provider.of<CoinsProvider>(context, listen: false).addCoins(points); // Add coins using the Provider
                setState(() {
                  _messages.add("Used $selectedTransport and traveled $distance km gaining $points points");
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
    // Accessing the current coins count
    final coins = Provider.of<CoinsProvider>(context).coins;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Total Coins: $coins'), // Display the total coins
      // ),
      body: ListView.builder(
        itemCount: _messages.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(_messages[index]),
        ),
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
