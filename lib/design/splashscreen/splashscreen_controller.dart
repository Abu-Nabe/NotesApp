import 'package:aag_group_services/consts/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../extension/version_number.dart';
import '../../firebase/authenticated_state.dart';
import '../authentication_pages/login_controller.dart';
import '../bottom_navigation.dart';
import '../navigation/navigation_functions.dart';
import 'package:package_info/package_info.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _appVersion = ""; // Default value for version

  @override
  void initState() {
    super.initState();
    _getAppVersion(); // Get the app version as soon as the widget is initialized
    _checkUserStatusAndNavigate();
  }

  // Function to get the app version and update the state
  Future<void> _getAppVersion() async {
    String version = await getVersion(); // Fetch app version
    setState(() {
      _appVersion = version; // Update state with the version
    });
  }

  // Function to check user status and navigate accordingly
  Future<void> _checkUserStatusAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2)); // Wait a bit for splash screen

    final currentUser = FirebaseAuth.instance.currentUser;

    // Navigate based on user authentication status
    if (currentUser != null) {
      // User is signed in
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavigation()),
        );
      }
    } else {
      // User is not signed in
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginController()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Customize your splash screen background color
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/images/icon.jpeg', // Replace with your custom image path
              width: 200,
              height: 200,
            ),
          ),
          Positioned(
            bottom: 20.0, // Position the version text at the bottom of the screen
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Version: $_appVersion', // Display the app version
                style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
