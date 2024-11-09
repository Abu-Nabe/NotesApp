import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../firebase/currentUserId.dart';
import '../../authentication_pages/models/user_model.dart';
import '../../main_pages/functions/contact_functions/remove_user_from_list.dart';
import '../model/group_model.dart';
import '../screens/group_member_screen.dart';

class GroupMemberController extends StatefulWidget {
  final String groupID;
  const GroupMemberController({super.key, required this.groupID});

  @override
  State<GroupMemberController> createState() => GroupMemberControllerState();
}

class GroupMemberControllerState extends State<GroupMemberController> {
  static ValueNotifier<List<GroupUserModel>> usersList = ValueNotifier<List<GroupUserModel>>([]);
  static ValueNotifier<List<GroupUserModel>> searchList = ValueNotifier<List<GroupUserModel>>([]);

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
        print('Snapshot exists: ${snapshot.exists}, usersMap: $usersMap');

        List<GroupUserModel> fetchedUsers = [];

        usersMap.forEach((userId, userData) {
          // Explicitly cast userData to Map<String, dynamic>
          final data = Map<String, dynamic>.from(userData as Map<dynamic, dynamic>);
          print('Parsing user data for $userId: $data');

          try {
            fetchedUsers.add(GroupUserModel.fromMap(userId, data));
          } catch (e) {
            print('Error parsing user data for $userId: $e');
          }
        });

        print('Fetched users before sorting: $fetchedUsers');

        // Sort fetchedUsers to have host appear first
        fetchedUsers.sort((a, b) => b.host.toString().compareTo(a.host.toString()));

        // Update the state with the new sorted user list
        usersList.value = fetchedUsers;
        print('Sorted and updated users list: $fetchedUsers');
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
