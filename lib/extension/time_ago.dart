String timeAgo(DateTime dateTime) {
  final Duration difference = DateTime.now().difference(dateTime);

  if (difference.inDays > 8) {
    return "${dateTime.year}-${dateTime.month}-${dateTime.day}";
  } else if (difference.inDays >= 1) {
    return "${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago";
  } else if (difference.inHours >= 1) {
    return "${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago";
  } else if (difference.inMinutes >= 1) {
    return "${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago";
  } else if (difference.inSeconds >= 5) {
    return "${difference.inSeconds} seconds ago";
  } else {
    return "just now";
  }
}
