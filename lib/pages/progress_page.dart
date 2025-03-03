import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'leaderboard_page.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  int mileage = 0;

  @override
  void initState() {
    super.initState();
    _loadMileage();
  }

  Future<void> _loadMileage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var db = FirebaseFirestore.instance;
      DocumentSnapshot doc = await db.collection("users").doc(user.uid).get();
      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        setState(() {
          mileage = data["mileage"];
        });
      }
    }
  }

  Future<void> _showAddMileageDialog(BuildContext context) async {
    int tempMileage = mileage;

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
                            if (tempMileage > 0) tempMileage--;
                          });
                        },
                      ),
                      Text('$tempMileage'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            tempMileage++;
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
                await _saveMileage(tempMileage);
                setState(() {
                  mileage = tempMileage;
                });
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
      var userData = {
        "mileage": mileage,
        "name": user.displayName
      };
      db.collection("users").doc(user.uid).set(userData);
    }
  }

  void _navigateToLeaderboard(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LeaderboardPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journey to Mordor'),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/fantasy_background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
              painter: MiddleEarthMapPainter(mileage: mileage)
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              _showAddMileageDialog(context);
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Mileage'),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            heroTag: 'addMileage',
          ),
          const SizedBox(height: 16),
          FloatingActionButton.extended(
            onPressed: () {
              _navigateToLeaderboard(context);
            },
            icon: const Icon(Icons.leaderboard),
            label: const Text('Leaderboard'),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            heroTag: 'leaderboard',
          ),
        ],
      ),
    );
  }
}

class MiddleEarthMapPainter extends CustomPainter {
  final int mileage;

  MiddleEarthMapPainter({required this.mileage});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width * 0.14, size.height * 0.48); // The Shire
    path.lineTo(size.width * 0.35, size.height * 0.63); // Rivendell
    path.lineTo(size.width * 0.4, size.height * 0.72); // Caradhras
    path.lineTo(size.width * 0.33, size.height * 0.81);
    path.lineTo(size.width * 0.32, size.height * 0.92); // Lothlórien
    path.lineTo(size.width * 0.64, size.height * 0.8); // Rohan
    path.lineTo(size.width * 0.65, size.height * 0.71); // Rohan
    path.lineTo(size.width * 0.55, size.height * 0.5); // Parth Galen
    path.lineTo(size.width * 0.54, size.height * 0.16); // Amon Hen
    path.lineTo(size.width * 0.68, size.height * 0.05); // Moria
    path.lineTo(size.width * 0.75, size.height * 0.02); // Mount Doom entry
    path.lineTo(size.width * 0.85, size.height * 0.1); // Mount Doom

    canvas.drawPath(path, paint);

    // Draw checkpoints
    _drawCheckpoint(canvas, size, size.width * 0.14, size.height * 0.48, 'The Shire', 0, 'Start your journey');
    _drawCheckpoint(canvas, size, size.width * 0.35, size.height * 0.63, 'Rivendell', 40, 'Rest and resupply');
    _drawCheckpoint(canvas, size, size.width * 0.32, size.height * 0.92, 'Lothlórien', 60, 'Receive aid from the Elves');
    _drawCheckpoint(canvas, size, size.width * 0.64, size.height * 0.8, 'Rohan', 80, 'Receive aid from Rohan');
    _drawCheckpoint(canvas, size, size.width * 0.55, size.height * 0.5, 'Parth Galen', 100, 'Take last rest');
    _drawCheckpoint(canvas, size, size.width * 0.54, size.height * 0.16, 'Amon Hen', 120, 'Peer over a place of great vision');
    _drawCheckpoint(canvas, size, size.width * 0.85, size.height * 0.1, 'Mount Doom', 145, 'Destroy the Ring');

    // Draw progress line
    final progressPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke;

    final progressPath = Path();
    progressPath.moveTo(size.width * 0.14, size.height * 0.48); // The Shire
    if (mileage >= 40) progressPath.lineTo(size.width * 0.35, size.height * 0.63); // Rivendell
    if (mileage >= 45) progressPath.lineTo(size.width * 0.4, size.height * 0.72); // Caradhras
    if (mileage >= 55) progressPath.lineTo(size.width * 0.33, size.height * 0.81);
    if (mileage >= 60) progressPath.lineTo(size.width * 0.32, size.height * 0.92); // Rohan
    if (mileage >= 80) progressPath.lineTo(size.width * 0.64, size.height * 0.8); // Rohan
    if (mileage >= 85) progressPath.lineTo(size.width * 0.65, size.height * 0.71); // Rohan
    if (mileage >= 100) progressPath.lineTo(size.width * 0.55, size.height * 0.5); // Parth Galen
    if (mileage >= 120) progressPath.lineTo(size.width * 0.54, size.height * 0.16); // Amon Hen
    if (mileage >= 130) progressPath.lineTo(size.width * 0.68, size.height * 0.05); // Moria
    if (mileage >= 135) progressPath.lineTo(size.width * 0.75, size.height * 0.02); // Mount Doom entry
    if (mileage >= 145) progressPath.lineTo(size.width * 0.85, size.height * 0.1); // Mount Doom

    canvas.drawPath(progressPath, progressPaint);
  }

  void _drawCheckpoint(Canvas canvas, Size size, double x, double y, String name, int mileage, String description) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 5);

    if (this.mileage >= mileage) {
      paint.color = Colors.cyanAccent;
    }

    canvas.drawCircle(Offset(x, y), 15.0, paint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: '$name\n$mileage miles\n$description',
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: size.width * 0.2);

    final textBackgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final textBackgroundRect = Rect.fromLTWH(x + 10, y - 10, textPainter.width, textPainter.height);
    canvas.drawRect(textBackgroundRect, textBackgroundPaint);

    textPainter.paint(canvas, Offset(x + 10, y - 10));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
