import 'package:aag_group_services/authentication_pages/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  @override
  void initState() {
    super.initState();
    loginToggled.addListener(updateValue);
    authenticationMap.addListener(updateValue);
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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return build_login_screen(context, auth);
  }
}
