import 'package:aag_group_services/authentication_pages/screens/login_screen.dart';
import 'package:flutter/material.dart';

class LoginController extends StatefulWidget {
  const LoginController({super.key});

  @override
  State<LoginController> createState() => LoginControllerState();
}

class LoginControllerState extends State<LoginController> {
  // Any logic or state specific to Contacts Page

  @override
  Widget build(BuildContext context) {
    return build_login_screen(context);
  }
}
