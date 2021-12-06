import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import 'package:boramarcarapp/models/http_exception.dart';
import 'package:boramarcarapp/models/schedule.dart';
import 'package:boramarcarapp/controllers/schedules_controller.dart';
import 'package:boramarcarapp/widgets/schedule/schedule_form_field.dart';

import '../../utils.dart';

class ScheduleLeisureScreen extends StatefulWidget {
  @override
  _ScheduleLeisureScreenState createState() => _ScheduleLeisureScreenState();
}

class _ScheduleLeisureScreenState extends State<ScheduleLeisureScreen> {
  final GlobalKey<FormBuilderState> _schedueleFormKey =
      GlobalKey<FormBuilderState>();

  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    myFocusNode.dispose();

    super.dispose();
  }

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
        await Provider.of<ScheduleController>(context, listen: false).addSchedule(
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
                saturdayCheck: disableDay[6]),
            scheduleType: 'L');
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
      body: FutureBuilder(
        future: Provider.of<ScheduleController>(context, listen: false)
            .getUserSchedule(_userInfo!.uid, scheduleType: 'L')
            .catchError((onError) {
          ScheduleController.addNewUserSchedule(_userInfo.uid);
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
              ScheduleController.addNewUserSchedule(_userInfo.uid);
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
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, bottom: 8.0, top: 0.0),
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
                          ElevatedButton(
                            child: Text("Enviar"),
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
