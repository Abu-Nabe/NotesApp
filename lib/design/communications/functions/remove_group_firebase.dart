import 'package:firebase_database/firebase_database.dart';

void removeGroupUser(String groupID, String userID) {
  // Define the reference
  DatabaseReference reference = FirebaseDatabase.instance
      .ref()
      .child('messages_list') // Parent node
      .child(userID) // User's UID or another field
      .child(groupID); // Child is the unique ID for the message

// Remove the specific message with uniqueID
  reference.remove().then((_) {
    print('Message removed successfully.');
  }).catchError((error) {
    print('Failed to remove message: $error');
  });

  DatabaseReference group_reference = FirebaseDatabase.instance
      .ref()
      .child('group_list') // Parent node
      .child(groupID)
      .child(userID);

  group_reference.remove().then((_) {
    print('Message removed successfully.');
  }).catchError((error) {
    print('Failed to remove message: $error');
  });
}
