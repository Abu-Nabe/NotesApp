import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget toolbar_shadow_line(BuildContext context){
  return SizedBox(
    width: MediaQuery.sizeOf(context).width,
    height: 1,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[300], // Light grey color for the line
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color with opacity
            spreadRadius: 0,
            blurRadius: 4, // Amount of blur
            offset: Offset(0, 2), // Offset for shadow position
          ),
        ],
      ),
    ),
  );
}