import 'package:aag_group_services/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  // Any logic or state specific to Contacts Page

  @override
  Widget build(BuildContext context) {
    return build_chat_screen(context);
  }
}
