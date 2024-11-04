import 'package:aag_group_services/design/authentication_pages/models/user_model.dart';
import 'package:aag_group_services/design/communications/model/messages_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../firebase/user_info.dart';
import '../screens/message_screen.dart';

class MessageController extends StatefulWidget {
  final UserModel receiverModel;
  const MessageController({Key? key, required this.receiverModel});

  @override
  State<MessageController> createState() => MessageControllerState();
}

class MessageControllerState extends State<MessageController> {
  static ValueNotifier<List<MessageModel>> messagesList = ValueNotifier<List<MessageModel>>([]);
  static ValueNotifier<Map<String, String>> userInfo = ValueNotifier<Map<String, String>>({});

  static final ValueNotifier<TextEditingController> noteController = ValueNotifier<TextEditingController>(TextEditingController());

  final database = FirebaseDatabase.instance.ref();
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    // Additional initialization logic if needed
    noteController.addListener(updateState);
    messagesList.addListener(updateState);

    fetchUserDetails();
    fetchNotes();
  }

  Future<void> fetchUserDetails() async {
    Map<String, String> user = await fetchUserInfo();
    userInfo.value = user;
  }
  void fetchNotes() {
    // Listening for changes in the 'notes' node for the specific user and receiver
    database.child('messages').child(currentUserId ?? "").child(widget.receiverModel.id).onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists && snapshot.value is Map) {
        // Casting to a map of timestamp keys to note entries
        Map<dynamic, dynamic> userNotesMap = snapshot.value as Map<dynamic, dynamic>;

        // Collecting all notes for each timestamp in the user's notes
        List<MessageModel> fetchedNotes = [];

        userNotesMap.forEach((timestampKey, noteData) {
          // Check if noteData is structured as expected with timestamp keys
          if (noteData is Map) {
            noteData.forEach((timeKey, details) {
              if (details is Map) {
                fetchedNotes.add(MessageModel.fromMap(timeKey, Map<String, dynamic>.from(details)));
              }
            });
          }
        });
        fetchedNotes.sort((b, a) => a.createdAt.compareTo(b.createdAt));

        // Update the state with the list of notes
        messagesList.value = fetchedNotes; // Update ValueNotifier
      } else {
        // Handle case where snapshot is empty or not in expected format
        messagesList.value = [];
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
    messagesList.removeListener(updateState);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return build_message_screen(context, widget.receiverModel);
  }
}
