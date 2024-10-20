import 'package:aag_group_services/consts/strings/authentication_strings/authentication_strings.dart';

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
