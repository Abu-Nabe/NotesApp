import 'package:aag_group_services/design/main_pages/controllers/Basic.dart';
import 'package:aag_group_services/design/splashscreen/splashscreen_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'firebase/authenticated_state.dart';
import 'firebase/firebase_options.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter is initialized
//
//   await dotenv.load(fileName: ".env");
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform, // Initialize Firebase
//   );
//
//   runApp(const MyApp());
// }

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    // Log the error details
    print(details.exceptionAsString());
  };
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

