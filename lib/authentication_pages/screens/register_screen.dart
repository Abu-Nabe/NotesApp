import 'package:aag_group_services/authentication_pages/login_controller.dart';
import 'package:aag_group_services/consts/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../bottom_navigation.dart';
import '../../consts/strings/authentication_strings/authentication_strings.dart';
import '../../firebase/create_account.dart';
import '../functions/register_type.dart';

Widget build_register_screen(BuildContext context, FirebaseAuth auth) {
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
    body: Container(
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
            inputField(authDetails, registerEmail),
            const SizedBox(height: 20),
            inputPasswordField(authDetails, registerPassword),
            const SizedBox(height: 20),
            inputField(authDetails, registerFirstName),
            const SizedBox(height: 20),
            inputField(authDetails, registerLastName),
            const SizedBox(height: 20),
            buildRegisterButton(context,auth, authDetails),
            if (authDetails[registerError] != null && authDetails[registerError].isNotEmpty)
              ...[
                const SizedBox(height: 20),
                errorLabel(authDetails[registerError]),
              ],
          ],
        ),
      ),
    ),
  );
}


Widget containerLabel(){
  return Text(
    "Create An Account",
    style: TextStyle(
      fontSize: 18, // Font size for the title
      fontWeight: FontWeight.bold, // Bold text for the title
      color: ShadesOfBlack.black2,
    ),
  );
}

Widget inputField(Map<String, dynamic> authDetails, String type){
  String text = checkType(type);

  return TextField(
    decoration: InputDecoration(
      labelText: text, // Label for the input field
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

Widget inputPasswordField(Map<String, dynamic> authDetails, String type) {
  String text = checkType(type);

  return TextField(
    obscureText: true, // Set this to true to hide password characters
    decoration: InputDecoration(
      labelText: text, // Label for the input field
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0), // Add circular border radius
        borderSide: BorderSide(
          color: ShadesOfGrey.grey2, // Border color
          width: 2.0, // Border width
        ),
      ),
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
      authDetails[type] = value; // Update authDetails with the input value
    },
  );
}


Widget buildRegisterButton(BuildContext context,FirebaseAuth auth, Map<String, dynamic> authDetails) {
  return ElevatedButton(
    onPressed: () async {
      if(inputType(authDetails)){
        UserCredential? userCredential = await createAnAccount(auth, authDetails);
        if (userCredential != null) {
          String userId = userCredential.user?.uid ?? '';
          bool isSuccessful = await addAccountToDb(userId, authDetails);

          if (isSuccessful) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigation()));
          }
        }
      }
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
      "Register",
      style: TextStyle(
        fontSize: 16,
        color: Colors.white, // Set text color
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget errorLabel(String errorText){
  Color errorColor = ShadesOfRed.red5;

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