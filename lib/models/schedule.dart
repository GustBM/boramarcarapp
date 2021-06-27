import 'package:flutter/material.dart';

class Schedule with ChangeNotifier {
  final String userId;
  final int sundayIni;
  final int sundayEnd;
  final int mondayIni;
  final int mondayEnd;
  final int tuesdayIni;
  final int tuesdayEnd;
  final int wednesdayIni;
  final int wednesdayEnd;
  final int thursdayIni;
  final int thursdayEnd;
  final int fridayIni;
  final int fridayEnd;
  final int saturdayIni;
  final int saturdayEnd;

  Schedule({
    required this.userId,
    required this.sundayIni,
    required this.sundayEnd,
    required this.mondayIni,
    required this.mondayEnd,
    required this.tuesdayIni,
    required this.tuesdayEnd,
    required this.wednesdayIni,
    required this.wednesdayEnd,
    required this.thursdayIni,
    required this.thursdayEnd,
    required this.fridayIni,
    required this.fridayEnd,
    required this.saturdayIni,
    required this.saturdayEnd,
  });
}
