import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

Future<bool> checkGalleryPermission() async {
  Permission permission;

  // Determine the correct permission based on the platform
  if (Platform.isAndroid) {
    permission = Permission.storage; // For accessing storage on Android
  } else if (Platform.isIOS) {
    permission = Permission.photos; // For accessing the photo library on iOS
  } else {
    return false; // Unsupported platform
  }

  // Check the current status of permission
  var permissionStatus = await permission.status;

  // Request permission if it’s not granted
  if (permissionStatus.isDenied || permissionStatus.isRestricted) {
    permissionStatus = await permission.request();
  }

  // Return true if permission is granted, otherwise false
  return permissionStatus.isGranted;
}
