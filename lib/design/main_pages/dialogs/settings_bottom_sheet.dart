import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../consts/permissions/check_permissions.dart';
import '../../../firebase/add_image_to_firebase_storage.dart';

final ImagePicker _picker = ImagePicker();

void showProfileOptionsDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              'Change Profile',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () async {
              bool hasPermission = await checkGalleryPermission();

              if (hasPermission) {
                // Proceed to pick the image if permission is granted
                final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  // Handle the selected image, e.g., update the profile picture
                  print("Selected image path: ${image.path}");
                  File file = File(image.path);
                  uploadImage(file);
                } else {
                  Navigator.pop(context); // Close the dialog if no image is selected
                }
              } else {
                // Optionally, show a message to the user that permission is needed
                print("Gallery access permission denied");
                Navigator.pop(context); // Close the dialog
              }
            },
          ),
          Divider(height: 1),
          ListTile(
            title: Text(
              'Remove Profile',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.red, // Red color for Remove Profile
              ),
            ),
            onTap: () {
              // Handle Remove Profile action
              Navigator.pop(context); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}