import 'package:aag_group_services/design/communications/controllers/message_controller.dart';
import 'package:aag_group_services/design/communications/functions/add_message_firebase.dart';
import 'package:aag_group_services/design/communications/model/messages_model.dart';
import 'package:aag_group_services/design/main_pages/controllers/chat.dart';
import 'package:flutter/cupertino.dart';

import 'package:aag_group_services/consts/colors.dart';
import 'package:aag_group_services/design/authentication_pages/models/user_model.dart';
import 'package:aag_group_services/design/communications/model/notes_model.dart';
import 'package:aag_group_services/firebase/currentUserId.dart';
import 'package:flutter/material.dart';

import '../../../extension/time_ago.dart';
import '../../../firebase/user_info.dart';
import '../../const/reusable_layouts/toolbar_shadow_line.dart';

Widget build_group_message_screen(BuildContext context, MessageModel messageModel) {
  final size = MediaQuery.of(context).size;

  return Scaffold(
    body: GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        width: size.width, // Full width
        height: size.height, // Full height
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Pushes the TextField to the bottom
          children: [
            buildToolbar(context, messageModel.name),
            toolbar_shadow_line(context),
            buildNoteList(context),
            buildTextField(context, getCurrentUserID(), messageModel.id, messageModel.name),
          ],
        ),
      ),
    ),
  );
}

Widget buildToolbar(BuildContext context, String name) {
  return AppBar(
    leading: IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.black), // Back arrow icon
      onPressed: () {
        MessageControllerState.messagesList.value = [];
        Navigator.pop(context); // Navigates back to the previous screen
      },
    ),
    title: Text(
      "${name}", // Title of the toolbar with string interpolation
      style: TextStyle(
        color: Colors.black, // Title text color
        fontWeight: FontWeight.bold, // Bold text
        fontSize: 16, // Font size of the title
      ),
      overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
      maxLines: 1, // Restrict to a single line
    ),
    backgroundColor: Colors.white, // Background color of the toolbar (customize as needed)
    elevation: 4, // Shadow effect under the AppBar
  );
}

Widget buildNoteList(BuildContext context) {
  List<MessageModel> notes = MessageControllerState.messagesList.value;
  Map<String, String> userInfo = MessageControllerState.userInfo.value;

  return Expanded(
    child: Container(
      color: ShadesOfGrey.grey2,
      child: ListView.builder(
        reverse: true, // Ensures the list aligns from the bottom like a chat view
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding around the list
        itemCount: notes.length,
        itemBuilder: (context, index) {
          // Mini texts displayed as individual notes
          if (userInfo["username"] == notes[index].name) {
            // If it matches, return the right container
            return buildMessageRightContainer(context, notes[index]);
          } else {
            // If it doesn't match, return the left container
            return buildMessageLeftContainer(context, notes[index]);
          }
        },
      ),
    ),
  );
}

Widget buildMessageLeftContainer(BuildContext context, MessageModel note) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4), // Space between each note
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // Position of shadow
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align texts to the start
              children: [
                Text(
                  note.message, // First text: the note itself
                  style: TextStyle(
                    fontSize: 14, // Mini text size
                    color: Colors.black,
                    fontWeight: FontWeight.bold, // Makes the note bold
                  ),
                ),
                SizedBox(height: 4), // Add some space between the note and the sender
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      note.name, // Second text: the sender
                      style: TextStyle(
                        fontSize: 12, // Smaller text size for the sender
                        color: Colors.grey[700], // A lighter color for the sender
                      ),
                      overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
                      maxLines: 1, // Restrict to a single line
                    ),
                    SizedBox(width: 10),
                    Text(
                      timeAgo(note.createdAt.toString()), // Timestamp
                      style: TextStyle(
                        fontSize: 12, // Smaller text size for the sender
                        color: Colors.grey[700], // A lighter color for the sender
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.1), // Padding of 50 on the right side
      ],
    ),
  );
}

Widget buildMessageRightContainer(BuildContext context, MessageModel note) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4), // Space between each note
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: MediaQuery.of(context).size.width * 0.1), // Padding of 50 on the left side
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ShadesOfPurple.purple_iris,
              borderRadius: BorderRadius.circular(8), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // Position of shadow
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align texts to the start
              children: [
                Text(
                  note.message, // First text: the note itself
                  style: TextStyle(
                    fontSize: 14, // Mini text size
                    color: Colors.white,
                    fontWeight: FontWeight.bold, // Makes the note bold
                  ),
                ),
                SizedBox(height: 4), // Add some space between the note and the sender
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      note.name, // Second text: the sender
                      style: TextStyle(
                        fontSize: 12, // Smaller text size for the sender
                        color: ShadesOfGrey.grey2, // A lighter color for the sender
                      ),
                      overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
                      maxLines: 1, // Restrict to a single line
                    ),
                    SizedBox(width: 10),
                    Text(
                      timeAgo(note.createdAt.toString()), // Timestamp
                      style: TextStyle(
                        fontSize: 12, // Smaller text size for the sender
                        color: ShadesOfGrey.grey2, // A lighter color for the sender
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildTextField(BuildContext context, String sender, String receiver, String receiverName) {
  return Container(
    padding: EdgeInsets.all(16),
    color: Colors.white, // Background for the TextField container
    child: TextField(
      controller: MessageControllerState.noteController.value,
      decoration: InputDecoration(
        hintText: 'Send a message',
        contentPadding: EdgeInsets.only(left: 16), // Adjust left padding
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ShadesOfPurple.purple_iris),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ShadesOfWhite.white3, width: 2), // Solid grey border
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.send),
          color: ShadesOfPurple.purple_iris, // Set icon color
          onPressed: () async {
            Map<String, String> userInfo = await fetchUserInfo();

            // Handle send action
            String message = MessageControllerState.noteController.value.text;
            addSenderMessageToDB(sender, receiver, message, userInfo['username'].toString());
            addReceiverMessageToDB(sender, receiver, message, userInfo['username'].toString());

            addToMessageList(sender, receiver, message, userInfo['username'].toString(), receiverName);
            addToFriendMessageList(sender, receiver, message, userInfo['username'].toString(), receiverName);

            MessageControllerState.noteController.value.clear();
          },
        ),
      ),
    ),
  );
}
