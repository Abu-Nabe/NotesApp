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

  @override
  void initState() {
    super.initState();
    loginToggled.addListener(updateValue);
    authenticationMap.addListener(updateValue);
    screenUpdate.addListener(updateValue);

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
