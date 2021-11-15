import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:boramarcarapp/models/schedule.dart';

class SchedueleFormField extends StatefulWidget {
  final Schedule? sch;
  final void Function(int, bool) disableDayCheck;
  final List<String> hourOptionsIni;
  final List<String> hourOptionsEnd;
  final int weekDay;

  SchedueleFormField(this.sch, this.disableDayCheck, this.hourOptionsIni,
      this.hourOptionsEnd, this.weekDay);

  @override
  _SchedueleFormFieldState createState() => _SchedueleFormFieldState();
}

class _SchedueleFormFieldState extends State<SchedueleFormField> {
  late String fieldName;
  late String fieldTitle;
  late String fieldIniName;
  late String fieldEndName;
  late bool fieldCheck;
  late int initialHour;
  late int endHour;

  @override
  Widget build(BuildContext context) {
    switch (widget.weekDay) {
      case 0:
        fieldName = 'sunday_check';
        fieldTitle = 'Domingo';
        initialHour = widget.sch!.sundayIni;
        endHour = widget.sch!.sundayEnd;
        fieldIniName = 'sunday_hour_ini';
        fieldEndName = 'sunday_hour_end';
        fieldCheck = widget.sch!.sundayCheck;
        break;
      case 1:
        fieldName = 'monday_check';
        fieldTitle = 'Segunda';
        initialHour = widget.sch!.mondayIni;
        endHour = widget.sch!.mondayEnd;
        fieldIniName = 'monday_hour_ini';
        fieldEndName = 'monday_hour_end';
        fieldCheck = widget.sch!.mondayCheck;
        break;
      case 2:
        fieldName = 'tuesday_check';
        fieldTitle = 'Terça';
        initialHour = widget.sch!.tuesdayIni;
        endHour = widget.sch!.tuesdayEnd;
        fieldIniName = 'tuesday_hour_ini';
        fieldEndName = 'tuesday_hour_end';
        fieldCheck = widget.sch!.tuesdayCheck;
        break;
      case 3:
        fieldName = 'wednesday_check';
        fieldTitle = 'Quarta';
        initialHour = widget.sch!.wednesdayIni;
        endHour = widget.sch!.wednesdayEnd;
        fieldIniName = 'wednesday_hour_ini';
        fieldEndName = 'wednesday_hour_end';
        fieldCheck = widget.sch!.wednesdayCheck;
        break;
      case 4:
        fieldName = 'thursday_check';
        fieldTitle = 'Quinta';
        initialHour = widget.sch!.thursdayIni;
        endHour = widget.sch!.thursdayEnd;
        fieldIniName = 'thursday_hour_ini';
        fieldEndName = 'thursday_hour_end';
        fieldCheck = widget.sch!.thursdayCheck;
        break;
      case 5:
        fieldName = 'friday_check';
        fieldTitle = 'Sexta';
        initialHour = widget.sch!.fridayIni;
        endHour = widget.sch!.fridayEnd;
        fieldIniName = 'friday_hour_ini';
        fieldEndName = 'friday_hour_end';
        fieldCheck = widget.sch!.fridayCheck;
        break;
      case 6:
        fieldName = 'saturday_check';
        fieldTitle = 'Sábado';
        initialHour = widget.sch!.saturdayIni;
        endHour = widget.sch!.saturdayEnd;
        fieldIniName = 'saturday_hour_ini';
        fieldEndName = 'saturday_hour_end';
        fieldCheck = widget.sch!.saturdayCheck;
        break;

      default:
        break;
    }
    return Row(
      children: [
        Flexible(
          child: FormBuilderCheckbox(
            name: fieldName,
            initialValue: fieldCheck,
            title: Text(fieldTitle),
            onChanged: (value) {
              widget.disableDayCheck(widget.weekDay, value!);
            },
          ),
        ),
        Expanded(
          child: FormBuilderDropdown(
            enabled: fieldCheck,
            name: fieldIniName,
            hint: Text('Hora Inicial'),
            initialValue: widget.hourOptionsIni[initialHour],
            validator: FormBuilderValidators.compose(
                [FormBuilderValidators.required(context)]),
            items: widget.hourOptionsIni
                .map((chosenHour) => DropdownMenuItem(
                      value: chosenHour,
                      child: Text('$chosenHour'),
                    ))
                .toList(),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: FormBuilderDropdown(
            enabled: fieldCheck,
            name: fieldEndName,
            hint: Text('Hora Final'),
            initialValue: widget.hourOptionsEnd[endHour],
            validator: FormBuilderValidators.compose(
                [FormBuilderValidators.required(context)]),
            items: widget.hourOptionsEnd
                .map((chosenHour) => DropdownMenuItem(
                      value: chosenHour,
                      child: Text('$chosenHour'),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
