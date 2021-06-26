import 'package:flutter/material.dart';

class Schedule with ChangeNotifier {
  final int userId;
  final DateTimeRange schedule;

  Schedule({
    required this.userId,
    required this.schedule,
  });
}
