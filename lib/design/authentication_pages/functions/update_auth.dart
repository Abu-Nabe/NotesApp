import '../login_controller.dart';

void updateAuthDetails(Map<String, dynamic> authDetails, String key, dynamic value) {
  Map<String, dynamic> updatedAuthDetails = Map.from(authDetails);
  updatedAuthDetails[key] = value; // Update the specific key with the new value

  LoginControllerState.authenticationMap.value = updatedAuthDetails;
}
