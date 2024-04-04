import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, bool?> _isConnected = {
    'Deutsche Bahn': false,
    'Lufthansa': false,
    'Lime': false,
  };

  Future<void> _connectService(String service) async {
    setState(() {
      _isConnected[service] = null; // null indicates loading
    });

    await Future.delayed(Duration(milliseconds: 500)); // Simulate loading/connection time

    setState(() {
      _isConnected[service] = true; // Simulate successful connection
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('Language'),
              trailing: DropdownButton<String>(
                value: 'en',
                onChanged: (String? newValue) {
                  // setState and logic to handle language change
                },
                items: <String>['en', 'de'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: <Widget>[
                        Text(value == 'en' ? '🇺🇸' : '🇩🇪'),
                        SizedBox(width: 8),
                        Text(value.toUpperCase()),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log Out'),
              onTap: () {
                // Insert logout logic here
              },
            ),

            SizedBox(height: MediaQuery.of(context).size.height / 2.5), // Adjust space as needed

            _buildConnectOption(
              'Deutsche Bahn',
              Colors.red,
              'assets/images/deutschebahn_logo.png',
            ),
            _buildConnectOption(
              'Lufthansa',
              Colors.red,
              'assets/images/lufthansa_logo.png',
            ),
            _buildConnectOption(
              'Lime',
              Colors.red,
              'assets/images/lime_logo.png',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectOption(String title, Color initialColor, String logoPath) {
    final isLoading = _isConnected[title] == null;
    final isConnected = _isConnected[title] == true;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 7.0),
      child: ListTile(
        leading: isLoading
            ? SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 3.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Image.asset(logoPath, width: 35),
        title: Text(title, style: TextStyle(color: isConnected ? Colors.white : Colors.white)),
        tileColor: isConnected ? Colors.green : initialColor,
        onTap: () => !isConnected && !isLoading ? _connectService(title) : null,
      ),
    );
  }
}
