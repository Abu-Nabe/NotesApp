import 'package:firebase_database/firebase_database.dart';


void addSenderMessageToDB(String sender, String receiver, String message, String username){
  // Create a map for the user information to be added
  Map<String, dynamic> userInfo = {
    'name': username,
    'message': message,
    'created_at': DateTime.now().millisecondsSinceEpoch.toString().toString(),
    'seen': false,
  };

  // Reference to the Firebase Realtime Database
  DatabaseReference reference = FirebaseDatabase.instance
      .ref()
      .child('messages') // Parent node
      .child(sender) // Current user's UID
      .child(receiver) // Child is the UID of the user being added
      .child(DateTime.now().millisecondsSinceEpoch.toString()); // Unique key based on timestamp

  // Write user information to the database
  reference.set(userInfo).then((_) {
    print('Note added successfully!');
  }).catchError((error) {
    print('Error adding user: $error');
  });
}

void addReceiverMessageToDB(String sender, String receiver, String message, String username){
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
      .child(receiver) // Current user's UID
      .child(sender) // Child is the UID of the user being added
      .child(DateTime.now().millisecondsSinceEpoch.toString());

  // Write user information to the database
  reference.set(userInfo).then((_) {
    print('Message added successfully!');
  }).catchError((error) {
    print('Error adding message: $error');
  });
}

void addToMessageList(String sender, String receiver, String message, String username, String receiverName){
  // Create a map for the user information to be added
  Map<String, dynamic> userInfo = {
    'name': receiverName,
    'message': message,
    'created_at': DateTime.now().millisecondsSinceEpoch.toString(),
    'seen': true,
  };

  // Reference to the Firebase Realtime Database
  DatabaseReference reference = FirebaseDatabase.instance
      .ref()
      .child('messages_list') // Parent node
      .child(sender) // Current user's UID
      .child(receiver); // Child is the UID of the user being added

  // Write user information to the database
  reference.set(userInfo).then((_) {
    print('Message added successfully!');
  }).catchError((error) {
    print('Error adding message: $error');
  });
}

void addToFriendMessageList(String sender, String receiver, String message, String username, String receiverName){
  // Create a map for the user information to be added
  Map<String, dynamic> userInfo = {
    'name': username,
    'message': message,
    'created_at': DateTime.now().toString(),
    'seen': false,
  };

  // Reference to the Firebase Realtime Database
  DatabaseReference reference = FirebaseDatabase.instance
      .ref()
      .child('messages_list') // Parent node
      .child(receiver) // Current user's UID
      .child(sender); // Child is the UID of the user being added

  // Write user information to the database
  reference.set(userInfo).then((_) {
    print('Message added successfully!');
  }).catchError((error) {
    print('Error adding Message: $error');
  });
}