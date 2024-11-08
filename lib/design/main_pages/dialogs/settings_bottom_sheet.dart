import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
            onTap: () {
              // Handle Change Profile action
              Navigator.pop(context); // Close the dialog
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