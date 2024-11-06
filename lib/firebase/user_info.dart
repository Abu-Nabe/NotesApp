import 'package:aag_group_services/firebase/currentUserId.dart';
import 'package:firebase_database/firebase_database.dart';

import '../design/authentication_pages/models/user_model.dart';

Future<Map<String, String>> fetchUserInfo() async {
  final database = FirebaseDatabase.instance.ref();

  try {
    // Fetch the user's data from Firebase
    final userSnapshot = await database.child('users').child(getCurrentUserID()).get();

    // Check if the snapshot exists
    if (userSnapshot.exists) {
      Map<dynamic, dynamic> userMap = userSnapshot.value as Map<dynamic, dynamic>;

      // Extract the user ID and name
      String userId = userSnapshot.key!;
      String? name = userMap['name'];

      // Return the user data with keys 'id' and 'username'
      return {'id': userId, 'username': name ?? ''};
    } else {
      print("No user data found for this user ID.");
      return {};
    }
  } catch (error) {
    print("Error fetching user data: $error");
    return {};
  }
}

Future<UserModel?> fetchUserInfoToModel(String userID) async {
  final database = FirebaseDatabase.instance.ref();

  try {
    // Fetch the user's data from Firebase
    final userSnapshot = await database.child('users').child(userID).get();

    // Check if the snapshot exists
    if (userSnapshot.exists) {
      Map<String, dynamic> userMap = Map<String, dynamic>.from(userSnapshot.value as Map<dynamic, dynamic>);

      // Create a UserModel instance using the fetched data
      return UserModel.fromMap(userSnapshot.key!, userMap);
    } else {
      print("No user data found for this user ID.");
      return null; // Return null if user data does not exist
    }
  } catch (error) {
    print("Error fetching user data: $error");
    return null; // Return null in case of an error
  }
}
