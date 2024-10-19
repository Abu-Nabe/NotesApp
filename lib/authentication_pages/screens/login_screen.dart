import 'package:aag_group_services/consts/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget build_login_screen(BuildContext context) {
  final size = MediaQuery.of(context).size;

  return Scaffold(
    body: Container(
      width: size.width, // Full width
      height: size.height, // Full height
      color: ShadesOfGrey.grey2,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Add padding around the container
          child: build_login_container(context), // Call the container here
        ),
      ),
    ),
  );
}

Widget build_login_container(BuildContext context) {
  return Align(
    alignment: Alignment.center, // Center the container horizontally
    child: Container(
      padding: const EdgeInsets.all(16.0), // Add padding inside the container
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0), // Add circular border radius
        border: Border.all(
          color: ShadesOfGrey.grey2, // Border color
          width: 2.0, // Border width
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Adjust the height based on its children
        crossAxisAlignment: CrossAxisAlignment.center, // Align content to the center
        children: [
          loginLabel(),
          const SizedBox(height: 20), // Space between the title and the input field
          loginPhoneField(),
          const SizedBox(height: 20),
          buildLoginButton(),
        ],
      ),
    ),
  );
}

Widget loginLabel(){
  return Text(
    "Sign In",
    style: TextStyle(
      fontSize: 18, // Font size for the title
      fontWeight: FontWeight.bold, // Bold text for the title
      color: ShadesOfBlack.black2,
    ),
  );
}

Widget loginPhoneField(){
  return TextField(
    decoration: InputDecoration(
      labelText: "Enter Phone Number", // Label for the input field
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0), // Add circular border radius
        borderSide: BorderSide(
          color: ShadesOfGrey.grey2, // Border color
          width: 2.0, // Border width
        ),
      ), // Add a border to the input field
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: ShadesOfGrey.grey2, // Border color for the enabled state
          width: 2.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: ShadesOfPurple.purple2, // Border color when focused
          width: 2.0,
        ),
      ),
    ),
    keyboardType: TextInputType.phone, // Keyboard type for phone input
  );
}

Widget buildLoginButton() {
  return ElevatedButton(
    onPressed: () {
      // Handle button press
    },
    style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0),
      backgroundColor: ShadesOfPurple.purple3, // Set background color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Match button with container radius
        side: const BorderSide(
          color: ShadesOfPurple.purple4, // Set border color
          width: 2.0, // Border width
        ),
      ),
    ),
    child: const Text(
      "Continue",
      style: TextStyle(
        fontSize: 16,
        color: Colors.white, // Set text color
      ),
    ),
  );
}
