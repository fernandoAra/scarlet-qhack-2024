import 'package:flutter/material.dart';
import 'home_page.dart';
import 'left1.dart';
import 'store.dart';
import 'package:provider/provider.dart';
import 'coins_provider.dart'; // Ensure this is the correct path to your CoinsProvider class

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CoinsProvider(),
      child: MaterialApp(
        home: DefaultTabController(
          length: 3,
          initialIndex: 1,  // Set the Home page to be the one in the middle
          child: Scaffold(
            appBar: AppBar(
              title: Consumer<CoinsProvider>(
                builder: (context, coinsProvider, child) => Text('Total Coins: ${coinsProvider.coins}'),
              ),
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.search), text: "First"),
                  Tab(icon: Icon(Icons.home), text: "Home"),
                  Tab(icon: Icon(Icons.store), text: "Store"),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                Left1(),
                MyHomePage(),
                Store(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
