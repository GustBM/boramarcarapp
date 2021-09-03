import 'package:flutter/material.dart';

class Schedule with ChangeNotifier {
  final int sundayIni;
  final int sundayEnd;
  final bool sundayCheck;
  final int mondayIni;
  final int mondayEnd;
  final bool mondayCheck;
  final int tuesdayIni;
  final int tuesdayEnd;
  final bool tuesdayCheck;
  final int wednesdayIni;
  final int wednesdayEnd;
  final bool wednesdayCheck;
  final int thursdayIni;
  final int thursdayEnd;
  final bool thursdayCheck;
  final int fridayIni;
  final int fridayEnd;
  final bool fridayCheck;
  final int saturdayIni;
  final int saturdayEnd;
  final bool saturdayCheck;

  Schedule({
    required this.sundayIni,
    required this.sundayEnd,
    this.sundayCheck = true,
    required this.mondayIni,
    required this.mondayEnd,
    this.mondayCheck = true,
    required this.tuesdayIni,
    required this.tuesdayEnd,
    this.tuesdayCheck = true,
    required this.wednesdayIni,
    required this.wednesdayEnd,
    this.wednesdayCheck = true,
    required this.thursdayIni,
    required this.thursdayEnd,
    this.thursdayCheck = true,
    required this.fridayIni,
    required this.fridayEnd,
    this.fridayCheck = true,
    required this.saturdayIni,
    required this.saturdayEnd,
    this.saturdayCheck = true,
  });

  Schedule.fromJson(Map<String, Object?> json)
      : this(
          sundayIni: json['sundayIni']! as int,
          sundayEnd: json['sundayEnd']! as int,
          sundayCheck: json['sundayCheck']! as bool,
          mondayIni: json['mondayIni']! as int,
          mondayEnd: json['mondayEnd']! as int,
          mondayCheck: json['mondayCheck']! as bool,
          tuesdayIni: json['tuesdayIni']! as int,
          tuesdayEnd: json['tuesdayEnd']! as int,
          tuesdayCheck: json['tuesdayCheck']! as bool,
          wednesdayIni: json['wednesdayIni']! as int,
          wednesdayEnd: json['wednesdayEnd']! as int,
          wednesdayCheck: json['wednesdayCheck']! as bool,
          thursdayIni: json['thursdayIni']! as int,
          thursdayEnd: json['thursdayEnd']! as int,
          thursdayCheck: json['thursdayCheck']! as bool,
          fridayIni: json['fridayIni']! as int,
          fridayEnd: json['fridayEnd']! as int,
          fridayCheck: json['fridayCheck']! as bool,
          saturdayIni: json['saturdayIni']! as int,
          saturdayEnd: json['saturdayEnd']! as int,
          saturdayCheck: json['saturdayCheck']! as bool,
        );

  Map<String, Object?> toJson() {
    return {
      'sundayIni': sundayIni,
      'sundayEnd': sundayEnd,
      'sundayCheck': sundayCheck,
      'mondayIni': mondayIni,
      'mondayEnd': mondayEnd,
      'mondayCheck': mondayCheck,
      'tuesdayIni': tuesdayIni,
      'tuesdayEnd': tuesdayEnd,
      'tuesdayCheck': tuesdayCheck,
      'wednesdayIni': wednesdayIni,
      'wednesdayEnd': wednesdayEnd,
      'wednesdayCheck': wednesdayCheck,
      'thursdayIni': thursdayIni,
      'thursdayEnd': thursdayEnd,
      'thursdayCheck': thursdayCheck,
      'fridayIni': fridayIni,
      'fridayEnd': fridayEnd,
      'fridayCheck': fridayCheck,
      'saturdayIni': saturdayIni,
      'saturdayEnd': saturdayEnd,
      'saturdayCheck': saturdayCheck,
    };
  }
}
