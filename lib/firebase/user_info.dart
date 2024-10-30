import 'package:aag_group_services/firebase/currentUserId.dart';
import 'package:firebase_database/firebase_database.dart';

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
