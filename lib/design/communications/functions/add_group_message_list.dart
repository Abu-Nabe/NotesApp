import 'package:aag_group_services/design/communications/model/group_model.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../authentication_pages/models/user_model.dart';

void addGroupMessageToDB(String groupID, String message, String username){
  // Create a map for the user information to be added
  Map<String, dynamic> userInfo = {
    'name': username,
    'message': message,
    'created_at': DateTime.now().millisecondsSinceEpoch.toString(),
    'seen': false,
  };
  // Reference to the Firebase Realtime Database
  DatabaseReference reference = FirebaseDatabase.instance
      .ref()
      .child('messages') // Parent node
      .child(groupID) // Current user's UID
      .child(DateTime.now().millisecondsSinceEpoch.toString()); // Unique key based on timestamp

  // Write user information to the database
  reference.set(userInfo).then((_) {
    print('Note added successfully!');
  }).catchError((error) {
    print('Error adding user: $error');
  });
}

Future<void> addToGroupMessageList(List<GroupUserModel> selectedUsersList, username, String message, String groupName, String uniqueID) async {
  Map<String, dynamic> userInfo = {
    'name': groupName,
    'message': username + ": " + message,
    'created_at': DateTime.now().millisecondsSinceEpoch.toString(),
    'seen': true,
    'is_group': true,
  };

  // Loop through each user in the selectedUsersList
  for (GroupUserModel user in selectedUsersList) {
    // Reference to the Firebase Realtime Database
    DatabaseReference reference = FirebaseDatabase.instance
        .ref()
        .child('messages_list') // Parent node
        .child(user.id) // User's UID or another field
        .child(uniqueID); // Child is the unique ID for the message

    // Write user information to the database
    reference.set(userInfo).then((_) {

    }).catchError((error) {

    });
  }
}