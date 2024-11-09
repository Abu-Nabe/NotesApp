import 'package:aag_group_services/consts/colors.dart';
import 'package:aag_group_services/design/authentication_pages/screens/register_screen.dart';
import 'package:aag_group_services/firebase/reset_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../consts/strings/authentication_strings/authentication_strings.dart';
import '../../../extension/email_verifier.dart';
import '../../../firebase/create_account.dart';
import '../../bottom_navigation.dart';
import '../../navigation/navigation_functions.dart';
import '../functions/register_type.dart';
import '../functions/update_auth.dart';
import '../login_controller.dart';

Widget build_forgot_password_screen(BuildContext context, FirebaseAuth auth) {
  final size = MediaQuery.of(context).size;

  return Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back), // Back arrow icon
        onPressed: () {
          LoginControllerState.screenUpdate.value = 1; // Change to the login screen
        },
      ),
      backgroundColor: ShadesOfGrey.grey2, // Set a background color for the AppBar
    ),
    body: GestureDetector(
      onTap: () {
        // Unfocus any currently focused text field
        FocusScope.of(context).unfocus();
      },
      child: Container(
        width: size.width, // Full width
        height: size.height, // Full height
        color: ShadesOfGrey.grey2,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Add padding around the container
            child: build_container(context, auth), // Call the container here
          ),
        ),
      ),
    ),
  );
}

Widget build_container(BuildContext context, FirebaseAuth auth) {
  Map<String, dynamic> authDetails = LoginControllerState.authenticationMap.value;

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
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Color of the shadow
            spreadRadius: 2, // Spread radius of the shadow
            blurRadius: 5, // Blur radius of the shadow
            offset: const Offset(0, 3), // Changes the position of the shadow
          ),
        ],
      ),
      child: SingleChildScrollView( // Make the container scrollable
        child: Column(
          mainAxisSize: MainAxisSize.min, // Adjust the height based on its children
          crossAxisAlignment: CrossAxisAlignment.center, // Align content to the center
          children: [
            containerLabel(),
            SizedBox(height: 20),
            inputField(authDetails, forgotPasswordEmail),
            const SizedBox(height: 20),
            buildRegisterButton(context,auth, authDetails),
            if (authDetails[forgotPasswordError] != null && authDetails[forgotPasswordError].isNotEmpty)
              ...[
                const SizedBox(height: 20),
                errorLabel(authDetails[forgotPasswordError]),
              ],
          ],
        ),
      ),
    ),
  );
}


Widget containerLabel(){
  return Text(
    "Forgot Password",
    style: TextStyle(
      fontSize: 18, // Font size for the title
      fontWeight: FontWeight.bold, // Bold text for the title
      color: ShadesOfBlack.black2,
    ),
  );
}

Widget inputField(Map<String, dynamic> authDetails, String type){
  return TextField(
    decoration: InputDecoration(
      labelText: 'Enter Email', // Label for the input field
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
    onChanged: (value) {
      authDetails[type] = value;
    },
  );
}

Widget buildRegisterButton(BuildContext context,FirebaseAuth auth, Map<String, dynamic> authDetails) {
  return ElevatedButton(
    onPressed: () async {
      if(authDetails[forgotPasswordEmail].toString().trim() == "" || authDetails[forgotPasswordEmail] == null){
        updateAuthDetails(authDetails, forgotPasswordError, 'Make sure email is not empty');
      }else if (!isValidEmail(authDetails[forgotPasswordEmail].toString())) {
        updateAuthDetails(authDetails, forgotPasswordError, 'Email is not valid');
      }else{
        bool isSuccessful = await resetPassword(auth, authDetails[forgotPasswordEmail].toString());

        if(isSuccessful){
          LoginControllerState.screenUpdate.value = 1; // Change to the login screen
        }else{
          updateAuthDetails(authDetails, forgotPasswordError, 'Error: failed to send reset link to email');
        }
      }
    },
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0),
      backgroundColor: ShadesOfPurple.purple_iris, // Set background color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Match button with container radius
        side: const BorderSide(
          color: ShadesOfPurple.purple4, // Set border color
          width: 2.0, // Border width
        ),
      ),
    ),
    child: const Text(
      "Send Link To Email",
      style: TextStyle(
        fontSize: 16,
        color: Colors.white, // Set text color
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget errorLabel(String errorText){
  Color errorColor = ShadesOfPurple.purple_violet;

  return InkWell(
    onTap: () {

    },
    child: Text(
      errorText,
      style: TextStyle(
        fontSize: 13,
        color: errorColor, // Set text color
        fontWeight: FontWeight.bold,
      ),
      overflow: TextOverflow.ellipsis, // Add ellipsis when text overflows
      maxLines: 1, // Ensure that it stays on one line
    ),
  );
}