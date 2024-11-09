import 'package:aag_group_services/design/communications/controllers/create_group_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../consts/colors.dart';
import '../../authentication_pages/models/user_model.dart';

Widget build_create_group_screen(BuildContext context) {
  final size = MediaQuery.of(context).size;

  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Create Group',
        style: TextStyle(
          color: ShadesOfGrey.grey5, // Text color
          fontSize: 20, // Font size
          fontWeight: FontWeight.bold, // Bold text
          letterSpacing: 1.2, // Space between letters
        ),
      ),
      actions: [
        if (CreateGroupControllerState.selectedUsers.value.length > 0)
          TextButton(
            onPressed: () {
              // Add your create action here
            },
            child: Text(
              'Create',
              style: TextStyle(
                color: ShadesOfPurple.purple_iris, // Text color
                fontSize: 16, // Font size for 'Create'
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
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
  TextEditingController controller = CreateGroupControllerState.searchController.value;

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
        suffixIcon: CreateGroupControllerState.searchMode.value
            ? IconButton(
          icon: Icon(Icons.clear), // Clear icon
          onPressed: () {
            controller.clear(); // Clear the text
            CreateGroupControllerState.searchText.value = "";
            CreateGroupControllerState.searchMode.value = false;
          },
        ) : null,
      ),
      onChanged: (text) {
        CreateGroupControllerState.searchText.value = text;
        if(text.toString().trim() == ""){
          CreateGroupControllerState.searchMode.value = false;
        }else{
          CreateGroupControllerState.searchMode.value = true;
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
  List<UserModel> userModel = CreateGroupControllerState.searchMode.value
      ? CreateGroupControllerState.searchList.value
      : CreateGroupControllerState.usersList.value;

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
  return GestureDetector(
    onTap: () {
      if (CreateGroupControllerState.selectedUsers.value.contains(userModel.id)) {
        // If user ID exists, remove it
        CreateGroupControllerState.selectedUsers.value = List.from(CreateGroupControllerState.selectedUsers.value)..remove(userModel.id);
      } else {
        // If user ID does not exist, add it
        CreateGroupControllerState.selectedUsers.value = List.from(CreateGroupControllerState.selectedUsers.value)..add(userModel.id);
      }
    },
    child: Container(
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
          buildRightItemContainer(context, userModel),
        ],
      ),
    ),
  );
}

Widget buildRightItemContainer(BuildContext context, UserModel userModel) {
  bool selected = false;
  if (CreateGroupControllerState.selectedUsers.value.contains(userModel.id)) {
    selected = true;
  }

  return GestureDetector(
    onTap: () {

    },
      child: Container(
      padding: EdgeInsets.all(8), // Padding for better touch area
      decoration: BoxDecoration(
        shape: BoxShape.circle, // Makes the icon button circular
        color: Colors.blue.withOpacity(0.1), // Background color with transparency
      ),
      child: Icon(
        Icons.circle,
        size: 24, // Size of the icon
        color: selected ? ShadesOfBlue.blue2 : Colors.white, // Icon color
      ),
    ),
  );
}


Widget buildSearchItemContainer(BuildContext context, UserModel userModel) {
  return TextButton(
    onPressed: () {

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

