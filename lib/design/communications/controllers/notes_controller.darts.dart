import 'package:flutter/material.dart';

import '../screens/notes_screen.dart';

class NotesController extends StatefulWidget {
  const NotesController({super.key});

  @override
  State<NotesController> createState() => NotesControllerState();
}

class NotesControllerState extends State<NotesController> {

  @override
  Widget build(BuildContext context) {
    return build_notes_screen(context);
  }
}
