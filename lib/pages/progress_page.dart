import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Journey to Mordor')),
      body: Center(
        // Implement the map and checkpoints here
        child: const Text('Map and Progress Overview'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddMileageDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddMileageDialog(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    var db = FirebaseFirestore.instance;

    int mileage = 0;
    if (user != null) {
      DocumentSnapshot doc = await db.collection("users").doc(user.uid).get();
      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        mileage = data["mileage"];
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Mileage'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (mileage > 0) mileage--;
                          });
                        },
                      ),
                      Text('$mileage'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            mileage++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _saveMileage(mileage);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveMileage(int mileage) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var db = FirebaseFirestore.instance;
      db.collection("users").doc(user.uid).set({"mileage": mileage});
    }
  }

}
