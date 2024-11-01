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
    // Listening for changes in the 'notes' node for the specific user and receiver
    database.child('notes').child(currentUserId ?? "").child(widget.receiverModel.id).onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists && snapshot.value is Map) {
        // Convert snapshot data to a Map
        Map<dynamic, dynamic> dataMap = snapshot.value as Map<dynamic, dynamic>;

        // Transform each timestamp entry into a NotesModel instance
        List<NotesModel> fetchedNotes = dataMap.entries.map((entry) {
          final noteData = entry.value;
          final timestampKey = entry.key;

          // Ensure noteData is a Map before converting
          return noteData is Map
              ? NotesModel.fromMap(timestampKey, Map<String, dynamic>.from(noteData))
              : null;
        }).whereType<NotesModel>().toList();

        // Update the state with the new list of notes
        notesList.value = fetchedNotes; // Update ValueNotifier
      } else {
        // Handle case where snapshot is empty or not in expected format
        notesList.value = [];
        print('No notes available or data format error.');
      }
    }, onError: (error) {
      print('Error listening to notes: $error');
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
