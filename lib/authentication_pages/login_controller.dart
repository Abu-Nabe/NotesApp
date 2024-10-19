import 'package:aag_group_services/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class LoginController extends StatefulWidget {
  const LoginController({super.key});

  @override
  State<LoginController> createState() => LoginControllerState();
}

class LoginControllerState extends State<ChatPage> {
  // Any logic or state specific to Contacts Page

  @override
  Widget build(BuildContext context) {
    return build_chat_screen(context);
  }
}
