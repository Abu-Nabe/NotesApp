import 'package:aag_group_services/design/communications/model/messages_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../firebase/user_info.dart';
import '../model/group_model.dart';
import '../screens/group_message_screen.dart';

class GroupMessageController extends StatefulWidget {
  final MessageModel messageModel;
  const GroupMessageController({Key? key, required this.messageModel});

  @override
  State<GroupMessageController> createState() => GroupMessageControllerState();
}

class GroupMessageControllerState extends State<GroupMessageController> {
  static ValueNotifier<List<MessageModel>> messagesList = ValueNotifier<List<MessageModel>>([]);
  static ValueNotifier<Map<String, String>> userInfo = ValueNotifier<Map<String, String>>({});

  static ValueNotifier<List<GroupUserModel>> groupUsersList = ValueNotifier<List<GroupUserModel>>([]);
  static final ValueNotifier<TextEditingController> noteController = ValueNotifier<TextEditingController>(TextEditingController());

  final database = FirebaseDatabase.instance.ref();
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    // Additional initialization logic if needed
    noteController.addListener(updateState);
    messagesList.addListener(updateState);
    groupUsersList.addListener(updateState);

    fetchUserDetails();
    fetchNotes();
    fetchGroupMembers(widget.messageModel.id);
  }

  Future<void> fetchUserDetails() async {
    Map<String, String> user = await fetchUserInfo();
    userInfo.value = user;
  }

  void fetchGroupMembers(String groupID) {
    // Listening for changes in the 'users' node
    database.child('group_list').child(groupID).onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        Map<dynamic, dynamic> usersMap = snapshot.value as Map<dynamic, dynamic>;

        List<GroupUserModel> fetchedUsers = [];

        usersMap.forEach((userId, userData) {
          // Explicitly cast userData to Map<String, dynamic>
          final data = Map<String, dynamic>.from(userData as Map<dynamic, dynamic>);

          try {
            fetchedUsers.add(GroupUserModel.fromMap(userId, data));
          } catch (e) {
          }
        });
        // Sort fetchedUsers to have host appear first
        fetchedUsers.sort((a, b) => b.host.toString().compareTo(a.host.toString()));

        // Update the state with the new sorted user list
        groupUsersList.value = fetchedUsers;
      }
    }, onError: (error) {
      print('Error listening to users: $error');
    });
  }

  void fetchNotes() {
    database.child('messages').child(widget.messageModel.id).onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists && snapshot.value is Map) {
        // Casting to a map of timestamp keys to note entries
        Map<dynamic, dynamic> userNotesMap = snapshot.value as Map<dynamic, dynamic>;

        // Collecting all notes for each timestamp in the user's notes
        List<MessageModel> fetchedNotes = [];

        userNotesMap.forEach((timestampKey, noteData) {
          print('Timestamp: $timestampKey');
          print('Note data: $noteData');

          // Ensure noteData is in the expected structure
          if (noteData is Map) {
            fetchedNotes.add(MessageModel.fromMap(timestampKey, Map<String, dynamic>.from(noteData)));
          } else {
            print('Details for note are not in the expected Map format: $noteData');
          }
        });

        // Sort notes based on the timestamp
        fetchedNotes.sort((b, a) => a.createdAt.compareTo(b.createdAt));

        // Update the state with the list of notes
        messagesList.value = fetchedNotes;
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
    groupUsersList.removeListener(updateState);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return build_group_message_screen(context, widget.messageModel);
  }
}
