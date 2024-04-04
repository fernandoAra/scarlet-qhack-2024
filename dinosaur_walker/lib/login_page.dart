import 'package:flutter/material.dart';
import 'main.dart';
import 'user_provider.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false; // Added to track loading state

  void _signIn(BuildContext context, {String providerName = ''}) async {
    // If signing in with a provider, use a predetermined username format
    if (providerName.isNotEmpty) {
      final username = '$providerName User #${Random().nextInt(9999)}'; // Example format
      Provider.of<UserProvider>(context, listen: false).setUsername(username);
    } else if (_usernameController.text.isNotEmpty){
      // Otherwise, use the username from the input field
      Provider.of<UserProvider>(context, listen: false).setUsername(_usernameController.text);
    } else {
      Provider.of<UserProvider>(context, listen: false).setUsername('Dino #${Random().nextInt(9999)}'); 
    }
    setState(() {
      _isLoading = true; // Start the loading animation
    });

    // Simulate the login process with a delay
    await Future.delayed(Duration(milliseconds: 500));

    // If successful login, proceed to HomePage
    // Replace this with your actual login logic
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
    );

    setState(() {
      _isLoading = false; // End the loading animation
    });
  }

  Widget _buildSocialLoginButton(BuildContext context, String serviceName, String logoPath, String providerName) {
    return ElevatedButton.icon(
      onPressed: () => _signIn(context, providerName: providerName),
      icon: Image.asset(logoPath, height: 24),
      label: Text('Sign in with $serviceName'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, // backgroundColor is deprecated and replaced with primary
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator() // Show loading indicator during the loading state
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logo.png', height: 120),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(labelText: 'Username'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                      child: TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _signIn(context),
                      child: Text('Sign In'),
                    ),
                    SizedBox(height: 20),
                    Text('Or sign in with'),
                    SizedBox(height: 10),
                    _buildSocialLoginButton(context, 'Deutsche Bahn', 'assets/images/deutschebahn_logo.png', 'Deutsche Bahn'),
                    _buildSocialLoginButton(context, 'Lime', 'assets/images/lime_logo.png', 'Lime'),
                    _buildSocialLoginButton(context, 'Lufthansa', 'assets/images/lufthansa_logo.png', 'Lufthansa'),
                  ],
                ),
              ),
      ),
    );
  }
}
