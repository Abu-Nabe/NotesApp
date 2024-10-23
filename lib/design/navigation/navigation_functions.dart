import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void pushWithoutAnimation(BuildContext context, Widget page) {
  Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: Duration.zero, // Disable transition animation
      reverseTransitionDuration: Duration.zero, // Disable reverse animation
    ),
  );
}

void pushReplacementWithoutAnimation(BuildContext context, Widget page) {
  Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: Duration.zero, // Disable transition animation
      reverseTransitionDuration: Duration.zero, // Disable reverse animation
    ),
  );
}
