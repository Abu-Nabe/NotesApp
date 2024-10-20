import 'dart:ffi';

import 'package:aag_group_services/authentication_pages/login_controller.dart';
import 'package:aag_group_services/consts/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../consts/strings/authentication_strings/authentication_strings.dart';
import '../../extension/phone_number_simplifier.dart';
import '../../firebase/phone_verification.dart';

Widget build_login_screen(BuildContext context, FirebaseAuth auth) {
  final size = MediaQuery.of(context).size;

  return Scaffold(
    body: Container(
      width: size.width, // Full width
      height: size.height, // Full height
      color: ShadesOfGrey.grey2,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Add padding around the container
          child: build_login_container(context, auth), // Call the container here
        ),
      ),
    ),
  );
}

Widget build_login_container(BuildContext context, FirebaseAuth auth) {
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
      child: Column(
        mainAxisSize: MainAxisSize.min, // Adjust the height based on its children
        crossAxisAlignment: CrossAxisAlignment.center, // Align content to the center
        children: [
          loginLabel(),
          SizedBox(height: 20),
          loginField(authDetails, "email"),
          const SizedBox(height: 20),
          loginField(authDetails, "password"),
          const SizedBox(height: 10),
          buildSpaceBetweenContainer(auth ,authDetails),
          const SizedBox(height: 10),
          buildLoginButton(auth, authDetails),
          const SizedBox(height: 20),
          registerLabel(auth),
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

Widget loginPhoneField(Map<String, dynamic> authDetails) {
  return InternationalPhoneNumberInput(
    onInputChanged: (PhoneNumber number) {
      String verifyNumber = '${number.phoneNumber}';

      authDetails[numberString] = simplifyPhoneNumber(verifyNumber);
    },
    selectorConfig: SelectorConfig(
      selectorType: PhoneInputSelectorType.DROPDOWN,
    ),
    ignoreBlank: false,
    autoValidateMode: AutovalidateMode.disabled,
    selectorTextStyle: const TextStyle(color: Colors.black),
    textFieldController: TextEditingController(),
    formatInput: false,
    keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
    inputDecoration: InputDecoration(
      labelText: "Enter Phone Number",
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: ShadesOfGrey.grey2,
          width: 2.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: ShadesOfGrey.grey2, // Border color for the enabled state
          width: 2.0,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0), // Adjust padding
    ),
  );
}

Widget loginField(Map<String, dynamic> authDetails, String type){
  String text = "Enter email";

  if(type == "password"){
    text = "Enter password";
  }
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
  );
}

Widget loginCodeField(){
  return TextField(
    decoration: InputDecoration(
      labelText: "Enter Verification Code", // Label for the input field
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

Widget buildLoginButton(FirebaseAuth auth, Map<String, dynamic> authDetails) {
  return ElevatedButton(
    onPressed: () async {
      String phoneString = authDetails[numberString];
      print(phoneString);
      Map<String, dynamic> resultsMap = await verifyPhoneNumber(auth, phoneString);
      resultsMap.forEach((key, newValue) {
        if (LoginControllerState.authenticationMap.value.containsKey(key)) {
          LoginControllerState.authenticationMap.value[key] = newValue; // Update the value if key exists
        }
      });

      if(resultsMap[result]){
        LoginControllerState.loginToggled.value = true;
      }else{
        // error
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
      "Continue",
      style: TextStyle(
        fontSize: 16,
        color: Colors.white, // Set text color
        fontWeight: FontWeight.bold
      ),
    ),
  );
}

Widget errorLabel(FirebaseAuth auth, Map<String, dynamic> authDetails, String errorText){
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

Widget forgotLabel(FirebaseAuth auth){
  String errorText = "Forgot Password?";
  Color errorColor = ShadesOfGrey.grey4;

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

Widget registerLabel(FirebaseAuth auth){
  String errorText = "Register";
  Color errorColor = ShadesOfPurple.purple4;

  return InkWell(
    onTap: () {

    },
    child: Text(
      errorText,
      style: TextStyle(
        fontSize: 14,
        color: errorColor, // Set text color
        fontWeight: FontWeight.bold,
      ),
      overflow: TextOverflow.ellipsis, // Add ellipsis when text overflows
      maxLines: 1, // Ensure that it stays on one line
    ),
  );
}

Widget buildSpaceBetweenContainer(FirebaseAuth auth, Map<String, dynamic> authDetails) {
  String errorString = "";
  if (authDetails[type] != null && authDetails[type].exists) {
    errorString = "Error: invalid user credentials";
  }

  return Container(
    child: Row(
      children: [
        // Align errorLabel to the left
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: errorLabel(auth, authDetails, errorString),
          ),
        ),
        // Align registerLabel to the right
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: forgotLabel(auth),
          ),
        ),
      ],
    ),
  );
}
