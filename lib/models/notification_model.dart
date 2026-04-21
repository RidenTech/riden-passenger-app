class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String icon; // icon type: payment, discount, wallet, etc.
  final DateTime timestamp;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.icon,
    required this.timestamp,
    this.isRead = false,
  });

  // Helper method to check if notification is from today
  bool get isToday {
    final now = DateTime.now();
    return timestamp.year == now.year &&
        timestamp.month == now.month &&
        timestamp.day == now.day;
  }

  // Helper method to check if notification is from yesterday or earlier
  bool get isPreviousDay {
    return !isToday;
  }

  // Format time for display
  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return "just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}h ago";
    } else if (difference.inDays == 1) {
      return "yesterday";
    } else {
      return "${timestamp.month}/${timestamp.day}";
    }
  }
}
