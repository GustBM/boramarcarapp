import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:boramarcarapp/models/http_exception.dart';
import 'package:boramarcarapp/models/schedule.dart';

class Schedules extends ChangeNotifier {
  CollectionReference _schedules =
      FirebaseFirestore.instance.collection('schedule');

  Future<DocumentSnapshot<Schedule>> getUserSchedule(String userId) {
    return _schedules
        .doc(userId)
        .withConverter<Schedule>(
            fromFirestore: (snapshot, _) => Schedule.fromJson(snapshot.data()!),
            toFirestore: (schedule, _) => schedule.toJson())
        .get();
  }

  Future<Schedule?> getAndSetUserSchedule(String userId) async {
    await _schedules.doc(userId).get().then((value) {
      return new Schedule(
        sundayIni: value['sundayIni'],
        sundayEnd: value['sundayEnd'],
        mondayIni: value['mondayIni'],
        mondayEnd: value['mondayEnd'],
        tuesdayIni: value['tuesdayIni'],
        tuesdayEnd: value['tuesdayEnd'],
        wednesdayIni: value['wednesdayIni'],
        wednesdayEnd: value['wednesdayEnd'],
        thursdayIni: value['thursdayIni'],
        thursdayEnd: value['thursdayEnd'],
        fridayIni: value['fridayIni'],
        fridayEnd: value['fridayEnd'],
        saturdayIni: value['saturdayIni'],
        saturdayEnd: value['saturdayEnd'],
      );
    }).catchError(
        (e) => throw HttpException("Houve um Erro!" + e.code.toString()));
  }

  Future<void> addSchedule(String userId, Schedule schedule) async {
    _schedules.doc(userId).set({
      'sundayIni': schedule.sundayIni,
      'sundayEnd': schedule.sundayEnd,
      'sundayCheck': schedule.sundayCheck,
      'mondayIni': schedule.mondayIni,
      'mondayEnd': schedule.mondayEnd,
      'mondayCheck': schedule.mondayCheck,
      'tuesdayIni': schedule.tuesdayIni,
      'tuesdayEnd': schedule.tuesdayEnd,
      'tuesdayCheck': schedule.thursdayCheck,
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

  List<int> _iniList() {
    return [
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0
    ];
  }

  /// Retorna um `int` com o valor da posição com o maior valor do array [arr]
  int _indexOfMax(List<int> arr) {
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

  /// Retorna uma `List<DateTime>` com os melhores dias entre um intervalo [dateTimeRange]
  /// e uma lista de usuários [usersId]. A função verifica a disponibilidade
  /// dos usuários no intervalo.
  /// TODO: Usuários prioritários e Dias bloqueados.
  Future<List<DateTime>> getIdealDate(
      DateTimeRange dateTimeRange, List<String> usersId) async {
    List<DateTime> avaliableDaysList = [];
    List<DateTime> bestDates = [];

    List<int> sundayList = _iniList();
    List<int> mondayList = _iniList();
    List<int> tuesdayList = _iniList();
    List<int> wednesdayList = _iniList();
    List<int> thursdayList = _iniList();
    List<int> fridayList = _iniList();
    List<int> saturdayList = _iniList();

    List<int> bestHours = [0, 0, 0, 0, 0, 0, 0];
    int bestDay = 0;

    await Future.forEach(usersId, (element) async {
      await _schedules.doc(element as String).get().then((value) {
        return new Schedule(
          sundayIni: value['sundayIni'],
          sundayEnd: value['sundayEnd'],
          mondayIni: value['mondayIni'],
          mondayEnd: value['mondayEnd'],
          tuesdayIni: value['tuesdayIni'],
          tuesdayEnd: value['tuesdayEnd'],
          wednesdayIni: value['wednesdayIni'],
          wednesdayEnd: value['wednesdayEnd'],
          thursdayIni: value['thursdayIni'],
          thursdayEnd: value['thursdayEnd'],
          fridayIni: value['fridayIni'],
          fridayEnd: value['fridayEnd'],
          saturdayIni: value['saturdayIni'],
          saturdayEnd: value['saturdayEnd'],
        );
      }).then((schedule) {
        for (var i = schedule.sundayIni; i <= schedule.sundayEnd; i++)
          sundayList[i]++;
        for (var i = schedule.mondayIni; i <= schedule.mondayEnd; i++)
          mondayList[i]++;
        for (var i = schedule.tuesdayIni; i <= schedule.tuesdayEnd; i++)
          tuesdayList[i]++;
        for (var i = schedule.wednesdayIni; i <= schedule.wednesdayEnd; i++)
          wednesdayList[i]++;
        for (var i = schedule.thursdayIni; i <= schedule.thursdayEnd; i++)
          thursdayList[i]++;
        for (var i = schedule.fridayIni; i <= schedule.fridayEnd; i++)
          fridayList[i]++;
        for (var i = schedule.saturdayIni; i <= schedule.saturdayEnd; i++)
          saturdayList[i]++;

        sundayList.forEach((element) {
          if (bestHours[0] < element) bestHours[0] = element;
        });
        mondayList.forEach((element) {
          if (bestHours[1] < element) bestHours[1] = element;
        });
        tuesdayList.forEach((element) {
          if (bestHours[2] < element) bestHours[2] = element;
        });
        wednesdayList.forEach((element) {
          if (bestHours[3] < element) bestHours[3] = element;
        });
        thursdayList.forEach((element) {
          if (bestHours[4] < element) bestHours[4] = element;
        });
        fridayList.forEach((element) {
          if (bestHours[5] < element) bestHours[5] = element;
        });
        saturdayList.forEach((element) {
          if (bestHours[6] < element) bestHours[6] = element;
        });

        bestDay = _indexOfMax(bestHours);
      });
    }).whenComplete(() {
      avaliableDaysList = _calculateDaysInterval(dateTimeRange);
      avaliableDaysList.forEach((element) {
        var tmpVal = bestDay;
        if (bestDay == 0) tmpVal = 7;
        if (element.weekday == tmpVal) bestDates.add(element);
      });
    });
    // print(bestHours);
    bestDates.add(dateTimeRange.start);
    return bestDates;
  }

  List<DateTime> _calculateDaysInterval(DateTimeRange dateTimeRange) {
    DateTime startDate = dateTimeRange.start;
    DateTime endDate = dateTimeRange.end;
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  Future<List<DateTime>> getIdealDateV2(
      DateTimeRange dateTimeRange, List<String> usersId) async {
    List<DateTime> bestDates = [];
    Map<DateTime, int> dates = Map();
    DateTime startDate = dateTimeRange.start;
    DateTime endDate = dateTimeRange.end;

    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      dates.putIfAbsent(startDate.add(Duration(days: i)), () => 0);
    }

    return bestDates;
  }
}
