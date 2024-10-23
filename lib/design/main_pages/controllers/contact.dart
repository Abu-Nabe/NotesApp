import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../firebase/currentUserId.dart';
import '../../authentication_pages/models/user_model.dart';
import '../screens/contact_screen.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => ContactsPageState();
}

class ContactsPageState extends State<ContactsPage> {
  static ValueNotifier<List<UserModel>> usersList = ValueNotifier<List<UserModel>>([]);
  final database = FirebaseDatabase.instance.ref();
  String? currentUserId;

  @override
  void initState() {
    super.initState();

    usersList.addListener(updateValue);
    currentUserId = getCurrentUserID();

    fetchUsers();
  }

  void updateValue(){
    setState(() {});
  }

  // Function to remove the current user from the fetched users list
  void removeCurrentUserFromList(Map<dynamic, dynamic> usersMap) {
    // Remove the current user from the usersMap
    usersMap.removeWhere((key, value) => key == currentUserId);
  }

  void fetchUsers() {
    // Listening for changes in the 'users' node
    database.child('users').onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        Map<dynamic, dynamic> usersMap = snapshot.value as Map<dynamic, dynamic>;

        // Remove the currently logged-in user from the usersMap
        removeCurrentUserFromList(usersMap);

        // Iterate over each user ID and map each user data to UserModel
        List<UserModel> fetchedUsers = [];
        usersMap.forEach((userId, userData) {
          // Make sure to handle the case where userData might not be a Map
          if (userData is Map) {
            fetchedUsers.add(UserModel.fromMap(Map<String, dynamic>.from(userData)));
          }
        });

        // Update the state with the new user list
        usersList.value = fetchedUsers; // Update ValueNotifier
      }
    }, onError: (error) {
      print('Error listening to users: $error');
    });
  }

  @override
  void dispose() {
    usersList.removeListener(updateValue); // Dispose the ValueNotifier
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return build_contact_screen(context);
  }
}
