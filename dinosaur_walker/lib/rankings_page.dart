import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'exp_provider.dart'; // Make sure this is imported

class RankingsPage extends StatefulWidget {
  @override
  _RankingsPageState createState() => _RankingsPageState();
}

class _RankingsPageState extends State<RankingsPage> {
  List<Map<String, dynamic>> _globalRankings = [];
  List<Map<String, dynamic>> _friendsRankings = [];

  @override
  void initState() {
    super.initState();
    // Example initialization, replace with your actual data loading logic
    _globalRankings = [
      {'name': 'User A', 'level': 20},
      {'name': 'User B', 'level': 18},
      // Add more mock data as needed...
    ];
    _friendsRankings = [
      {'name': 'Friend 1', 'level': 15},
      {'name': 'Friend 2', 'level': 12},
      // Add more mock data as needed...
    ];
  }

  @override
  Widget build(BuildContext context) {
    final userLevel = Provider.of<ExpProvider>(context).level;

    // Rebuild the rankings lists with the user's current level each time
    final List<Map<String, dynamic>> globalRankings = [
      ..._globalRankings.where((item) => item['name'] != 'You'), // Remove old user entry
      {'name': 'You', 'level': userLevel}, // Add updated user entry
    ];

    final List<Map<String, dynamic>> friendsRankings = [
      ..._friendsRankings.where((item) => item['name'] != 'You'), // Remove old user entry
      {'name': 'You', 'level': userLevel}, // Add updated user entry
    ];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Rankings'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Global'),
              Tab(text: 'Friends'),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(), // Disables swipe navigation
          children: [
            _buildRankingsList(globalRankings),
            _buildRankingsList(friendsRankings),
          ],
        ),
      ),
    );
  }

  Widget _buildRankingsList(List<Map<String, dynamic>> rankings) {
    final userLevel = Provider.of<ExpProvider>(context, listen: false).level; // Access user level here if needed

    // Sort rankings by level
    rankings.sort((a, b) => b['level'].compareTo(a['level']));

    return ListView.builder(
      itemCount: rankings.length,
      itemBuilder: (context, index) {
        final isUser = rankings[index]['name'] == 'You';
        // Customize ListTile appearance here, possibly using userLevel
        return ListTile(
          leading: CircleAvatar(
            child: Text('${rankings[index]['level']}'),
            backgroundColor: isUser ? Colors.blue : Colors.grey,
          ),
          title: Text(rankings[index]['name'], style: TextStyle(color: isUser ? Colors.blue : null)),
          subtitle: Text('Level: ${rankings[index]['level']}'),
        );
      },
    );
  }
}
