import 'package:firebase_database/firebase_database.dart';

import '../../../firebase/currentUserId.dart';
import '../../communications/functions/message_seen_validity.dart';
import '../../communications/model/messages_model.dart';
import '../screens/chat_screen.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  static ValueNotifier<List<MessageModel>> messagesList = ValueNotifier<List<MessageModel>>([]);
  static ValueNotifier<List<MessageModel>> searchList = ValueNotifier<List<MessageModel>>([]);

  static ValueNotifier<Map<String, bool>> seenList = ValueNotifier<Map<String, bool>>({});

  static ValueNotifier<String> searchText = ValueNotifier<String>('');
  static ValueNotifier<TextEditingController> searchController = ValueNotifier<TextEditingController>(TextEditingController());
  static ValueNotifier<bool> searchMode = ValueNotifier<bool>(false);

  static ValueNotifier<int> updatePage = ValueNotifier<int>(0);

  final database = FirebaseDatabase.instance.ref();
  String? currentUserId;

  @override
  void initState() {
    super.initState();

    messagesList.addListener(updateValue);
    searchList.addListener(updateValue);
    searchMode.addListener(updateValue);
    seenList.addListener(updateValue);

    searchText.addListener(searchUsers);

    updatePage.addListener(updateValue);

    currentUserId = getCurrentUserID();

    fetchList();
  }

  @override
  void dispose() {
    messagesList.removeListener(updateValue);
    searchList.removeListener(updateValue);
    searchMode.removeListener(updateValue);
    seenList.removeListener(updateValue);

    searchText.removeListener(searchUsers);

    updatePage.removeListener(updateValue);

    messagesList.value = [];
    searchList.value = [];

    super.dispose();
  }


  void updateValue(){
    setState(() {});
  }

  // Function to remove the current user from the fetched users list
  void removeCurrentUserFromList(Map<dynamic, dynamic> usersMap) {
    // Remove the current user from the usersMap
    usersMap.removeWhere((key, value) => key == currentUserId);
  }

  void fetchList() {
    final database = FirebaseDatabase.instance.ref();

    database.child('messages_list').child(currentUserId ?? "").onValue.listen((event) async {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists && snapshot.value is Map) {
        Map<dynamic, dynamic> itemsMap = snapshot.value as Map<dynamic, dynamic>;

        List<MessageModel> fetchedItems = [];
        Map<String, bool> newSeenList = {};

        for (var entry in itemsMap.entries) {
          if (entry.value is Map) {
            fetchedItems.add(MessageModel.fromMap(entry.key, Map<String, dynamic>.from(entry.value)));

            // Check 'seen' status for each message
            String receiver = entry.key;
            Map<String, bool> seenStatus = await checkSeen(currentUserId ?? "", receiver);
            newSeenList.addAll(seenStatus);
          }
        }

        fetchedItems.sort((b, a) => a.createdAt.compareTo(b.createdAt));
        messagesList.value = fetchedItems;

        // Update the seenList ValueNotifier
        ChatPageState.seenList.value = newSeenList;
      } else {
        messagesList.value = [];
      }
    }, onError: (error) {
      print('Error listening to messages: $error');
    });
  }

  void searchUsers() {
    String search = searchText.value.toLowerCase(); // Convert search text to lowercase for case-insensitive matching

    // Listen for changes in the 'users' node
    database.child('messages_list').child(currentUserId ?? "").onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        Map<dynamic, dynamic> usersMap = snapshot.value as Map<dynamic, dynamic>;

        // Remove the currently logged-in user from the usersMap
        removeCurrentUserFromList(usersMap);

        // Filter users based on the search text
        List<MessageModel> fetchedUsers = [];
        usersMap.forEach((userId, userData) {
          if (userData is Map) {
            // Pass `userId` as the `id` to UserModel
            MessageModel user = MessageModel.fromMap(userId, Map<String, dynamic>.from(userData));
            // Check if user's name, email, or id matches the search text
            if (user.name.toLowerCase().contains(search) ||
                user.id.toLowerCase().contains(search)) {
              fetchedUsers.add(user);
            }
          }
        });

        // Update the state with the filtered user list
        searchList.value = fetchedUsers; // Update ValueNotifier with filtered list
      }
    }, onError: (error) {
      print('Error listening to users: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return build_chat_screen(context);
  }
}

