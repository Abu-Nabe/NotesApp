import 'package:aag_group_services/consts/colors.dart';
import 'package:aag_group_services/design/authentication_pages/models/user_model.dart';
import 'package:aag_group_services/design/communications/controllers/message_controller.dart';
import 'package:aag_group_services/design/communications/controllers/notes_controller.dart';
import 'package:aag_group_services/design/communications/model/messages_model.dart';
import 'package:aag_group_services/design/navigation/navigation_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../extension/time_ago.dart';
import '../../../firebase/add_friend_firebase.dart';
import '../controllers/chat.dart';
import '../controllers/contact.dart';
import '../functions/contact_functions/check_friends.dart';

Widget build_chat_screen(BuildContext context) {
  final size = MediaQuery.of(context).size;

  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Messages',
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
  TextEditingController controller = ChatPageState.searchController.value;
  return Padding(
    padding: const EdgeInsets.symmetric(
        horizontal: 16, vertical: 8), // Padding for the search bar
    child: TextField(
      controller: controller, // Controller for managing text input
      decoration: InputDecoration(
        hintText: 'Search Chats', // Placeholder text
        filled: true, // Fill the background
        fillColor: Colors.grey[200], // Background color of the search bar
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
          borderSide: BorderSide.none, // No border line
        ),
        prefixIcon: Icon(Icons.search), // Search icon
        suffixIcon: ChatPageState.searchMode.value
            ? IconButton(
                icon: Icon(Icons.clear), // Clear icon
                onPressed: () {
                  controller.clear(); // Clear the text
                  ChatPageState.searchText.value = "";
                  ChatPageState.searchMode.value = false;
                },
              )
            : null,
      ),
      onChanged: (text) {
        ChatPageState.searchText.value = text;
        if (text.toString().trim() == "") {
          ChatPageState.searchMode.value = false;
        } else {
          ChatPageState.searchMode.value = true;
        }
      },
    ),
  );
}

Widget shadowLine() {
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
  List<MessageModel> itemModel = ChatPageState.searchMode.value
      ? ChatPageState.searchList.value
      : ChatPageState.messagesList.value;

  return Expanded(
    child: GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss keyboard on tap
      },
      child: Container(
        color: ShadesOfGrey.grey1, // Background color
        child: ListView.separated(
          itemCount: itemModel.length,
          separatorBuilder: (context, index) => Divider(
              color: ShadesOfGrey.grey2, height: 1), // Divider between items
          itemBuilder: (context, index) {
            final item = itemModel[index]; // Get the user at the current index
            return buildItemContainer(
                context, item); // Display each user's name
          },
        ),
      ),
    ),
  );
}

Widget buildItemContainer(BuildContext context, MessageModel itemModel) {
  return Container(
    padding: EdgeInsets.symmetric(
        horizontal: 16, vertical: 8), // Padding around the container
    decoration: BoxDecoration(
      color: !itemModel.seen ? ShadesOfGrey.grey2 : null,
      border: Border(
        bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1), // Optional bottom border for separation
      ),
    ),
    child: Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween, // Aligns children across the row
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
                border: Border.all(
                    color: ShadesOfGrey.grey3,
                    width: 2), // Border color and width
                color: Colors.white, // Background color of the circular icon
              ),
              child: Icon(
                Icons.person,
                size: 24, // Size of the icon inside the circular container
                color: ShadesOfGrey.grey3, // Icon color
              ),
            ),
            SizedBox(width: 10), // Space between icon and name
            buildTextLabels(context, itemModel),
          ],
        ),
        SizedBox(width: 10), // Space between icon and name
        buildRightTimeAgoLabel(context, itemModel),
      ],
    ),
  );
}

Widget buildTextLabels(BuildContext context, MessageModel itemModel) {
  Map<String, bool> seenMap = ChatPageState.seenList.value;
  var seen = false;

  if (seenMap.containsKey(itemModel.id) && seenMap[itemModel.id] == true) {
    seen = true;
  }

  return Container(
    width: MediaQuery.of(context).size.width *
        0.4, // Limits width to 60% of screen width
    child: Column(
      crossAxisAlignment: CrossAxisAlignment
          .start, // Aligns children at the start of the cross-axis
      children: [
        Text(
          itemModel.name,
          style: TextStyle(
            fontSize: 16, // Font size for the name
            fontWeight: FontWeight.bold, // Bold text
            color: ShadesOfGrey.grey5,
          ),
          overflow: TextOverflow.ellipsis, // Adds ellipsis if the text overflows
          maxLines: 1, // Limits the text to a single line
        ),
        Row(
          children: [
            // Conditional rendering based on the seen variable
            seen
                ? Icon(Icons.check, // Checkmark icon
                    color: Colors.purple, // Purple color for the checkmark
                    size: 16)
                : SizedBox.shrink(),
            seen
                ? SizedBox(width: 4) // Small spacing between the icon and the text
                : SizedBox.shrink(),
            Expanded(
              child: Text(
                itemModel.message,
                style: TextStyle(
                  fontSize: 16, // Font size for the message
                  fontWeight: FontWeight.w500, // Medium text weight
                  color: ShadesOfGrey.grey4,
                ),
                overflow: TextOverflow.ellipsis, // Adds ellipsis if the text overflows
                maxLines: 1, // Limits the text to a single line
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget buildRightTimeAgoLabel(BuildContext context, MessageModel itemModel) {
  return Text(
    timeAgo(itemModel.createdAt),
    style: TextStyle(
      fontSize: 14, // Font size for the name
      fontWeight: FontWeight.w500, // Bold text
      color: ShadesOfGrey.grey4,
    ),
  );
}
