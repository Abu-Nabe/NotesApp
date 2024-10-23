import 'package:firebase_auth/firebase_auth.dart';

String getCurrentUserID(){
  return FirebaseAuth.instance.currentUser?.uid ?? "";
}