import 'package:aag_group_services/design/authentication_pages/models/user_model.dart';
import 'package:aag_group_services/design/main_pages/controllers/contact.dart';

bool checkFriends(UserModel searchedUser) {
  // Get the list of current user's friends
  List<UserModel> friendsList = ContactsPageState.usersList.value; // Assuming this is a list of UserModel

  // Check if the searched user's ID is in the friends list
  return friendsList.any((friend) => friend.id != searchedUser.id);
}
