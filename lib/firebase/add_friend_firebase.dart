import 'package:aag_group_services/firebase/currentUserId.dart';
import 'package:firebase_database/firebase_database.dart';

import '../design/authentication_pages/models/user_model.dart';

void addFriendToDB(UserModel user){
  String currentUserId = getCurrentUserID(); // Replace with the actual current user ID
  String userIdToAdd = user.id; // The ID of the user to be added

  // Create a map for the user information to be added
  Map<String, dynamic> userInfo = {
    'name': user.name,
    'email': user.email,
    'created_at': user.createdAt,
  };

  // Reference to the Firebase Realtime Database
  DatabaseReference userRef = FirebaseDatabase.instance
      .ref()
      .child('contacts') // Parent node
      .child(currentUserId) // Current user's UID
      .child(userIdToAdd); // Child is the UID of the user being added

  // Write user information to the database
  userRef.set(userInfo).then((_) {
    print('User added successfully!');
  }).catchError((error) {
    print('Error adding user: $error');
  });
}