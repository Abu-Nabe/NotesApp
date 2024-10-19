import 'package:aag_group_services/authentication_pages/login_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../bottom_navigation.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Listen for auth state changes
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Show a loading spinner while waiting
        }
        if (snapshot.hasData) {
          return const BottomNavigation(); // User is signed in, show bottom navigation
        } else {
          return const LoginController(); // User is not signed in, show login page
        }
      },
    );
  }
}