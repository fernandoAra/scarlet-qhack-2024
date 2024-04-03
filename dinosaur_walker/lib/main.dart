import 'package:flutter/material.dart';
import 'home_page.dart';
import 'left1.dart';
import 'right1.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        initialIndex: 1,  // Set the Home page to be the one in the middle
        child: Scaffold(
          appBar: AppBar(
            title: Text('Tabbed Navigation Demo'),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.search), text: "First"),
                Tab(icon: Icon(Icons.home), text: "Home"),
                Tab(icon: Icon(Icons.notifications), text: "Second"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Left1(),
              MyHomePage(),
              Right1(),
            ],
          ),
        ),
      ),
    );
  }
}
