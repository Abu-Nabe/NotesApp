import 'package:flutter/material.dart';

import '../screens/contact_screen.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => ContactsPageState();
}

class ContactsPageState extends State<ContactsPage> {
  // Any logic or state specific to Contacts Page

  @override
  Widget build(BuildContext context) {
    return build_contact_screen(context);
  }
}
