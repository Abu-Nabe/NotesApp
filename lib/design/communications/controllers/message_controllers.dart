import 'package:aag_group_services/design/authentication_pages/models/user_model.dart';
import 'package:aag_group_services/design/communications/model/notes_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../screens/message_screen.dart';

class MessageController extends StatefulWidget {
  final UserModel receiverModel;
  const MessageController({Key? key, required this.receiverModel});

  @override
  State<MessageController> createState() => MessageControllerState();
}

class MessageControllerState extends State<MessageController> {
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
        // Casting to a map of timestamp keys to note entries
        Map<dynamic, dynamic> userNotesMap = snapshot.value as Map<dynamic, dynamic>;

        // Collecting all notes for each timestamp in the user's notes
        List<NotesModel> fetchedNotes = [];

        userNotesMap.forEach((timestampKey, noteData) {
          // Check if noteData is structured as expected with timestamp keys
          if (noteData is Map) {
            noteData.forEach((timeKey, details) {
              if (details is Map) {
                fetchedNotes.add(NotesModel.fromMap(timeKey, Map<String, dynamic>.from(details)));
              }
            });
          }
        });

        // Update the state with the list of notes
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
    return build_message_screen(context, widget.receiverModel);
  }
}