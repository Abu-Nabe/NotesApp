import 'package:aag_group_services/consts/colors.dart';
import 'package:aag_group_services/design/authentication_pages/models/user_model.dart';
import 'package:aag_group_services/design/communications/controllers/group_members_controller.dart';
import 'package:aag_group_services/design/communications/controllers/message_controller.dart';
import 'package:aag_group_services/design/communications/controllers/notes_controller.dart';
import 'package:aag_group_services/design/navigation/navigation_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../firebase/add_friend_firebase.dart';
import '../functions/remove_group_firebase.dart';
import '../model/group_model.dart';

Widget build_group_message_screen(BuildContext context, String groupID) {
  final size = MediaQuery.of(context).size;

  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Group Members',
        style: TextStyle(
          color: ShadesOfGrey.grey5, // Text color
          fontSize: 20, // Font size
          fontWeight: FontWeight.bold, // Bold text
          letterSpacing: 1.2, // Space between letters
        ),
      ),
    ),
    body: Container(
      width: size.width, // Full width
      height: size.height, // Full height
      child: Column(
        children: [
          searchField(),
          shadowLine(),
          listContainer(context, groupID),
        ],
      ),
    ),
  );
}
Widget searchField() {
  TextEditingController controller = GroupMemberControllerState.searchController.value;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding for the search bar
    child: TextField(
      controller: controller, // Controller for managing text input
      decoration: InputDecoration(
        hintText: 'Search Members', // Placeholder text
        filled: true, // Fill the background
        fillColor: Colors.grey[200], // Background color of the search bar
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
          borderSide: BorderSide.none, // No border line
        ),
        prefixIcon: Icon(Icons.search), // Search icon
        suffixIcon: GroupMemberControllerState.searchMode.value
            ? IconButton(
          icon: Icon(Icons.clear), // Clear icon
          onPressed: () {
            controller.clear(); // Clear the text
            GroupMemberControllerState.searchText.value = "";
            GroupMemberControllerState.searchMode.value = false;
          },
        ) : null,
      ),
      onChanged: (text) {
        GroupMemberControllerState.searchText.value = text;
        if(text.toString().trim() == ""){
          GroupMemberControllerState.searchMode.value = false;
        }else{
          GroupMemberControllerState.searchMode.value = true;
        }
      },
    ),
  );
}


Widget shadowLine(){
  return Container(
    height: 1, // Height of the shadow line
    width: double.infinity, // Full width
    decoration: BoxDecoration(
      color: ShadesOfGrey.grey2, // Line color
      boxShadow: [
        BoxShadow(
          color: Colors.black26, // Shadow color
          offset: Offset(0, 1), // Shadow position
          blurRadius: 3, // Shadow blur
        ),
      ],
    ),
  );
}

Widget listContainer(BuildContext context, String groupID) {
  List<GroupUserModel> userModel = GroupMemberControllerState.searchMode.value
      ? GroupMemberControllerState.searchList.value
      : GroupMemberControllerState.usersList.value;

  return Expanded(
    child:  GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss keyboard on tap
      },
      child: Container(
        color: ShadesOfGrey.grey1, // Background color
        child: ListView.separated(
          itemCount: userModel.length,
          separatorBuilder: (context, index) => Divider(color: ShadesOfGrey.grey2, height: 1), // Divider between items
          itemBuilder: (context, index) {
            final user = userModel[index]; // Get the user at the current index
            return buildItemContainer(context, user.name, user, groupID); // Display each user's name
          },
        ),
      ),
    ),
  );
}

Widget buildItemContainer(BuildContext context, String name, GroupUserModel userModel, String groupID) {
  bool isHost = userModel.host;

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding around the container
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.grey[300]!, width: 2), // Optional bottom border for separation
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns children across the row
      children: [
        // Icon and name section
        Row(
          children: [
            // Circular icon with border
            Container(
              width: 40, // Width of the circular container
              height: 40, // Height of the circular container
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Makes the container circular
                border: Border.all(color: ShadesOfGrey.grey3, width: 2), // Border color and width
                color: Colors.white, // Background color of the circular icon
              ),
              child: Icon(
                Icons.person,
                size: 24, // Size of the icon inside the circular container
                color: ShadesOfGrey.grey3, // Icon color
              ),
            ),
            SizedBox(width: 10), // Space between icon and name
            Column(
              mainAxisAlignment: MainAxisAlignment.start, // Aligns children across the row
              crossAxisAlignment: CrossAxisAlignment.start, // Aligns children across the row
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16, // Font size for the name
                    fontWeight: FontWeight.bold, // Bold text
                    color: ShadesOfGrey.grey5,
                  ),
                ),
                Text(
                  !isHost ? "Member" : "Host",
                  style: TextStyle(
                    fontSize: 14, // Font size for the name
                    fontWeight: FontWeight.w500, // Bold text
                    color: ShadesOfGrey.grey5,
                  ),
                ),
              ],
            )
          ],
        ),
        !isHost ? buildRightItemContainer(context, userModel, groupID)
        : SizedBox.shrink(), // Call for non-friends
      ],
    ),
  );
}

Widget buildRightItemContainer(BuildContext context, GroupUserModel userModel, String groupID){
  return  TextButton(
    onPressed: () {
      removeGroupUser(groupID, userModel.id);
    },
    child: Text(
      'Remove',
      style: TextStyle(
        color: ShadesOfRed.red5, // Text color (customize as needed)
        fontSize: 16, // Font size (customize as needed)
        fontWeight: FontWeight.bold, // Font size (customize as needed)
      ),
    ),
  );
}
