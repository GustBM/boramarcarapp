import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:boramarcarapp/models/http_exception.dart';
import 'package:boramarcarapp/models/schedule.dart';

class ScheduleController extends ChangeNotifier {
  CollectionReference _schedules =
      FirebaseFirestore.instance.collection('schedule');

  Future<DocumentSnapshot<Schedule>> getUserSchedule(String userId,
      {String scheduleType = ''}) {
    return _schedules
        .doc(scheduleType + userId)
        .withConverter<Schedule>(
            fromFirestore: (snapshot, _) => Schedule.fromJson(snapshot.data()!),
            toFirestore: (schedule, _) => schedule.toJson())
        .get();
  }

  Future<void> addSchedule(String userId, Schedule schedule,
      {String scheduleType = ''}) async {
    _checkSchedule(schedule);
    _schedules.doc(scheduleType + userId).set({
      'sundayIni': schedule.sundayIni,
      'sundayEnd': schedule.sundayEnd,
      'sundayCheck': schedule.sundayCheck,
      'mondayIni': schedule.mondayIni,
      'mondayEnd': schedule.mondayEnd,
      'mondayCheck': schedule.mondayCheck,
      'tuesdayIni': schedule.tuesdayIni,
      'tuesdayEnd': schedule.tuesdayEnd,
      'tuesdayCheck': schedule.tuesdayCheck,
      'wednesdayIni': schedule.wednesdayIni,
      'wednesdayEnd': schedule.wednesdayEnd,
      'wednesdayCheck': schedule.wednesdayCheck,
      'thursdayIni': schedule.thursdayIni,
      'thursdayEnd': schedule.thursdayEnd,
      'thursdayCheck': schedule.thursdayCheck,
      'fridayIni': schedule.fridayIni,
      'fridayEnd': schedule.fridayEnd,
      'fridayCheck': schedule.fridayCheck,
      'saturdayIni': schedule.saturdayIni,
      'saturdayEnd': schedule.saturdayEnd,
      'saturdayCheck': schedule.saturdayCheck,
    }).catchError((error) => throw HttpException(
        "Erro ao enviar novo Horário. Tente novamente mais tarde."));
  }

  void _checkSchedule(Schedule sch) {
    if ((sch.sundayIni >= sch.sundayEnd && sch.sundayCheck) ||
        (sch.mondayIni >= sch.mondayEnd && sch.mondayCheck) ||
        (sch.tuesdayIni >= sch.tuesdayEnd && sch.tuesdayCheck) ||
        (sch.wednesdayIni >= sch.wednesdayEnd && sch.wednesdayCheck) ||
        (sch.thursdayIni >= sch.thursdayEnd && sch.thursdayCheck) ||
        (sch.fridayIni >= sch.fridayEnd && sch.fridayCheck) ||
        (sch.saturdayIni >= sch.saturdayEnd && sch.saturdayCheck))
      throw HttpException(
          "O horário final não pode ser maior ou igual ao horário inicial.");
  }

  static Future<void> addNewUserSchedule(String userId) async {
    FirebaseFirestore.instance.collection('schedule').doc(userId).set({
      'sundayIni': 6,
      'sundayEnd': 18,
      'sundayCheck': false,
      'mondayIni': 6,
      'mondayEnd': 18,
      'mondayCheck': true,
      'tuesdayIni': 6,
      'tuesdayEnd': 18,
      'tuesdayCheck': true,
      'wednesdayIni': 6,
      'wednesdayEnd': 18,
      'wednesdayCheck': true,
      'thursdayIni': 6,
      'thursdayEnd': 18,
      'thursdayCheck': true,
      'fridayIni': 6,
      'fridayEnd': 18,
      'fridayCheck': true,
      'saturdayIni': 6,
      'saturdayEnd': 18,
      'saturdayCheck': false,
    });

    FirebaseFirestore.instance.collection('schedule').doc('L' + userId).set({
      'sundayIni': 6,
      'sundayEnd': 18,
      'sundayCheck': true,
      'mondayIni': 6,
      'mondayEnd': 18,
      'mondayCheck': false,
      'tuesdayIni': 6,
      'tuesdayEnd': 18,
      'tuesdayCheck': false,
      'wednesdayIni': 6,
      'wednesdayEnd': 18,
      'wednesdayCheck': false,
      'thursdayIni': 6,
      'thursdayEnd': 18,
      'thursdayCheck': false,
      'fridayIni': 6,
      'fridayEnd': 18,
      'fridayCheck': false,
      'saturdayIni': 6,
      'saturdayEnd': 18,
      'saturdayCheck': true,
    });
  }

  static List<int> get _iniList =>
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

  /// Retorna um `int` com o valor da posição com o maior valor do array [arr]
  static int _indexOfMax(List<int> arr) {
    var max = arr[0];
    var maxIndex = 0;

    for (var i = 1; i < arr.length; i++) {
      if (arr[i] > max) {
        maxIndex = i;
        max = arr[i];
      }
    }

    return maxIndex;
  }

  static List<DateTime> _calculateDaysInterval(DateTimeRange dateTimeRange) {
    DateTime startDate = dateTimeRange.start;
    DateTime endDate = dateTimeRange.end;
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  static Future<List<DateTime>> getIdealDate(
      DateTimeRange dateTimeRange, List<String> usersId) async {
    List<DateTime> avaliableDaysList = [];
    List<DateTime> bestDates = [];
    List<Schedule> listSch = [];

    List<List<int>> allDaysOffWeek = [
      _iniList,
      _iniList,
      _iniList,
      _iniList,
      _iniList,
      _iniList,
      _iniList,
    ];

    List<int> dayScore = [0, 0, 0, 0, 0, 0, 0];
    List<int> bestHours = [0, 0, 0, 0, 0, 0, 0];

    await Future.forEach(usersId, (uid) async {
      Schedule sch = await _returnUserSchedule(uid as String);
      listSch.add(sch);
    }).then((_) {
      listSch.forEach((sch) {
        // Domingo
        if (sch.sundayCheck) {
          for (var i = sch.saturdayIni; i <= sch.sundayEnd; i++) {
            allDaysOffWeek[0][i]++;
          }
        }
        // Segunda
        if (sch.mondayCheck) {
          for (var i = sch.mondayIni; i <= sch.mondayEnd; i++) {
            allDaysOffWeek[1][i]++;
          }
        }
        // Terça
        if (sch.tuesdayCheck) {
          for (var i = sch.tuesdayIni; i <= sch.tuesdayEnd; i++) {
            allDaysOffWeek[2][i]++;
          }
        }
        // Quarta
        if (sch.wednesdayCheck) {
          for (var i = sch.wednesdayIni; i <= sch.wednesdayEnd; i++) {
            allDaysOffWeek[3][i]++;
          }
        }
        // Quinta
        if (sch.thursdayCheck) {
          for (var i = sch.thursdayIni; i <= sch.thursdayEnd; i++) {
            allDaysOffWeek[4][i]++;
          }
        }
        // Sexta
        if (sch.fridayCheck) {
          for (var i = sch.fridayIni; i <= sch.fridayEnd; i++) {
            allDaysOffWeek[5][i]++;
          }
        }
        // Sábado
        if (sch.saturdayCheck) {
          for (var i = sch.saturdayIni; i <= sch.saturdayEnd; i++) {
            allDaysOffWeek[6][i]++;
          }
        }
      });
    });

    for (var i = 0; i < 7; i++) bestHours[i] = _indexOfMax(allDaysOffWeek[i]);

    for (var i = 0; i < 7; i++) dayScore[i] = allDaysOffWeek[i].reduce(max);

    int greatestDayScore = dayScore.reduce(max);

    avaliableDaysList = _calculateDaysInterval(dateTimeRange);
    avaliableDaysList.forEach((day) {
      var tmpDay = day.weekday;
      if (day.weekday == 7) tmpDay = 0;
      if (dayScore[tmpDay] == greatestDayScore) {
        DateTime bestDate =
            new DateTime(day.year, day.month, day.day, bestHours[tmpDay]);
        bestDates.add(bestDate);
      }
    });

    if (bestDates.isEmpty) bestDates.add(dateTimeRange.start);

    return bestDates;
  }

  static Future<Schedule> _returnUserSchedule(String userId) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('schedule')
        .doc(userId)
        .withConverter<Schedule>(
            fromFirestore: (snapshot, _) => Schedule.fromJson(snapshot.data()!),
            toFirestore: (schedule, _) => schedule.toJson())
        .get();
    return snapshot.data()!;
  }
}
