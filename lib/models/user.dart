import 'package:boramarcarapp/models/notification.dart';

class AppUser {
  final String firstName;
  final String? lastName;
  final String email;
  final String? bthDate;
  final List<String> invited;
  final List<Notification> notifications;

  AppUser({
    required this.firstName,
    this.lastName,
    required this.email,
    this.bthDate,
    this.invited = const [],
    this.notifications = const [],
  });

  AppUser.fromJson(Map<String, Object?> json)
      : this(
          firstName: json['firstName']! as String,
          lastName: json['lastName'] as String?,
          email: json['email']! as String,
          bthDate: json['bthDate'] as String?,
          invited: (json['invited']! as List<dynamic>).cast<String>(),
          notifications:
              (json['notifications']! as List<dynamic>).cast<Notification>(),
        );

  Map<String, Object?> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'bthDate': bthDate,
      'invited': invited,
      'notifications': notifications,
    };
  }
}
