import 'package:boramarcarapp/providers/schedules.dart';
import 'package:boramarcarapp/widgets/date_range/date_range_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

GlobalKey<FormState> myFormKey = new GlobalKey();

class DateRangeForm extends StatefulWidget {
  @override
  _DateRangeFormState createState() => _DateRangeFormState();
}

class _DateRangeFormState extends State<DateRangeForm> {
  DateTimeRange eventRange = DateTimeRange(
      start: DateTime.now(), end: DateTime.now().add(Duration(days: 5)));
  DateTimeRange eventRange1 = DateTimeRange(
      start: DateTime.now(), end: DateTime.now().add(Duration(days: 7)));
  DateTimeRange eventRange2 = DateTimeRange(
      start: DateTime.now().subtract(Duration(days: 2)),
      end: DateTime.now().add(Duration(days: 3)));
  DateTimeRange eventRange3 = DateTimeRange(
      start: DateTime.now(), end: DateTime.now().add(Duration(days: 2)));

  List<DateTimeRange> datesRange = [];

  void refreshEventRange(dynamic childValue) {
    setState(() {
      eventRange = childValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Schedules sch = new Schedules();
    datesRange.add(eventRange1);
    datesRange.add(eventRange2);
    datesRange.add(eventRange3);
    void _submitForm() {
      final FormState form = myFormKey.currentState;
      form.save();
      setState(() {});
      print(eventRange);
      sch.idealDate(eventRange, datesRange);
    }

    return SafeArea(
      child: Form(
        key: myFormKey,
        child: Column(
          children: [
            SafeArea(
                child: DateRangeSelector(
                    "Datas Possíveis do Evento", refreshEventRange)),
            ElevatedButton(
              child: Text('Enviar'),
              onPressed: _submitForm,
            ),
          ],
        ),
      ),
    );
  }
}
