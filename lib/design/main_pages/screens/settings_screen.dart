import 'package:aag_group_services/design/authentication_pages/login_controller.dart';
import 'package:aag_group_services/design/main_pages/controllers/settings.dart';
import 'package:aag_group_services/firebase/sign_out.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../consts/colors.dart';
import '../../../firebase/user_info.dart';
import '../../communications/controllers/message_controller.dart';
import '../../navigation/navigation_functions.dart';

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
            buildSettingsList("Change Profile", Icons.person, () {

              },
            ),
            buildSettingsList("Terms Of Service", Icons.description, () {

              },
            ),
            buildSettingsList("Log Out", Icons.exit_to_app, () {
                signOut();
                pushWithoutAnimation(context, LoginController());
              },
            ),
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

Widget buildSettingsList(String text, IconData icon, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap, // Callback for handling tap events
    child: Container(
      width: double.infinity, // Full width of the container
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0), // Padding around the content
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1.0)), // Bottom border
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: ShadesOfGrey.grey3, // Color for the icon
            size: 24.0, // Icon size
          ),
          SizedBox(width: 16.0), // Space between icon and text
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16.0, // Font size for the text
                fontWeight: FontWeight.w500, // Medium weight text
                color: Colors.black87, // Text color
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

