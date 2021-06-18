import 'package:flutter/material.dart';

class Event with ChangeNotifier {
  final String eventId;
  final String name;
  final String manager;
  final String managerId;
  final DateTime date;
  final String location;
  final String imageUrl;
  final String description;

  Event({
    required this.eventId,
    required this.name,
    required this.manager,
    required this.managerId,
    required this.date,
    required this.location,
    required this.description,
    this.imageUrl = '',
  });
}
