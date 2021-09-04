import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Event with ChangeNotifier {
  final String eventId;
  final String name;
  final String manager;
  final String managerId;
  final DateTime date;
  final DateTime dateIni;
  final DateTime dateEnd;
  final String location;
  final String? imageUrl;
  final String description;
  final List<String> invited;

  Event({
    required this.eventId,
    required this.name,
    required this.manager,
    required this.managerId,
    required this.date,
    required this.dateIni,
    required this.dateEnd,
    required this.location,
    required this.description,
    this.invited = const [],
    this.imageUrl = '',
  });

  Event.fromJson(Map<String, Object?> json)
      : this(
          eventId: json['eventId']! as String,
          name: json['name']! as String,
          manager: json['manager']! as String,
          managerId: json['managerId']! as String,
          date: (json['date']! as Timestamp).toDate(),
          dateIni: (json['dateIni']! as Timestamp).toDate(),
          dateEnd: (json['dateEnd']! as Timestamp).toDate(),
          location: json['location']! as String,
          description: json['description']! as String,
          invited: (json['invited'] as List<dynamic>).cast<String>(),
          imageUrl: json['imageUrl']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'eventId': eventId,
      'name': name,
      'manager': manager,
      'managerId': managerId,
      'date': date,
      'dateIni': dateIni,
      'dateEnd': dateEnd,
      'location': location,
      'description': description,
      'invited': invited,
      'imageUrl': imageUrl,
    };
  }
}
