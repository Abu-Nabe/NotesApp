String timeAgo(String timestamp) {
  final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
  final Duration difference = DateTime.now().difference(dateTime);

  if (difference.inDays > 365) {
    int years = (difference.inDays / 365).floor();
    return "$years year${years == 1 ? '' : 's'} ago";
  } else if (difference.inDays > 30) {
    int months = (difference.inDays / 30).floor();
    return "$months month${months == 1 ? '' : 's'} ago";
  } else if (difference.inDays >= 7) {
    int weeks = (difference.inDays / 7).floor();
    return "$weeks week${weeks == 1 ? '' : 's'} ago";
  } else if (difference.inDays >= 1) {
    return "${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago";
  } else if (difference.inHours >= 1) {
    return "${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago";
  } else if (difference.inMinutes >= 1) {
    return "${difference.inMinutes} min${difference.inMinutes == 1 ? '' : 's'} ago";
  } else if (difference.inSeconds >= 5) {
    return "${difference.inSeconds} seconds ago";
  } else {
    return "just now";
  }
}
