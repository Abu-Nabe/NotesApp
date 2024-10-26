import 'package:firebase_auth/firebase_auth.dart';

Future<bool> resetPassword(FirebaseAuth auth,String email) async {
  try {
    await auth.sendPasswordResetEmail(email: email);
    return true;
  } catch (e) {
    return false;
  }
}
