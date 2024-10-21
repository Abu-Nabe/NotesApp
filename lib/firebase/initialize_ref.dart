import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<DatabaseReference> setUpFirebaseRef() async {
  // Load the .env file
  await dotenv.load(fileName: ".env");

  print(dotenv.env['FIREBASE_REAL_TIME_DATABASE_ID']);
  // Create a DatabaseReference using the URL from the .env file
  DatabaseReference dbRef = FirebaseDatabase.instance.refFromURL(
      dotenv.env['FIREBASE_REAL_TIME_DATABASE_ID'] ?? ''
  );
  // Return the DatabaseReference
  return dbRef;
}