import 'package:date_range_form_field/date_range_form_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangeSelector extends StatefulWidget {
  final Function notifyParent;
  final String title;

  DateRangeSelector(this.title, this.notifyParent);

  @override
  _DateRangeSelector createState() => _DateRangeSelector();
}

class _DateRangeSelector extends State<DateRangeSelector> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DateRangeField(
          enabled: true,
          dateFormat: DateFormat('dd/MM/yyyy'),
          initialValue: DateTimeRange(
              start: DateTime.now(),
              end: DateTime.now().add(Duration(days: 5))),
          decoration: InputDecoration(
            labelText: widget.title,
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
              widget.notifyParent(value);
            });
          }),
    );
  }
}
