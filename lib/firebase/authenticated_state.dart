import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../design/authentication_pages/login_controller.dart';
import '../design/bottom_navigation.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Listen for auth state changes
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Loading state
        }

        // If the user is logged in, show the bottom navigation
        if (snapshot.hasData && snapshot.data != null) {
          return const BottomNavigation();
        } else {
          return const LoginController(); // Show login page if not logged in
        }
      },
    );
  }
}
