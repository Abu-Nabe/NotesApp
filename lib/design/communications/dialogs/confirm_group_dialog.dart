import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../consts/colors.dart';
import '../functions/create_group_firebase.dart';

class ConfirmGroupDialog extends StatefulWidget {
  const ConfirmGroupDialog({
    Key? key,
  }) : super(key: key);

  @override
  ConfirmGroupDialogState createState() => ConfirmGroupDialogState();
}

class ConfirmGroupDialogState extends State<ConfirmGroupDialog> {
  TextEditingController groupNameController = TextEditingController();
  static ValueNotifier<String> searchText = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();

    groupNameController.addListener(updateValue);
  }

  void updateValue(){
    setState(() {});
  }

  @override
  void dispose() {
    searchText.value = "";
    searchText.removeListener(updateValue);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Unfocus any active text field when tapping outside
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent, // Make the scaffold background transparent
        body: Stack(
          children: <Widget>[
            // Blurred background
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
                  constraints: BoxConstraints.expand(),
                ),
              ),
            ),
            // Dialog content
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                padding: const EdgeInsets.all(24), // Reduced padding to avoid too much space
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // To avoid the column expanding unnecessarily
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Confirm Group Creation',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20), // Spacing between title and content
                    TextField(
                      controller: groupNameController, // Controller for managing text input
                      decoration: InputDecoration(
                        hintText: 'Enter Group Name', // Placeholder text
                        filled: true, // Fill the background
                        fillColor: Colors.grey[200], // Background color of the search bar
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15), // Rounded corners
                          borderSide: BorderSide.none, // No border line
                        ),
                      ),
                      onChanged: (text) {
                        ConfirmGroupDialogState.searchText.value = text;
                      },
                    ),
                    SizedBox(height: 20), // Spacing for the button
                    buildRowButtons(context, ConfirmGroupDialogState.searchText.value),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildRowButtons(BuildContext context, String groupName){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween, // To place buttons at the ends
    children: [
      // Cancel Button
      TextButton(
        onPressed: () {
          // Dismiss the dialog without any action
          Navigator.of(context).pop(false);
        },
        child: Text(
          'Cancel',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // Confirm Button
      TextButton(
        onPressed: () {
          if(groupName.trim().isEmpty) return;
          createGroupFirebase(groupName);
          Navigator.of(context).pop(true);
        },
        child: Text(
          'Confirm',
          style: TextStyle(
            color: !groupName.trim().isEmpty ? Colors.blue : ShadesOfGrey.grey2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}