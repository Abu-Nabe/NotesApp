import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../authentication_pages/models/user_model.dart';
import '../screens/contact_screen.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => ContactsPageState();
}

class ContactsPageState extends State<ContactsPage> {
  ValueNotifier<List<UserModel>> usersList = ValueNotifier<List<UserModel>>([]);
  final database = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();

    usersList.addListener(updateValue);

    fetchUsers();
  }

  void updateValue(){
    setState(() {});
  }

  void fetchUsers() {
    // Listening for changes in the 'users' node
    database.child('users').onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        List<UserModel> fetchedUsers = [];
        Map<dynamic, dynamic> usersMap = snapshot.value as Map<dynamic, dynamic>;

        // Iterate over each user ID and map each user data to UserModel
        usersMap.forEach((userId, userData) {
          // Make sure to handle the case where userData might not be a Map
          if (userData is Map) {
            fetchedUsers.add(UserModel.fromMap(Map<String, dynamic>.from(userData)));
          }
        });

        // Update the state with the new user list
        usersList.value = fetchedUsers; // This assumes usersList is a List<UserModel>
        // print(fetchedUsers.length);
      }
    }, onError: (error) {
      print('Error listening to users: $error');
    });
  }

  @override
  void dispose() {
    usersList.dispose(); // Dispose the ValueNotifier
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return build_contact_screen(context);
  }
}
