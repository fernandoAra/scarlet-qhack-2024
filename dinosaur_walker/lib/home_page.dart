import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'coins_provider.dart'; // Make sure this import points to where your CoinsProvider class is defined
import 'exp_provider.dart';

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
    return Scaffold(
      body: Column(
        children: <Widget>[
          // Place the GIF at the top of the body, just below the AppBar
          Center(
            child: Container(
              height: 368.0, // Adjust the size to fit your design
              width: 500.0,
              child: Image.asset('assets/animations/dino_run1.gif'),
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
