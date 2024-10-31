import 'package:intl/intl.dart';

String formatDateTime(String dateTimeString) {
  // Parse the original date string into a DateTime object
  DateTime dateTime = DateTime.parse(dateTimeString);

  // Format date as "dd/MM/yyyy"
  String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

  // Format time as "h:mm a" (e.g., 9:06 PM)
  String formattedTime = DateFormat('h:mm a').format(dateTime);

  return '$formattedDate at $formattedTime';
}
