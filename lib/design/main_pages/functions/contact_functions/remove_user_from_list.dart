// Function to remove the current user from the fetched users list
void removeCurrentUserFromList(Map<dynamic, dynamic> usersMap, String currentUserId) {
  // Remove the current user from the usersMap
  usersMap.removeWhere((key, value) => key == currentUserId);
}
