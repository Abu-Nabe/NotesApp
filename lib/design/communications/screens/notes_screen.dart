import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget build_notes_screen(BuildContext context) {
  final size = MediaQuery.of(context).size;

  return Scaffold(
    body: Container(
      width: size.width, // Full width
      height: size.height, // Full height
      child: Column(
        children: [
          buildToolbar(context),
        ],
      ),
    ),
  );
}

Widget buildToolbar(BuildContext context) {
  return AppBar(
    leading: IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.white), // Back arrow icon
      onPressed: () {
        Navigator.pop(context); // Navigates back to the previous screen
      },
    ),
    title: Text(
      "Notes", // Title of the toolbar
      style: TextStyle(
        color: Colors.white, // Title text color
        fontWeight: FontWeight.bold, // Bold text
        fontSize: 20, // Font size of the title
      ),
    ),
    backgroundColor: Colors.blue, // Background color of the toolbar (customize as needed)
    elevation: 4, // Shadow effect under the AppBar
  );
}
