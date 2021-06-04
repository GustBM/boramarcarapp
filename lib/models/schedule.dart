import 'package:flutter/material.dart';

class Schedule {
  final int userId;
  final List<DateTimeRange> schedule;

  Schedule({
    @required this.userId,
    @required this.schedule,
  });
}
