import 'package:aag_group_services/consts/colors.dart';
import 'package:aag_group_services/design/authentication_pages/models/user_model.dart';
import 'package:aag_group_services/design/communications/controllers/message_controller.dart';
import 'package:aag_group_services/design/communications/controllers/notes_controller.dart';
import 'package:aag_group_services/design/navigation/navigation_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../firebase/add_friend_firebase.dart';
import '../controllers/contact.dart';
import '../functions/contact_functions/check_friends.dart';

Widget build_contact_screen(BuildContext context) {
  final size = MediaQuery.of(context).size;

  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Contacts',
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
          listContainer(context),
        ],
      ),
    ),
  );
}
Widget searchField() {
  TextEditingController controller = ContactsPageState.searchController.value;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding for the search bar
    child: TextField(
      controller: controller, // Controller for managing text input
      decoration: InputDecoration(
        hintText: 'Search Contacts', // Placeholder text
        filled: true, // Fill the background
        fillColor: Colors.grey[200], // Background color of the search bar
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
          borderSide: BorderSide.none, // No border line
        ),
        prefixIcon: Icon(Icons.search), // Search icon
        suffixIcon: ContactsPageState.searchMode.value
            ? IconButton(
          icon: Icon(Icons.clear), // Clear icon
          onPressed: () {
            controller.clear(); // Clear the text
            ContactsPageState.searchText.value = "";
            ContactsPageState.searchMode.value = false;
          },
        ) : null,
      ),
      onChanged: (text) {
        ContactsPageState.searchText.value = text;
        if(text.toString().trim() == ""){
          ContactsPageState.searchMode.value = false;
        }else{
          ContactsPageState.searchMode.value = true;
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

Widget listContainer(BuildContext context) {
  List<UserModel> userModel = ContactsPageState.searchMode.value
      ? ContactsPageState.searchList.value
      : ContactsPageState.usersList.value;

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
            return buildItemContainer(context, user.name, user); // Display each user's name
          },
        ),
      ),
    ),
  );
}

Widget buildItemContainer(BuildContext context, String name, UserModel userModel) {
  bool user_type = false;
  // Check if search mode is active
  if (ContactsPageState.searchMode.value) {
    // Check if the user is a friend
    user_type = checkFriends(userModel);
  }
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding around the container
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.grey[300]!, width: 1), // Optional bottom border for separation
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
            Text(
              name,
              style: TextStyle(
                fontSize: 16, // Font size for the name
                fontWeight: FontWeight.bold, // Bold text
                color: ShadesOfGrey.grey5,
              ),
            ),
          ],
        ),
        // Conditionally render either buildSearchItemContainer or buildRightItemContainer
        user_type
            ? buildSearchItemContainer(context, userModel) // Call for friends
            : buildRightItemContainer(context, userModel), // Call for non-friends
      ],
    ),
  );
}

Widget buildRightItemContainer(BuildContext context, UserModel userModel){
  return Row(
    children: [
      // Notes icon with separate on click action
      GestureDetector(
        onTap: () {
          pushWithoutAnimation(context, NotesController(receiverModel: userModel,));
        },
        child: Container(
          padding: EdgeInsets.all(8), // Padding for better touch area
          decoration: BoxDecoration(
            shape: BoxShape.circle, // Makes the icon button circular
            color: Colors.blue.withOpacity(0.1), // Background color with transparency
          ),
          child: Icon(
            Icons.note_add,
            size: 24, // Size of the icon
            color: Colors.blue, // Icon color
          ),
        ),
      ),
      TextButton(
        onPressed: () {
          // Handle message action here
          pushWithoutAnimation(context, MessageController(receiverModel: userModel,));
        },
        child: Text(
          'Message',
          style: TextStyle(
            color: Colors.blue, // Text color (customize as needed)
            fontSize: 16, // Font size (customize as needed)
          ),
        ),
      ),
    ],
  );
}

Widget buildSearchItemContainer(BuildContext context, UserModel userModel) {
  return TextButton(
    onPressed: () {
      addFriendToDB(userModel); // Add the friend to the database

      ContactsPageState.searchController.value.clear();
      ContactsPageState.searchText.value = "";
      ContactsPageState.searchMode.value = false;
    },
    child: Row(
      mainAxisSize: MainAxisSize.min, // Adjust size to fit icon and text only
      children: [
        // Conditionally show the add icon based on the added state
          Icon(
            Icons.add, // The + icon
            color: Colors.blue, // Icon color
            size: 18, // Icon size
          ),
        SizedBox(width: 4), // Space between icon and text
        Text(
          "Add",
          style: TextStyle(
            color: Colors.blue, // Text color
            fontSize: 16, // Font size
          ),
        ),
      ],
    ),
  );
}

