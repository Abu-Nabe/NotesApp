import 'package:aag_group_services/consts/strings/authentication_strings/authentication_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../design/authentication_pages/functions/update_auth.dart';

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
      updateAuthDetails(authDetails, registerError, 'The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      updateAuthDetails(authDetails, registerError, 'The account already exists for that email.');
    } else {
      updateAuthDetails(authDetails, registerError, 'Error Creating An Account.');
    }
    return null; // Return null on error
  } catch (e) {
    updateAuthDetails(authDetails, registerError, 'Error Creating An Account.');
    return null; // Return null for any other error
  }
}

Future<bool> addAccountToDb(String userId, Map<String, dynamic> authDetails) async {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  String fullname = '${authDetails[registerFirstName]} ${authDetails[registerLastName]}';
  try {
    await _database.child('users/$userId').set({
      'name': fullname,
      'email': authDetails[registerEmail],
      'created_at': ServerValue.timestamp, // Optional: for creation timestamp
    });
    return true;
  } catch (e) {
    updateAuthDetails(authDetails, registerError, 'Error Creating An Account.');
    print(e.toString());
    return false;
  }
}

Future<bool> signInWithEmailAndPassword(FirebaseAuth auth, Map<String, dynamic> authDetails) async {
  try {
    // Sign in the user with email and password
    await auth.signInWithEmailAndPassword(
      email: authDetails[loginEmail], // Replace with your email key
      password: authDetails[loginPassword], // Replace with your password key
    );

    return true; // Return true on success
  } on FirebaseAuthException catch (e) {
    // Handle sign-in errors here
    if (e.code == 'user-not-found') {
      updateAuthDetails(authDetails, loginError, 'No user found for that email.');
    } else if (e.code == 'wrong-password') {
      updateAuthDetails(authDetails, loginError, 'Wrong password provided.');
    } else {
      updateAuthDetails(authDetails, loginError, 'Error Signing In.');
    }
    return false; // Return false on error
  } catch (e) {
    // Handle any other errors
    updateAuthDetails(authDetails, loginError, 'Error Signing In.');
    return false; // Return false for any other error
  }
}
