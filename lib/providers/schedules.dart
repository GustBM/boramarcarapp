import 'package:flutter/material.dart';

class Schedules {
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
                        avaliableDay, (int) => topDates[avaliableDay] + 1,
                        ifAbsent: () => 0)
                  }
              })
        });

    print(topDates);
    return avaliableDaysList;
  }
}
