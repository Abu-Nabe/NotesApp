import 'package:package_info/package_info.dart';

// Function to get the app version and return it as a String
Future<String> getVersion() async {
  // Get package information
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  // Return the version number as a string
  return packageInfo.version;
}
