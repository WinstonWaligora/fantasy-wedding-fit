import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/leaderboard_background.jpg'), // Update the path to your image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Centered Leaderboard content
          Center(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').orderBy('mileage', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final users = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final data = user.data() as Map<String, dynamic>;

                    return Container(
                      color: Colors.black.withOpacity(0.5),
                      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(data['name'] ?? 'Anonymous', style: TextStyle(color: Colors.white)),
                        subtitle: Text('${data['mileage']} miles', style: TextStyle(color: Colors.white70)),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
