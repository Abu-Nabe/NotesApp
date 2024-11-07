import 'package:firebase_database/firebase_database.dart';

Future<Map<String, bool>> checkSeen(String sender, String receiver) async {
  final database = FirebaseDatabase.instance.ref();
  final snapshot = await database.child('messages_list').child(receiver).child(sender).get();

  if (snapshot.exists && snapshot.value is Map) {
    Map<dynamic, dynamic> itemsMap = snapshot.value as Map<dynamic, dynamic>;

    if (itemsMap.containsKey('seen') && itemsMap['seen'] is bool) {
      return {receiver: itemsMap['seen']};
    }

  }

  return {receiver: false}; // Default to false if 'seen' not found or invalid
}

Future<void> setSeen(String sender, String receiver) async {
  final database = FirebaseDatabase.instance.ref();
  final messageRef = database.child('messages_list').child(sender).child(receiver);

  final snapshot = await messageRef.get();

  if (snapshot.exists && snapshot.value is Map && (snapshot.value as Map).containsKey('seen')) {
    // Update the 'seen' field to true
    await messageRef.update({'seen': true});
  }
}
