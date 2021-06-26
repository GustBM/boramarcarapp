import 'package:boramarcarapp/models/schedule.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Schedules extends ChangeNotifier {
  CollectionReference _schedules =
      FirebaseFirestore.instance.collection('schedule');

  late Schedule _schedule;

  Schedule get getSchedule {
    return _schedule;
  }

  Future<DocumentSnapshot> getUserSchedule(String userId) {
    return _schedules.doc(userId).get();
  }

  Future<void> newAddSchedule(
      String userId,
      String sundayIni,
      String sundayEnd,
      String mondayIni,
      String mondayEnd,
      String tuesdayIni,
      String tuesdayEnd,
      String wednesdayIni,
      String wednesdayEnd,
      String thursdayIni,
      String thursdayEnd,
      String fridayIni,
      String fridayEnd,
      String saturdayIni,
      String saturdayEnd) async {
    var schedules =
        FirebaseFirestore.instance.collection('schedule').doc(userId);
    schedules
        .set({
          'sundayIni': sundayIni,
          'sundayEnd': sundayEnd,
          'mondayIni': mondayIni,
          'mondayEnd': mondayEnd,
          'tuesdayIni': tuesdayIni,
          'tuesdayEnd': tuesdayEnd,
          'wednesdayIni': wednesdayIni,
          'wednesdayEnd': wednesdayEnd,
          'thursdayIni': thursdayIni,
          'thursdayEnd': thursdayEnd,
          'fridayIni': fridayIni,
          'fridayEnd': fridayEnd,
          'saturdayIni': saturdayIni,
          'saturdayEnd': saturdayEnd,
        })
        .then((value) => print('Novo schedule'))
        .catchError((error) => print('Failed to add event: $error'));
  }

  Future<void> addSchedule(
      String userId, DateTime datesRangeBegin, DateTime dateRangeEnd) async {
    var schedules =
        FirebaseFirestore.instance.collection('schedule').doc(userId);
    schedules
        .set({
          'dataIni': datesRangeBegin,
          'dataEnd': dateRangeEnd,
        })
        .then((value) => print('Novo schedule'))
        .catchError((error) => print('Failed to add event: $error'));
  }

  /// Função retorna a data ideal dado um espaço de tempo do evento [eventRange]
  /// e as datas de disponibilidade dados [datesRange].
  /// A função sempre retorna o DateTime mais cedo do [eventRange].
  List<DateTime> idealDate(
      DateTimeRange eventRange, List<DateTimeRange> datesRange) {
    DateTime dtTemp = eventRange.start;
    Map<DateTime, int> topDates = Map<DateTime, int>();

    List<DateTime> avaliableDaysList = []; // Dias possíveis do evento
    List<DateTime> invitedAvaliableDaysList =
        []; // Dias em que os pariticpantes estarão disponívies

    while (dtTemp != eventRange.end) {
      dtTemp = dtTemp.add(const Duration(days: 1));
      avaliableDaysList.add(dtTemp);
      topDates.putIfAbsent(dtTemp, () => 0);
    }

    datesRange.forEach((element) {
      dtTemp = element.start;
      while (dtTemp != eventRange.end) {
        dtTemp = dtTemp.add(const Duration(days: 1));
        invitedAvaliableDaysList.add(dtTemp);
      }
    });

    avaliableDaysList.forEach((avaliableDay) => {
          invitedAvaliableDaysList.forEach((invitedDay) => {
                if (avaliableDay == invitedDay)
                  {
                    topDates.update(
                        avaliableDay, (int) => topDates[avaliableDay]! + 1,
                        ifAbsent: () => 0)
                  }
              })
        });

    print(topDates);
    return avaliableDaysList;
  }
}
