import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../design/authentication_pages/login_controller.dart';
import '../design/bottom_navigation.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _getCurrentUser(), // Get the current user once
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Show a loading spinner while waiting
        }
        if (snapshot.hasData && snapshot.data != null) {
          return const BottomNavigation(); // User is signed in, show bottom navigation
        } else {
          return const LoginController(); // User is not signed in, show login page
        }
      },
    );
  }

  // Function to get the current user
  Future<User?> _getCurrentUser() async {
    return FirebaseAuth.instance.currentUser; // Get the current user
  }
}
