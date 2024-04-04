import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'coins_provider.dart'; // Make sure this import points to where your CoinsProvider class is defined
import 'exp_provider.dart';                                                                                                                                              
import 'inventory_provider.dart';
import 'store.dart';
import 'package:flutter/material.dart';
import 'user_provider.dart';
import 'dart:math';



class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class WeeklyChallenge {
  final String description;
  final double progress; // Progress as a fraction of 1 (e.g., 0.5 for 50%)

  WeeklyChallenge({required this.description, required this.progress});
}

class _MyHomePageState extends State<MyHomePage> {

  final List<WeeklyChallenge> _weeklyChallenges = [
    WeeklyChallenge(description: "CO2 saved  =  ${5}", progress: 1),
    WeeklyChallenge(description: "Invite (2) friends (1/2)", progress: 0.5),
    WeeklyChallenge(description: "Ride a bike for 10 km (8.1/10)", progress: 0.8),
    WeeklyChallenge(description: "Spend less on car than last week (3/10)", progress: 0.3),
    // Add more challenges as needed...
  ];

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
                    items: [
                      DropdownMenuItem(
                        value: 'car',
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.directions_car),
                            SizedBox(width: 10), // Provides space between the icon and the text
                            Text('Car'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'train',
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.directions_train),
                            SizedBox(width: 10),
                            Text('Train'),
                          ],
                        ),
                      ),
                      // Add other transport options in a similar manner
                      DropdownMenuItem(
                        value: 'bike',
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.directions_bike),
                            SizedBox(width: 10),
                            Text('Bike'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'plane',
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.airplanemode_active),
                            SizedBox(width: 10),
                            Text('Plane'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'walking',
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.directions_walk),
                            SizedBox(width: 10),
                            Text('Walking'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'e-car',
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.electric_car),
                            SizedBox(width: 10),
                            Text('E-Car'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'scooter',
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.electric_scooter),
                            SizedBox(width: 10),
                            Text('Scooter'),
                          ],
                        ),
                      ),
                    ],
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
                    points = (distance.round() * 2.round());
                    expPoints = (distance.round() * 2.9.round());
                    break;
                  case 'bike':
                    points = (distance.round() * 5.round());
                    expPoints = (distance.round() * 4.2.round());
                    break;
                  case 'plane':
                    points = (distance.round() * 0.01).round();
                    expPoints = (distance.round() * 0.001).round()  * 2;
                    break;
                  case 'walking':
                    points = (distance.round() * 7.round());
                    expPoints = (distance.round() * 12.round());
                    break;
                  case 'e-car':
                    points = (distance.round() * 1.2).round();
                    expPoints = (distance.round() * 1.7).round();
                    break;
                  case 'scooter':
                    points = (distance.round() * 4.round());
                    expPoints = (distance.round() * 4.2).round();
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
    final userProvider = Provider.of<UserProvider>(context);
    final String userName = userProvider.username.isNotEmpty ? userProvider.username : 'Dino #${Random().nextInt(9999)}';
    final isTopHatEquipped = Provider.of<InventoryProvider>(context).isItemEquipped(StoreItem(name: "Top Hat", cost: 10, levelRequirement: 1)); // Example check
    final colorValue = _usernameToColorValue(userName);
    final color = Color(colorValue).withOpacity(0.3); // Adjust opacity as needed

    return Scaffold(
      body: Column(
        children: <Widget>[
          Text(userName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), // Display the username
          Center(
            child: Stack(
              alignment: Alignment.bottomCenter, // Adjust based on how you want to position the hat relative to the character
              children: [
                // Your character image
                ColorFiltered(
                  colorFilter: ColorFilter.mode(color, BlendMode.srcATop),
                  child: Image.asset('assets/animations/character_global1.gif', height: 384.0, width: 384.0),
                ),
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
              itemCount: _weeklyChallenges.length,
               itemBuilder: (context, index) {
                final challenge = _weeklyChallenges[index];
                return Container(
                  width: 200.0,
                  margin: EdgeInsets.all(8.0),
                  padding: EdgeInsets.all(8.0),
                  color: Colors.accents[index % Colors.accents.length],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        challenge.description,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: challenge.progress,
                        backgroundColor: Colors.grey[400],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ],
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

    int _usernameToColorValue(String username) {
      int hash = 0;
      for (int i = 0; i < username.length; i++) {
        hash = 31 * hash + username.codeUnitAt(i);
      }
      return hash;
    }
}
