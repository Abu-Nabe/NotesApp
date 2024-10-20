import 'package:aag_group_services/authentication_pages/functions/update_auth.dart';
import 'package:aag_group_services/consts/strings/authentication_strings/authentication_strings.dart';

import '../login_controller.dart';

String checkType(String type) {
  switch (type) {
    case registerEmail:
      return 'Enter Email';
    case registerPassword:
      return 'Enter Password';
    case registerFirstName:
      return 'Enter First Name';
    case registerLastName:
      return 'Enter Last Name';
    default:
      return 'Enter Input'; // Optional: Handle unknown types
  }
}

bool inputType(Map<String, dynamic> authDetails) {
  if (authDetails[registerEmail] == null || authDetails[registerEmail].isEmpty) {
    updateAuthDetails(authDetails, registerError, 'You left out your email');
    return false;
  } else if (authDetails[registerPassword] == null || authDetails[registerPassword].isEmpty) {
    updateAuthDetails(authDetails, registerError, 'You left out your password');
    return false;
  } else if (authDetails[registerFirstName] == null || authDetails[registerFirstName].isEmpty) {
    updateAuthDetails(authDetails, registerError, 'You left out your first name');
    return false;
  } else if (authDetails[registerLastName] == null || authDetails[registerLastName].isEmpty) {
    updateAuthDetails(authDetails, registerError, 'You left out your last name');
    return false;
  }

  return true; // All fields are filled
}

