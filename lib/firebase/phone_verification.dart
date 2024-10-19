import 'package:firebase_auth/firebase_auth.dart';

import 'dart:async';

import '../consts/strings/authentication_strings/authentication_strings.dart'; // Import this to use Completer

Future<Map<String, dynamic>> verifyPhoneNumber(FirebaseAuth auth, String phoneNumber) async {
  final Completer<Map<String, dynamic>> completer = Completer<Map<String, dynamic>>();

  String? verificationId; // Variable to hold the verification ID

  await auth.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: (PhoneAuthCredential credential) async {
      await auth.signInWithCredential(credential);
      completer.complete({
        verificationCode: null, // No code to show for auto-verification
        result: true, // Sign-in was successful
      });
    },
    verificationFailed: (FirebaseAuthException e) {
      // Handle failed verification
      completer.complete({
        verificationCode: null,
        result: false, // Sign-in failed
        type: 1,
      });
    },
    codeSent: (String verificationIdSent, int? resendToken) {
      verificationId = verificationIdSent; // Store verification ID
      // You might want to notify the user here
      completer.complete({
        verificationCode: verificationId, // Return the verification ID
        result: false, // Code sent, but not verified yet
        type: 2,
      });
    },
    codeAutoRetrievalTimeout: (String verificationIdTimeout) {
      verificationId = verificationIdTimeout; // Store verification ID
      // Notify user about timeout
      print('Auto-retrieval timeout. Please enter the verification code manually.');
    },
  );

  return completer.future; // Return the future of the completer
}


Future<void> signInWithPhoneNumber(FirebaseAuth auth,String vertificationID, String smsCode) async {
  PhoneAuthCredential credential = PhoneAuthProvider.credential(
    verificationId: vertificationID,
    smsCode: smsCode,
  );

  await auth.signInWithCredential(credential);
}