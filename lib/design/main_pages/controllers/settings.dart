import 'package:flutter/material.dart';
import '../../../firebase/sign_out.dart';
import '../../../firebase/user_info.dart';
import '../screens/settings_screen.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {

  static ValueNotifier<Map<String, String>> userInfo = ValueNotifier<Map<String, String>>({});

  @override
  void initState() {
    super.initState();
    // Initialization code here, e.g., setting up listeners or fetching data
    userInfo.addListener(updateValue);

    configUser();
  }

  Future<void> configUser() async {
    userInfo.value = await fetchUserInfo();
  }

  void updateValue(){
    setState(() {});
  }

  @override
  void dispose() {
    userInfo.removeListener(updateValue);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return build_settings_screen(context);
  }

}


