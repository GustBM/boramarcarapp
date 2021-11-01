import 'package:boramarcarapp/models/schedule.dart';
import 'package:boramarcarapp/providers/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:boramarcarapp/models/http_exception.dart';
import 'package:boramarcarapp/providers/schedules.dart';
import 'package:boramarcarapp/widgets/app_drawer.dart';

import '../utils.dart';

class SchedueleScreen extends StatefulWidget {
  static const routeName = '/schedule';

  @override
  _SchedueleScreenState createState() => _SchedueleScreenState();
}

class _SchedueleScreenState extends State<SchedueleScreen> {
  final GlobalKey<FormBuilderState> _schedueleFormKey =
      GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final User? _userInfo = FirebaseAuth.instance.currentUser;
    var _isLoading = false;

    int _parseFormInput(String formInput) {
      return int.parse(formInput.substring(0, 2));
    }

    var disableDay = [true, true, true, true, true, true, true];

    void disableDayCheck(int day, bool isDisabled) {
      disableDay[day] = isDisabled;
    }

    Future<void> _submit() async {
      if (!_schedueleFormKey.currentState!.validate()) {
        return;
      }
      _schedueleFormKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      try {
        await Provider.of<Schedules>(context, listen: false).addSchedule(
            _userInfo!.uid,
            new Schedule(
                sundayIni: _parseFormInput(_schedueleFormKey
                    .currentState!.value['sunday_hour_ini'] as String),
                sundayEnd: _parseFormInput(_schedueleFormKey
                    .currentState!.value['sunday_hour_end'] as String),
                sundayCheck: disableDay[0],
                mondayIni: _parseFormInput(_schedueleFormKey
                    .currentState!.value['monday_hour_ini'] as String),
                mondayEnd: _parseFormInput(_schedueleFormKey
                    .currentState!.value['monday_hour_end'] as String),
                mondayCheck: disableDay[1],
                tuesdayIni: _parseFormInput(
                    _schedueleFormKey.currentState!.value['tuesday_hour_ini'] as String),
                tuesdayEnd: _parseFormInput(_schedueleFormKey.currentState!.value['tuesday_hour_end'] as String),
                tuesdayCheck: disableDay[2],
                wednesdayIni: _parseFormInput(_schedueleFormKey.currentState!.value['wednesday_hour_ini'] as String),
                wednesdayEnd: _parseFormInput(_schedueleFormKey.currentState!.value['wednesday_hour_end'] as String),
                wednesdayCheck: disableDay[3],
                thursdayIni: _parseFormInput(_schedueleFormKey.currentState!.value['thursday_hour_ini'] as String),
                thursdayEnd: _parseFormInput(_schedueleFormKey.currentState!.value['thursday_hour_end'] as String),
                thursdayCheck: disableDay[4],
                fridayIni: _parseFormInput(_schedueleFormKey.currentState!.value['friday_hour_ini'] as String),
                fridayEnd: _parseFormInput(_schedueleFormKey.currentState!.value['friday_hour_end'] as String),
                fridayCheck: disableDay[5],
                saturdayIni: _parseFormInput(_schedueleFormKey.currentState!.value['saturday_hour_ini'] as String),
                saturdayEnd: _parseFormInput(_schedueleFormKey.currentState!.value['saturday_hour_end'] as String),
                saturdayCheck: disableDay[6]));
      } on HttpException catch (e) {
        var errMessage = "Erro no novo horário.\n${e.toString()}";
        showErrorDialog(context, errMessage);
      } catch (e) {
        var errMessage = "Falha no novo horário.\n" + e.toString();
        showErrorDialog(context, errMessage);
      } finally {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Horário Atualizado!"),
          ),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }

    var hourOptionsIni = [
      "00:00",
      "01:00",
      "02:00",
      "03:00",
      "04:00",
      "05:00",
      "06:00",
      "07:00",
      "08:00",
      "09:00",
      "10:00",
      "11:00",
      "12:00",
      "13:00",
      "14:00",
      "15:00",
      "16:00",
      "17:00",
      "18:00",
      "19:00",
      "20:00",
      "21:00",
      "22:00",
      "23:00",
    ];

    var hourOptionsEnd = [
      "00:00",
      "01:00",
      "02:00",
      "03:00",
      "04:00",
      "05:00",
      "06:00",
      "07:00",
      "08:00",
      "09:00",
      "10:00",
      "11:00",
      "12:00",
      "13:00",
      "14:00",
      "15:00",
      "16:00",
      "17:00",
      "18:00",
      "19:00",
      "20:00",
      "21:00",
      "22:00",
      "23:00",
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Meu Horário')),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Schedules>(context, listen: false)
            .getUserSchedule(_userInfo!.uid)
            .catchError((onError) {
          Provider.of<Schedules>(context, listen: false)
              .addNewUserSchedule(_userInfo.uid);
          showErrorDialog(context,
              'Houve um erro no cadastro do horário e ele deverá ser resetado.');
        }),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Schedule>> snapshot) {
          if (snapshot.hasError) {
            return Text(
                "Erro ao recuperar o horário. Tente novamente mais tarde.");
          }

          Schedule? sch;
          if (snapshot.connectionState == ConnectionState.done) {
            if (!(snapshot.hasData && !snapshot.data!.exists)) {
              sch = snapshot.data!.data();
            }
            if (sch == null) {
              Provider.of<Auth>(context, listen: false)
                  .addNewUserSchedule(_userInfo.uid);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => super.widget));
              return Center(child: CircularProgressIndicator());
            } else {
              disableDayCheck(0, sch.sundayCheck);
              disableDayCheck(1, sch.mondayCheck);
              disableDayCheck(2, sch.tuesdayCheck);
              disableDayCheck(3, sch.wednesdayCheck);
              disableDayCheck(4, sch.thursdayCheck);
              disableDayCheck(5, sch.fridayCheck);
              disableDayCheck(6, sch.saturdayCheck);

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FormBuilder(
                    key: _schedueleFormKey,
                    child: Column(
                      children: [
                        SchedueleFormField(sch, disableDayCheck, hourOptionsIni,
                            hourOptionsEnd, 0),
                        SchedueleFormField(sch, disableDayCheck, hourOptionsIni,
                            hourOptionsEnd, 1),
                        SchedueleFormField(sch, disableDayCheck, hourOptionsIni,
                            hourOptionsEnd, 2),
                        SchedueleFormField(sch, disableDayCheck, hourOptionsIni,
                            hourOptionsEnd, 3),
                        SchedueleFormField(sch, disableDayCheck, hourOptionsIni,
                            hourOptionsEnd, 4),
                        SchedueleFormField(sch, disableDayCheck, hourOptionsIni,
                            hourOptionsEnd, 5),
                        SchedueleFormField(sch, disableDayCheck, hourOptionsIni,
                            hourOptionsEnd, 6),
                        SizedBox(width: 10),
                        if (_isLoading)
                          CircularProgressIndicator()
                        else
                          MaterialButton(
                            color: Theme.of(context).colorScheme.secondary,
                            child: Text(
                              "Enviar",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 20),
                            ),
                            onPressed: () {
                              _schedueleFormKey.currentState!.save();
                              if (_schedueleFormKey.currentState!.validate()) {
                                _submit();
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                      "Houve um Erro nas Informações. Verifique os dados."),
                                ));
                              }
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

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
