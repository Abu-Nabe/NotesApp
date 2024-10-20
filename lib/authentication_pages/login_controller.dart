import 'package:aag_group_services/authentication_pages/screens/login_screen.dart';
import 'package:aag_group_services/authentication_pages/screens/register_screen.dart';
import 'package:aag_group_services/firebase/initialize_ref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class LoginController extends StatefulWidget {
  const LoginController({super.key});

  @override
  State<LoginController> createState() => LoginControllerState();
}

class LoginControllerState extends State<LoginController> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  static ValueNotifier<bool> loginToggled = ValueNotifier<bool>(false);
  static ValueNotifier<Map<String, dynamic>> authenticationMap = ValueNotifier<Map<String, dynamic>>({});
  static ValueNotifier<int> screenUpdate = ValueNotifier<int>(1);

  Future<void> addData() async {
    print("addData function called"); // Debug log
    try {
      final DatabaseReference _database = await setUpFirebaseRef();
      print("Database reference obtained: $_database"); // Debug log

      await _database.child('users/userId').set({
        'name': 'John Doe',
        'email': 'johndoe@example.com',
      });

      print('Data added successfully.');
    } catch (e) {
      print('Error adding data: $e'); // Print any error message
    }
  }


  @override
  void initState() {
    super.initState();
    loginToggled.addListener(updateValue);
    authenticationMap.addListener(updateValue);
    screenUpdate.addListener(updateValue);

    addData();
  }

  void updateValue(){
    setState(() {

    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree
    loginToggled.removeListener(updateValue);
    authenticationMap.removeListener(updateValue);
    screenUpdate.removeListener(updateValue);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (screenUpdate.value) {
      case 1:
        return build_login_screen(context, auth);
      case 2:
        return build_register_screen(context, auth);
      default:
        return build_login_screen(context, auth);
    }
  }
}
