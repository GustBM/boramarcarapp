import 'package:date_range_form_field/date_range_form_field.dart';
import 'package:flutter/material.dart';

class DateRangeSelector extends StatefulWidget {
  @override
  _DateRangeSelector createState() => _DateRangeSelector();
}

class _DateRangeSelector extends State<DateRangeSelector> {
  DateTimeRange? myDateRange;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DateRangeField(
          enabled: true,
          initialValue: DateTimeRange(
              start: DateTime.now(),
              end: DateTime.now().add(Duration(days: 5))),
          decoration: InputDecoration(
            labelText: 'Data Ocupada',
            prefixIcon: Icon(Icons.date_range),
            hintText: 'Selecione o período',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value!.start.isBefore(DateTime.now())) {
              return 'Please enter a later start date';
            }
            return null;
          },
          onSaved: (value) {
            setState(() {
              myDateRange = value!;
            });
          }),
    );
  }
}
