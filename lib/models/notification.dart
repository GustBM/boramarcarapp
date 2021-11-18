import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType {
  notify,
  invite,
}

class AppNotification {
  final String message;
  final DateTime date;
  final String redirectUrl;
  final bool hasSeen;
  final bool hasResponded;
  final NotificationType notificationType;

  AppNotification({
    required this.message,
    required this.date,
    required this.redirectUrl,
    this.hasSeen = false,
    this.hasResponded = false,
    this.notificationType = NotificationType.notify,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      AppNotification(
        message: json['message']! as String,
        date: (json['date']! as Timestamp).toDate(),
        redirectUrl: json['redirectUrl']! as String,
        hasSeen: json['hasSeen']! as bool,
        hasResponded: json['hasResponded']! as bool,
        notificationType:
            NotificationType.values.elementAt(json['notificationType']!),
      );

  Map<String, Object?> toJson() {
    return {
      'message': message,
      'date': date,
      'redirectUrl': redirectUrl,
      'hasSeen': hasSeen,
      'hasResponded': hasResponded,
      'notificationType': notificationType.index,
    };
  }
}
