import 'package:flutter/material.dart';
import 'dart:ui';

class UserProfilePage extends StatelessWidget {
  final String username;
  final int level;

  const UserProfilePage({
    Key? key,
    required this.username,
    required this.level,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Generate a color from the username
    final colorValue = _usernameToColorValue(username);
    final color = Color(colorValue).withOpacity(0.3); // Adjust opacity as needed

    return Scaffold(
      appBar: AppBar(
        title: Text(username),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(color, BlendMode.srcATop),
              child: Image.asset('assets/animations/character_global1.gif', width: 100),
            ),
            Text('Username: $username', style: TextStyle(fontSize: 24)),
            SizedBox(height: 10),
            Text('Level: $level', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }

  int _usernameToColorValue(String username) {
    int hash = 0;
    for (int i = 0; i < username.length; i++) {
      hash = 31 * hash + username.codeUnitAt(i);
    }
    return hash;
  }
}