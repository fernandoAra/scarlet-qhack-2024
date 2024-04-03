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
  String selectedTransport = _selectedTransport; // Local variable for dialog's selected transport
  final TextEditingController localDistanceController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Add a new trip'),
        content: StatefulBuilder( // Ensuring we can rebuild the dialog's content
          builder: (BuildContext context, StateSetter setDialogState) {
            return Column(
              mainAxisSize: MainAxisSize.min, // Use minimum size for the content
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
                  keyboardType: TextInputType.number, // Ensure numeric keyboard for numbers
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
              // Update the main widget state, not the local dialog state
              setState(() {
                _messages.add("Used $selectedTransport and gained $points points");
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
