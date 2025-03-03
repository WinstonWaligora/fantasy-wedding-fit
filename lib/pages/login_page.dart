import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/welcome_background.jpg'), // Update the path to your image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Centered header and login button
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Header
                Container(
                    color: Colors.black.withOpacity(0.5),
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Welcome to the Adventurer's Guild",
                      style: TextStyle(
                        fontSize: 48,
                        color: Colors.grey.shade300,
                        fontFamily: 'Fantasy', // Specify a fantasy font here
                        fontWeight: FontWeight.bold, // Make the font thick
                        ),
                        textAlign: TextAlign.center,
                        ),
                  ),
                const SizedBox(height: 48), // Add some spacing between header and button
                // Login button
                ElevatedButton.icon(
                  onPressed: signInWithGoogle,
                  icon: Image.asset(
                    'assets/google_icon.png', // Update the path to your Google icon
                    height: 24.0,
                    width: 24.0,
                  ),
                  label: Text(
                    'Start the Wedding Fit Quest',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey.shade300,
                      fontFamily: 'Fantasy', // Specify a fantasy font here
                      fontWeight: FontWeight.bold, // Make the font thick
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    backgroundColor: Colors.black.withOpacity(0.5), // 50% transparent background
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(googleProvider);

    // Or use signInWithRedirect
    // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
  }
}
