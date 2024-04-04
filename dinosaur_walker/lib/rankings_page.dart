import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'exp_provider.dart'; // Make sure this is imported
import 'user_profile_page.dart';
import 'user_provider.dart';

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
      {'name': 'Armando Nogueiras', 'level': 20},
      {'name': 'Deide Orvalho', 'level': 18},
      // Add more mock data as needed...
    ];
    _friendsRankings = [
      {'name': 'Caio Marcio', 'level': 15},
      {'name': 'Tiago Hugo', 'level': 12},
      // Add more mock data as needed...
    ];
  }

  @override
  Widget build(BuildContext context) {
    final userLevel = Provider.of<ExpProvider>(context).level;
    final userName = Provider.of<UserProvider>(context).username;

    // Rebuild the rankings lists with the user's current level each time
    final List<Map<String, dynamic>> globalRankings = [
      ..._globalRankings.where((item) => item['name'] != 'You'), // Remove old user entry
      {'name': userName, 'level': userLevel}, // Add updated user entry
    ];

    final List<Map<String, dynamic>> friendsRankings = [
      ..._friendsRankings.where((item) => item['name'] != 'You'), // Remove old user entry
      {'name': userName, 'level': userLevel}, // Add updated user entry
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
    final userName = Provider.of<UserProvider>(context).username;
    rankings.sort((a, b) => b['level'].compareTo(a['level']));

    return ListView.builder(
      itemCount: rankings.length,
      itemBuilder: (context, index) {
        final profile = rankings[index];
        final bool isCurrentUser = profile['name'] == userName; // Check if it's the current user
  
      
        return ListTile(
          leading: CircleAvatar(
            child: Text('${profile['level']}'),
            backgroundColor: isCurrentUser ? Colors.blue : Colors.grey, // Highlight if current user
          ),
          title: Text(profile['name']),
          subtitle: Text('Level: ${profile['level']}'),
          onTap: () {
            // Mock character for demonstration
            String characterAsset = profile['name'] == 'Friend 1' ? 'assets/animations/character_friend1.gif' : 'assets/animations/character_global1.gif';
            
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserProfilePage(
                username: profile['name'],
                level: profile['level'],
                // characterAsset: characterAsset,
              )),
            );
          },
        );
      },
    );
  }
}
