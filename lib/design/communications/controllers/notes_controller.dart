import 'package:aag_group_services/design/authentication_pages/models/user_model.dart';
import 'package:aag_group_services/design/communications/model/notes_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../screens/notes_screen.dart';

class NotesController extends StatefulWidget {
  final UserModel receiverModel;
  const NotesController({Key? key, required this.receiverModel});

  @override
  State<NotesController> createState() => NotesControllerState();
}

class NotesControllerState extends State<NotesController> {
  static ValueNotifier<List<NotesModel>> notesList = ValueNotifier<List<NotesModel>>([]);

  static final ValueNotifier<TextEditingController> noteController =
  ValueNotifier<TextEditingController>(TextEditingController());

  final database = FirebaseDatabase.instance.ref();
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    // Additional initialization logic if needed
    noteController.addListener(updateState);
    notesList.addListener(updateState);

    fetchNotes();
  }

  void fetchNotes() {
    // Listening for changes in the 'users' node
    database.child('notes').child(currentUserId ?? "").child(widget.receiverModel.id).onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        Map<dynamic, dynamic> dataMap = snapshot.value as Map<dynamic, dynamic>;

        // Iterate over each user ID and map each user data to UserModel
        List<NotesModel> fetchedNotes = [];
        dataMap.forEach((userId, notesData) {
          // Make sure to handle the case where userData might not be a Map
          if (notesData is Map) {
            fetchedNotes.add(NotesModel.fromMap(userId, Map<String, dynamic>.from(notesData)));
          }
        });

        // Update the state with the new user list
        notesList.value = fetchedNotes; // Update ValueNotifier
      }
    }, onError: (error) {
      print('Error listening to users: $error');
    });
  }


  void updateState(){
    setState(() {});
  }

  @override
  void dispose() {
    noteController.removeListener(updateState);
    notesList.removeListener(updateState);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return build_notes_screen(context, widget.receiverModel);
  }
}
