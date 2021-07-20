import 'package:boramarcarapp/models/http_exception.dart';
import 'package:boramarcarapp/models/schedule.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Schedules extends ChangeNotifier {
  CollectionReference _schedules =
      FirebaseFirestore.instance.collection('schedule');

  Future<DocumentSnapshot> getUserSchedule(String userId) {
    return _schedules.doc(userId).get();
  }

  Future<Schedule?> getAndSetUserSchedule(String userId) async {
    await _schedules.doc(userId).get().then((value) {
      return new Schedule(
        userId: userId,
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

  Future<void> newAddSchedule(
      String userId,
      int sundayIni,
      int sundayEnd,
      int mondayIni,
      int mondayEnd,
      int tuesdayIni,
      int tuesdayEnd,
      int wednesdayIni,
      int wednesdayEnd,
      int thursdayIni,
      int thursdayEnd,
      int fridayIni,
      int fridayEnd,
      int saturdayIni,
      int saturdayEnd) async {
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

  Future<List<DateTime>> getIdealDate(
      DateTimeRange dateTimeRange, List<String> usersId) async {
    // Map<DateTime, int> topDates = Map<DateTime, int>();
    List<DateTime> avaliableDaysList = [];
    // List<Schedule> userSchedules = [];
    List<DateTime> bsetDate = [];

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
          userId: element,
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
      avaliableDaysList = calculateDaysInterval(dateTimeRange);
      avaliableDaysList.forEach((element) {
        var tmpVal = bestDay;
        if (bestDay == 0) tmpVal = 7;
        if (element.weekday == tmpVal) bsetDate.add(element);
      });
    });
    // print(bestHours);
    bsetDate.add(dateTimeRange.start);
    return bsetDate;
  }

  List<DateTime> calculateDaysInterval(DateTimeRange dateTimeRange) {
    DateTime startDate = dateTimeRange.start;
    DateTime endDate = dateTimeRange.end;
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
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
      while (dtTemp.day != eventRange.end.day) {
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
