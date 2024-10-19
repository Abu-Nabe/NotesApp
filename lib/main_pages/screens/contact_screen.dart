import 'package:aag_group_services/consts/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          listContainer(),
        ],
      ),
    ),
  );
}

Widget searchField(){
  return  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding for the search bar
    child: TextField(
      decoration: InputDecoration(
        hintText: 'Search Contacts', // Placeholder text
        filled: true, // Fill the background
        fillColor: Colors.grey[200], // Background color of the search bar
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
          borderSide: BorderSide.none, // No border line
        ),
        prefixIcon: Icon(Icons.search), // Search icon
      ),
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

Widget listContainer() {
  return Expanded(
    child: Container(
      decoration: BoxDecoration(
        color: ShadesOfGrey.grey1, // Background color
      ),
      child: ListView(
        children: [
          buildItemContainer("Abu"),
          Divider(color: ShadesOfGrey.grey1, height: 1), // Divider indicating next item
          buildItemContainer("Sara"),
          Divider(color: ShadesOfGrey.grey1, height: 1),
          buildItemContainer("Ali"),
          Divider(color: ShadesOfGrey.grey1, height: 1),
          // Add more items as needed
        ],
      ),
    ),
  );
}


Widget buildItemContainer(String name) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Add some padding around the container
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
                fontSize: 18, // Font size for the name
                fontWeight: FontWeight.bold, // Bold text
                color: ShadesOfGrey.grey5,
              ),
            ),
          ],
        ),
        // Invite button
        TextButton(
          onPressed: () {
            // Handle invite action here
          },
          child: Text(
            'Invite',
            style: TextStyle(
              color: Colors.blue, // Text color (customize as needed)
              fontSize: 16, // Font size (customize as needed)
            ),
          ),
        ),
      ],
    ),
  );
}


