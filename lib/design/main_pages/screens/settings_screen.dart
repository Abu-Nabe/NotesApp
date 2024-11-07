import 'package:aag_group_services/design/main_pages/controllers/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../consts/colors.dart';
import '../../../firebase/user_info.dart';

Widget build_settings_screen(BuildContext context) {
  final size = MediaQuery.of(context).size;

  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Settings',
        style: TextStyle(
          color: ShadesOfGrey.grey5, // Text color
          fontSize: 20, // Font size
          fontWeight: FontWeight.bold, // Bold text
          letterSpacing: 1.2, // Space between letters
        ),
      ),
    ),
    body: Container(
      width: size.width, // Full width
      height: size.height, // Full height
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Centers vertically within the available space
          crossAxisAlignment: CrossAxisAlignment.center, // Centers horizontally
          children: [
            shadowLine(),
            SizedBox(height: 1), // Optional spacing between items
            buildProfileContainer(),
          ],
        ),
      ),
    ),
  );
}

Widget buildProfileContainer() {
  return Container(
    width: double.infinity, // Makes the container take full width of the screen
    padding: EdgeInsets.all(16.0), // Add some padding around the container
    color: Colors.grey[200], // Light grey background color
    child: Column(
      mainAxisSize: MainAxisSize.min, // Shrink-wraps the column to its contents
      mainAxisAlignment: MainAxisAlignment.center, // Center-aligns content vertically
      children: [
        buildCircularIcon(), // Circular icon at the top
        SizedBox(height: 8.0), // Space between icon and text
        buildProfileLabel(),
      ],
    ),
  );
}



Widget shadowLine() {
  return Container(
    height: 1, // Height of the shadow line
    width: double.infinity, // Full width
    decoration: BoxDecoration(
      color: ShadesOfGrey.grey2, // Line color
      boxShadow: [
        BoxShadow(
          color: Colors.black26, // Shadow color
          offset: Offset(0, 1), // Shadow position
          blurRadius: 3, // Shadow blur
        ),
      ],
    ),
  );
}

Widget buildCircularIcon() {
  return Container(
    width: 60.0,  // Width of the circular icon
    height: 60.0, // Height of the circular icon
    decoration: BoxDecoration(
      color: ShadesOfGrey.grey4, // Background color of the icon
      shape: BoxShape.circle, // Makes the container circular
    ),
    child: Icon(
      Icons.person, // Icon inside the circle
      color: Colors.white, // Icon color
      size: 40.0, // Icon size
    ),
  );
}

Widget buildProfileLabel(){
  return Text(
    SettingsPageState.userInfo.value['username'] ?? '', // Replace with actual profile name
    style: TextStyle(
      fontSize: 16.0, // Font size for the text
      fontWeight: FontWeight.bold, // Bold text
      color: Colors.black, // Text color
    ),
  );
}