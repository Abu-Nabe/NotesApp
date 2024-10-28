import 'package:aag_group_services/design/authentication_pages/models/user_model.dart';
import 'package:aag_group_services/design/main_pages/controllers/contact.dart';

bool checkFriends(UserModel searchedUser) {
  List<UserModel> friendsList = ContactsPageState.usersList.value;

  // Ensure the IDs are compared as strings to prevent type mismatch
  return !friendsList.any((friend) => friend.id.toString() == searchedUser.id.toString());
}
