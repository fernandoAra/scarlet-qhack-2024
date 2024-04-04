import 'package:flutter/material.dart';
import 'home_page.dart';
import 'left1.dart';
import 'store.dart';
import 'package:provider/provider.dart';
import 'coins_provider.dart';
import 'inventory_provider.dart';
import 'exp_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CoinsProvider()),
        ChangeNotifierProvider(create: (context) => InventoryProvider()),
        ChangeNotifierProvider(create: (context) => ExpProvider()),
      ],
      child: MaterialApp(
        home: MainPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 1; // Home page is initially selected
  final PageController _pageController = PageController(initialPage: 1);

  void _onItemTapped(int index) {
    _pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Consumer<CoinsProvider>(
                builder: (context, coinsProvider, child) => Text('Coins: ${coinsProvider.coins}'),
              ),
            ),
            Expanded(
              child: Consumer<ExpProvider>(
                builder: (context, expProvider, child) => Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Level: ${expProvider.level}'),
                    SizedBox(height: 4), // Add some spacing
                    LinearProgressIndicator(
                      value: expProvider.progressToNextLevel,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          Left1(), // Your first tab content
          MyHomePage(), // Your home page content
          Store(), // Your store page where items can be bought
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Left1',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Store',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
