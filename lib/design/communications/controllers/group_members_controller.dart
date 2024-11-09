import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../firebase/currentUserId.dart';
import '../../authentication_pages/models/user_model.dart';
import '../../main_pages/functions/contact_functions/remove_user_from_list.dart';
import '../screens/group_member_screen.dart';

class GroupMemberController extends StatefulWidget {
  final String groupID;
  const GroupMemberController({super.key, required this.groupID});

  @override
  State<GroupMemberController> createState() => GroupMemberControllerState();
}

class GroupMemberControllerState extends State<GroupMemberController> {
  static ValueNotifier<List<UserModel>> usersList = ValueNotifier<List<UserModel>>([]);
  static ValueNotifier<List<UserModel>> searchList = ValueNotifier<List<UserModel>>([]);

  static ValueNotifier<String> searchText = ValueNotifier<String>('');
  static ValueNotifier<TextEditingController> searchController = ValueNotifier<TextEditingController>(TextEditingController());
  static ValueNotifier<bool> searchMode = ValueNotifier<bool>(false);


  final database = FirebaseDatabase.instance.ref();
  String? currentUserId;

  @override
  void initState() {
    super.initState();

    usersList.addListener(updateValue);
    searchList.addListener(updateValue);
    searchMode.addListener(updateValue);

    searchText.addListener(searchUsers);

    currentUserId = getCurrentUserID();

    fetchUsers();
  }

  @override
  void dispose() {
    usersList.removeListener(updateValue);
    searchList.removeListener(updateValue);
    searchMode.removeListener(updateValue);

    searchText.removeListener(searchUsers);

    super.dispose();
  }


  void updateValue(){
    setState(() {});
  }

  void fetchUsers() {
    // Listening for changes in the 'users' node
    database.child('group_list').child(widget.groupID).onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        Map<dynamic, dynamic> usersMap = snapshot.value as Map<dynamic, dynamic>;

        List<UserModel> fetchedUsers = [];
        usersMap.forEach((userId, userData) {
          // Make sure to handle the case where userData might not be a Map
          if (userData is Map) {
            fetchedUsers.add(UserModel.fromMap(userId, Map<String, dynamic>.from(userData)));
          }
        });

        // Update the state with the new user list
        usersList.value = fetchedUsers; // Update ValueNotifier
      }
    }, onError: (error) {
      print('Error listening to users: $error');
    });
  }

  void searchUsers() {
    searchList.value = usersList.value
        .where((user) => user.name.toLowerCase().contains(searchText.value))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return build_group_message_screen(context);
  }
}
