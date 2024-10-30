import 'package:aag_group_services/consts/colors.dart';
import 'package:aag_group_services/design/authentication_pages/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../const/reusable_layouts/toolbar_shadow_line.dart';

Widget build_notes_screen(BuildContext context, UserModel receiverModel) {
  final size = MediaQuery.of(context).size;

  final List<String> notes = [
    "First note",
    "Second note",
    "Third note",
    "This is a longer note to test the layout of the text in the chat view.",
  ];

  final List<String> from = [
    "Abu Nabe",
    "Test Account",
    "Abu Nabe",
    "Test Account",
  ];

  return Scaffold(
    body: Container(
      width: size.width, // Full width
      height: size.height, // Full height
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Pushes the TextField to the bottom
        children: [
          buildToolbar(context, receiverModel.name),
          toolbar_shadow_line(context),
          buildNoteList(context, notes, from),
          buildTextField(context),
        ],
      ),
    ),
  );
}

Widget buildToolbar(BuildContext context, String name) {
  return AppBar(
    leading: IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.black), // Back arrow icon
      onPressed: () {
        Navigator.pop(context); // Navigates back to the previous screen
      },
    ),
    title: Text(
      "${name}'s Notes", // Title of the toolbar with string interpolation
      style: TextStyle(
        color: Colors.black, // Title text color
        fontWeight: FontWeight.bold, // Bold text
        fontSize: 20, // Font size of the title
      ),
    ),
    backgroundColor: Colors.white, // Background color of the toolbar (customize as needed)
    elevation: 4, // Shadow effect under the AppBar
  );
}

Widget buildNoteList(BuildContext context, List<String> notes, List<String> from) {
  return Expanded(
    child: Container(
      color: ShadesOfGrey.grey2,
      child: ListView.builder(
        reverse: true, // Ensures the list aligns from the bottom like a chat view
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding around the list
        itemCount: notes.length,
        itemBuilder: (context, index) {
          // Mini texts displayed as individual notes
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4), // Space between each note
            child: Align(
              alignment: Alignment.centerLeft, // Align notes to the left
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
                      notes[index], // First text: the note itself
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
                          'From: ${from[index]}', // Second text: the sender
                          style: TextStyle(
                            fontSize: 12, // Smaller text size for the sender
                            color: Colors.grey[700], // A lighter color for the sender
                          ),
                          overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
                          maxLines: 1, // Restrict to a single line
                        ),
                        SizedBox(width: 10),
                        Text(
                          '${from[index]}', // Second text: the sender
                          style: TextStyle(
                            fontSize: 12, // Smaller text size for the sender
                            color: Colors.grey[700], // A lighter color for the sender
                          ),
                        ),
                      ]
                    )

                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}

Widget buildTextField(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(16),
    color: Colors.white, // Background for the TextField container
    child: TextField(
      decoration: InputDecoration(
        hintText: 'Write a note...',
        border: OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(Icons.send),
          onPressed: () {
            // Handle send action
          },
        ),
      ),
    ),
  );
}