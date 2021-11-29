import 'package:boramarcarapp/models/notification.dart';

class AppUser {
  final String uid;
  final String firstName;
  final String? lastName;
  final String email;
  final String? bthDate;
  final List<String>? invited;
  final String? imageUrl;
  final List<AppNotification> notifications;
  final String? playerId;

  AppUser({
    required this.uid,
    required this.firstName,
    this.lastName,
    required this.email,
    this.imageUrl,
    this.bthDate,
    this.invited = const [],
    this.notifications = const [],
    this.playerId,
  });

  AppUser.fromJson(Map<String, Object?> json)
      : this(
          uid: json['uid']! as String,
          firstName: json['firstName']! as String,
          lastName: json['lastName'] as String?,
          email: json['email']! as String,
          bthDate: json['bthDate'] as String?,
          invited: (json['invited'] as List<dynamic>?)?.cast<String>(),
          imageUrl: json['imageUrl'] as String?,
          notifications: (json['notifications'] as List)
              .map((e) => AppNotification.fromJson(e))
              .toList(),
          playerId: json['playerId'] as String?,
        );

  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'bthDate': bthDate,
      'invited': invited,
      'imageUrl': imageUrl,
      'notifications': notifications,
      'playerId': playerId,
    };
  }
}
