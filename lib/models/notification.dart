import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  final String message;
  final DateTime date;
  final String redirectUrl;
  final bool hasSeen;
  final bool hasResponded;

  Notification({
    required this.message,
    required this.date,
    required this.redirectUrl,
    this.hasSeen = false,
    this.hasResponded = false,
  });

  Notification.fromJson(Map<String, Object?> json)
      : this(
          message: json['message']! as String,
          date: (json['date']! as Timestamp).toDate(),
          redirectUrl: json['redirectUrl']! as String,
          hasSeen: json['hasSeen']! as bool,
          hasResponded: json['hasResponded']! as bool,
        );

  Map<String, Object?> toJson() {
    return {
      'message': message,
      'date': date,
      'redirectUrl': redirectUrl,
      'hasSeen': hasSeen,
      'hasResponded': hasResponded,
    };
  }
}
