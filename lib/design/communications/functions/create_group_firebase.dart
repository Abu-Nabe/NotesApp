import 'package:aag_group_services/design/communications/controllers/create_group_controller.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../extension/getUUID.dart';
import '../../../firebase/user_info.dart';
import '../../authentication_pages/models/user_model.dart';

Future<void> createGroupFirebase(String groupName) async {
  List<String> selectedUserIds = CreateGroupControllerState.selectedUsers.value;
  List<UserModel> usersList = CreateGroupControllerState.usersList.value;

  List<UserModel> selectedUsersList = usersList.where((user) {
    return selectedUserIds.contains(user.id);  // Match based on user.id
  }).toList();

  String uniqueID = generateUniqueId();
  Map<String, String> info = await fetchUserInfo();

  addPersonalGroupMessage(selectedUsersList, info, groupName, uniqueID);
  addToGroupMessageList(selectedUsersList, info, groupName, uniqueID);
  addToGroupLeader(info, uniqueID);
}

Future<void> addPersonalGroupMessage(List<UserModel> selectedUsersList, Map<String, String> info, String groupName, String uniqueID) async {
  Map<String, dynamic> userInfo = {
    'name': groupName,
    'message': 'You started a new group.',
    'created_at': DateTime.now().millisecondsSinceEpoch.toString(),
    'seen': true,
    'is_group': true,
  };

  DatabaseReference reference = FirebaseDatabase.instance
      .ref()
      .child('messages_list') // Parent node
      .child(info['id'] ?? '') // User's UID or another field
      .child(uniqueID); // Child is the unique ID for the message

  // Write user information to the database
  reference.set(userInfo).then((_) {

  }).catchError((error) {

  });
}
Future<void> addToGroupMessageList(List<UserModel> selectedUsersList, Map<String, String> info, String groupName, String uniqueID) async {
  Map<String, dynamic> userInfo = {
    'name': groupName,
    'message': info['name'] ?? 'user' + " " + "created a group with you in it",
    'created_at': DateTime.now().millisecondsSinceEpoch.toString(),
    'seen': true,
    'is_group': true,
  };

  // Loop through each user in the selectedUsersList
  for (UserModel user in selectedUsersList) {
    // Reference to the Firebase Realtime Database
    DatabaseReference reference = FirebaseDatabase.instance
        .ref()
        .child('messages_list') // Parent node
        .child(user.id) // User's UID or another field
        .child(uniqueID); // Child is the unique ID for the message

    // Write user information to the database
    reference.set(userInfo).then((_) {
      print('Message added for user ${user.name} successfully!');
    }).catchError((error) {
      print('Error adding message for user ${user.name}: $error');
    });
  }
}

Future<void> addToGroupLeader(Map<String, String> info, String uniqueID) async {
  Map<String, dynamic> userInfo = {
    'id': info['id'],
    'name': info['name'],
  };

  DatabaseReference reference = FirebaseDatabase.instance
      .ref()
      .child('group_leader') // Parent node
      .child(uniqueID) // User's UID or another field
      .child(info['id'] ?? ""); // Child is the unique ID for the message

  reference.set(userInfo).then((_) {

  }).catchError((error) {

  });
}