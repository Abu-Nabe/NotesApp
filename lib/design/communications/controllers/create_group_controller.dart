import 'package:aag_group_services/design/authentication_pages/models/user_model.dart';
import 'package:aag_group_services/design/communications/model/notes_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../firebase/currentUserId.dart';
import '../../main_pages/functions/contact_functions/remove_user_from_list.dart';
import '../screens/create_group_screen.dart';
import '../screens/notes_screen.dart';

class CreateGroupController extends StatefulWidget {
  const CreateGroupController({Key? key});

  @override
  State<CreateGroupController> createState() => CreateGroupControllerState();
}

class CreateGroupControllerState extends State<CreateGroupController> {
  static ValueNotifier<List<UserModel>> usersList = ValueNotifier<List<UserModel>>([]);
  static ValueNotifier<List<UserModel>> searchList = ValueNotifier<List<UserModel>>([]);

  static ValueNotifier<List<String>> selectedUsers = ValueNotifier<List<String>>([]);

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
    selectedUsers.addListener(updateValue);

    searchText.addListener(searchUsers);
    currentUserId = getCurrentUserID();

    fetchUsers();
  }

  void fetchUsers() {
    // Listening for changes in the 'users' node
    database.child('contacts').child(currentUserId ?? "").onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        Map<dynamic, dynamic> usersMap = snapshot.value as Map<dynamic, dynamic>;

        // Remove the currently logged-in user from the usersMap
        removeCurrentUserFromList(usersMap, currentUserId ?? "");
        // Iterate over each user ID and map each user data to UserModel
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

  void updateValue(){
    setState(() {});
  }

  @override
  void dispose() {
    usersList.removeListener(updateValue);
    searchList.removeListener(updateValue);
    searchMode.removeListener(updateValue);
    selectedUsers.removeListener(updateValue);

    searchText.removeListener(searchUsers);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return build_create_group_screen(context);
  }
}
