import 'dart:io';
import 'package:aag_group_services/firebase/currentUserId.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

Future<void> uploadImage(File imageFile) async {
  // Define the path in Firebase Storage for the uploaded image using the user ID
  String storagePath = 'uploads/${getCurrentUserID()}';

  // Upload the file to Firebase Storage
  try {
    await FirebaseStorage.instance.ref(storagePath).putFile(imageFile);
    print("Upload successful!");
  } catch (e) {
    print("Failed to upload image: $e");
  }
}
