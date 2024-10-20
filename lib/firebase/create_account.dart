import 'package:aag_group_services/consts/strings/authentication_strings/authentication_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<UserCredential?> createAnAccount(FirebaseAuth auth, Map<String, dynamic> authDetails) async {
  try {
    // Create a new user with email and password
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: authDetails[registerEmail],
      password: authDetails[registerPassword],
    );

    return userCredential; // Return the UserCredential on success
  } on FirebaseAuthException catch (e) {
    // Handle errors here
    if (e.code == 'weak-password') {
      authDetails[registerError] = "The password provided is too weak.";
    } else if (e.code == 'email-already-in-use') {
      authDetails[registerError] = "The account already exists for that email.";
    } else {
      authDetails[registerError] = "Error Creating An Account.";
    }
    return null; // Return null on error
  } catch (e) {
    authDetails[registerError] = "Error Creating An Account.";
    return null; // Return null for any other error
  }
}
