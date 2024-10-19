import 'package:flutter/material.dart';
import '../screens/settings_screen.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  // Any logic or state specific to Contacts Page

  @override
  Widget build(BuildContext context) {
    return build_settings_screen(context);
  }
}
