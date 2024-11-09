import 'dart:math';

String generateUniqueId() {
  var now = DateTime.now().millisecondsSinceEpoch; // Get the current timestamp in milliseconds
  var random = Random();
  var randomValue = random.nextInt(100000); // Generate a random value

  return '$now$randomValue'; // Combine timestamp and random value for uniqueness
}