import 'package:aag_group_services/authentication_pages/screens/login_screen.dart';
import 'package:aag_group_services/authentication_pages/screens/register_screen.dart';
import 'package:aag_group_services/firebase/initialize_ref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class LoginController extends StatefulWidget {
  const LoginController({super.key});

  @override
  State<LoginController> createState() => LoginControllerState();
}

class LoginControllerState extends State<LoginController> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  static ValueNotifier<bool> loginToggled = ValueNotifier<bool>(false);
  static ValueNotifier<Map<String, dynamic>> authenticationMap = ValueNotifier<Map<String, dynamic>>({});
  static ValueNotifier<int> screenUpdate = ValueNotifier<int>(1);

  Future<void> addData() async {
    FirebaseDatabase.instance
        .ref()
        .child('users/email')  // Use .child() instead of .ref()
    .push()
        .set({
      "name": "John",
      "age": 18,
      "address": {
        "line1": "100 Mountain View"
      }
    })
        .then((_) {
      // Data saved successfully!
      print("Data saved successfully.");
    })
        .catchError((error) {
      // The write failed...
      print("Error updating data: ${error.toString()}");
    });
  }





  @override
  void initState() {
    super.initState();
    loginToggled.addListener(updateValue);
    authenticationMap.addListener(updateValue);
    screenUpdate.addListener(updateValue);

    addData();
  }

  void updateValue(){
    setState(() {

    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree
    loginToggled.removeListener(updateValue);
    authenticationMap.removeListener(updateValue);
    screenUpdate.removeListener(updateValue);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (screenUpdate.value) {
      case 1:
        return build_login_screen(context, auth);
      case 2:
        return build_register_screen(context, auth);
      default:
        return build_login_screen(context, auth);
    }
  }
}
