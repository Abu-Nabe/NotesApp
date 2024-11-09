import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../firebase/currentUserId.dart';
import '../../authentication_pages/models/user_model.dart';
import '../functions/contact_functions/remove_user_from_list.dart';
import '../screens/contact_screen.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => ContactsPageState();
}

class ContactsPageState extends State<ContactsPage> {
  static ValueNotifier<List<UserModel>> usersList = ValueNotifier<List<UserModel>>([]);
  static ValueNotifier<List<UserModel>> searchList = ValueNotifier<List<UserModel>>([]);

  static ValueNotifier<String> searchText = ValueNotifier<String>('');
  static ValueNotifier<TextEditingController> searchController = ValueNotifier<TextEditingController>(TextEditingController());
  static ValueNotifier<bool> searchMode = ValueNotifier<bool>(false);

  static ValueNotifier<int> updatePage = ValueNotifier<int>(0);

  final database = FirebaseDatabase.instance.ref();
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    usersList.addListener(updateValue);
    searchList.addListener(updateValue);
    searchMode.addListener(updateValue);

    searchText.addListener(searchUsers);

    updatePage.addListener(updateValue);

    currentUserId = getCurrentUserID();

    fetchUsers();
  }

  @override
  void dispose() {
    usersList.removeListener(updateValue);
    searchList.removeListener(updateValue);
    searchMode.removeListener(updateValue);

    searchText.removeListener(searchUsers);
    updatePage.removeListener(updateValue);

    usersList.value = [];
    searchList.value = [];
    super.dispose();
  }


  void updateValue(){
    setState(() {});
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
    String search = searchText.value.toLowerCase(); // Convert search text to lowercase for case-insensitive matching

    // Listen for changes in the 'users' node
    database.child('users').onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        Map<dynamic, dynamic> usersMap = snapshot.value as Map<dynamic, dynamic>;

        // Remove the currently logged-in user from the usersMap
        removeCurrentUserFromList(usersMap, currentUserId ?? "");

        // Filter users based on the search text
        List<UserModel> fetchedUsers = [];
        usersMap.forEach((userId, userData) {
          if (userData is Map) {
            // Pass `userId` as the `id` to UserModel
            UserModel user = UserModel.fromMap(userId, Map<String, dynamic>.from(userData));
            // Check if user's name, email, or id matches the search text
            if (user.name.toLowerCase().contains(search) ||
                user.email.toLowerCase().contains(search) ||
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
    return build_contact_screen(context);
  }
}
