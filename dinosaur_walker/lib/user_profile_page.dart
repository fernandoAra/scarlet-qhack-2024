import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  final String username;
  final int level;
  final String characterAsset; // Path to the character image

  const UserProfilePage({
    Key? key,
    required this.username,
    required this.level,
    required this.characterAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Username: $username', style: TextStyle(fontSize: 24)),
            SizedBox(height: 10),
            Text('Level: $level', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Image.asset(characterAsset, width: 100), // Display the character image
          ],
        ),
      ),
    );
  }
}
