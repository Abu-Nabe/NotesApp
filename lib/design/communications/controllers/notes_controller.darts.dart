import 'package:aag_group_services/design/authentication_pages/models/user_model.dart';
import 'package:flutter/material.dart';

import '../screens/notes_screen.dart';

class NotesController extends StatefulWidget {
  final UserModel receiverModel;
  const NotesController({Key? key, required this.receiverModel});

  @override
  State<NotesController> createState() => NotesControllerState();
}

class NotesControllerState extends State<NotesController> {

  @override
  Widget build(BuildContext context) {
    return build_notes_screen(context, widget.receiverModel);
  }
}
