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
}
