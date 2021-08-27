import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:boramarcarapp/models/http_exception.dart';
import 'package:boramarcarapp/providers/schedules.dart';
import 'package:boramarcarapp/widgets/app_drawer.dart';

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

    void _showErrorDialog(String message) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("ERRO!"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text("Ok"))
          ],
        ),
      );
    }

    int _parseFormInput(String formInput) {
      return int.parse(formInput.substring(0, 2));
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
          _parseFormInput(_schedueleFormKey
              .currentState!.value['sunday_hour_ini'] as String),
          _parseFormInput(_schedueleFormKey
              .currentState!.value['sunday_hour_end'] as String),
          _parseFormInput(_schedueleFormKey
              .currentState!.value['monday_hour_ini'] as String),
          _parseFormInput(_schedueleFormKey
              .currentState!.value['monday_hour_end'] as String),
          _parseFormInput(_schedueleFormKey
              .currentState!.value['tuesday_hour_ini'] as String),
          _parseFormInput(_schedueleFormKey
              .currentState!.value['tuesday_hour_end'] as String),
          _parseFormInput(_schedueleFormKey
              .currentState!.value['wednesday_hour_ini'] as String),
          _parseFormInput(_schedueleFormKey
              .currentState!.value['wednesday_hour_end'] as String),
          _parseFormInput(_schedueleFormKey
              .currentState!.value['thursday_hour_ini'] as String),
          _parseFormInput(_schedueleFormKey
              .currentState!.value['thursday_hour_end'] as String),
          _parseFormInput(_schedueleFormKey
              .currentState!.value['friday_hour_ini'] as String),
          _parseFormInput(_schedueleFormKey
              .currentState!.value['friday_hour_end'] as String),
          _parseFormInput(_schedueleFormKey
              .currentState!.value['saturday_hour_ini'] as String),
          _parseFormInput(_schedueleFormKey
              .currentState!.value['saturday_hour_end'] as String),
        );
      } on HttpException catch (e) {
        var errMessage = "Erro no novo horário.\n${e.toString()}";
        _showErrorDialog(errMessage);
      } catch (e) {
        var errMessage = "Falha no novo horário.\n" + e.toString();
        _showErrorDialog(errMessage);
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
      "23:00"
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
      "23:00"
    ];

    var disableDay = [true, true, true, true, true, true, true];

    return Scaffold(
      appBar: AppBar(title: Text('Meu Horário')),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Schedules>(context, listen: false)
            .getUserSchedule(_userInfo!.uid),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text(
                "Erro ao recuperar o horário. Tente novamente mais tarde.");
          }
          Map<String, dynamic> data = {};
          if (snapshot.connectionState == ConnectionState.done) {
            if (!(snapshot.hasData && !snapshot.data!.exists)) {
              data = snapshot.data!.data() as Map<String, dynamic>;
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FormBuilder(
                  key: _schedueleFormKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: FormBuilderCheckbox(
                              name: 'sunday_check',
                              initialValue: true,
                              title: Text('Domingo'),
                              onChanged: (value) {
                                disableDay[0] = value!;
                              },
                            ),
                          ),
                          Expanded(
                            child: FormBuilderDropdown(
                              enabled: disableDay[0],
                              name: 'sunday_hour_ini',
                              hint: Text('Hora Inicial'),
                              initialValue: data.isNotEmpty
                                  ? hourOptionsIni[data['sundayIni']]
                                  : hourOptionsIni[6],
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(context)]),
                              items: hourOptionsIni
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
                              enabled: disableDay[0],
                              name: 'sunday_hour_end',
                              hint: Text('Hora Final'),
                              initialValue: data.isNotEmpty
                                  ? hourOptionsEnd[data['sundayEnd']]
                                  : hourOptionsEnd[18],
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(context)]),
                              items: hourOptionsEnd
                                  .map((chosenHour) => DropdownMenuItem(
                                        value: chosenHour,
                                        child: Text('$chosenHour'),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                      // Terça
                      Row(
                        children: [
                          Flexible(
                            child: FormBuilderCheckbox(
                              name: 'monday_check',
                              initialValue: true,
                              title: Text('Segunda'),
                            ),
                          ),
                          Expanded(
                            child: FormBuilderDropdown(
                              name: 'monday_hour_ini',
                              hint: Text('Hora Inicial'),
                              initialValue: data.isNotEmpty
                                  ? hourOptionsIni[data['mondayIni']]
                                  : hourOptionsIni[6],
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(context)]),
                              items: hourOptionsIni
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
                              name: 'monday_hour_end',
                              hint: Text('Hora Final'),
                              initialValue: data.isNotEmpty
                                  ? hourOptionsEnd[data['mondayEnd']]
                                  : hourOptionsEnd[18],
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(context)]),
                              items: hourOptionsEnd
                                  .map((chosenHour) => DropdownMenuItem(
                                        value: chosenHour,
                                        child: Text('$chosenHour'),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: FormBuilderCheckbox(
                              name: 'tuesday_check',
                              initialValue: true,
                              title: Text('Terça'),
                            ),
                          ),
                          Expanded(
                            child: FormBuilderDropdown(
                              name: 'tuesday_hour_ini',
                              hint: Text('Hora Inicial'),
                              initialValue: data.isNotEmpty
                                  ? hourOptionsEnd[data['tuesdayIni']]
                                  : hourOptionsEnd[18],
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(context)]),
                              items: hourOptionsIni
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
                              name: 'tuesday_hour_end',
                              hint: Text('Hora Final'),
                              initialValue: data.isNotEmpty
                                  ? hourOptionsEnd[data['tuesdayEnd']]
                                  : hourOptionsEnd[18],
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(context)]),
                              items: hourOptionsEnd
                                  .map((chosenHour) => DropdownMenuItem(
                                        value: chosenHour,
                                        child: Text('$chosenHour'),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: FormBuilderCheckbox(
                              name: 'wednesday_check',
                              initialValue: true,
                              title: Text('Quarta'),
                            ),
                          ),
                          Expanded(
                            child: FormBuilderDropdown(
                              name: 'wednesday_hour_ini',
                              hint: Text('Hora Inicial'),
                              initialValue: data.isNotEmpty
                                  ? hourOptionsIni[data['wednesdayIni']]
                                  : hourOptionsIni[6],
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(context)]),
                              items: hourOptionsIni
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
                              name: 'wednesday_hour_end',
                              hint: Text('Hora Final'),
                              initialValue: data.isNotEmpty
                                  ? hourOptionsEnd[data['wednesdayEnd']]
                                  : hourOptionsEnd[18],
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(context)]),
                              items: hourOptionsIni
                                  .map((chosenHour) => DropdownMenuItem(
                                        value: chosenHour,
                                        child: Text('$chosenHour'),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: FormBuilderCheckbox(
                              name: 'thursday_check',
                              initialValue: true,
                              title: Text('Quinta'),
                            ),
                          ),
                          Expanded(
                            child: FormBuilderDropdown(
                              name: 'thursday_hour_ini',
                              hint: Text('Hora Inicial'),
                              initialValue: data.isNotEmpty
                                  ? hourOptionsIni[data['thursdayIni']]
                                  : hourOptionsIni[6],
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(context)]),
                              items: hourOptionsIni
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
                              name: 'thursday_hour_end',
                              hint: Text('Hora Final'),
                              initialValue: data.isNotEmpty
                                  ? hourOptionsEnd[data['thursdayEnd']]
                                  : hourOptionsEnd[18],
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(context)]),
                              items: hourOptionsEnd
                                  .map((chosenHour) => DropdownMenuItem(
                                        value: chosenHour,
                                        child: Text('$chosenHour'),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: FormBuilderCheckbox(
                              name: 'friday_check',
                              initialValue: true,
                              title: Text('Sexta'),
                            ),
                          ),
                          Expanded(
                            child: FormBuilderDropdown(
                              name: 'friday_hour_ini',
                              hint: Text('Hora Inicial'),
                              initialValue: data.isNotEmpty
                                  ? hourOptionsIni[data['fridayIni']]
                                  : hourOptionsIni[6],
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(context)]),
                              items: hourOptionsIni
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
                              name: 'friday_hour_end',
                              hint: Text('Hora Final'),
                              initialValue: data.isNotEmpty
                                  ? hourOptionsEnd[data['fridayEnd']]
                                  : hourOptionsEnd[18],
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(context)]),
                              items: hourOptionsEnd
                                  .map((chosenHour) => DropdownMenuItem(
                                        value: chosenHour,
                                        child: Text('$chosenHour'),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: FormBuilderCheckbox(
                              name: 'saturday_check',
                              initialValue: true,
                              title: Text('Sábado'),
                            ),
                          ),
                          Expanded(
                            child: FormBuilderDropdown(
                              name: 'saturday_hour_ini',
                              hint: Text('Hora Inicial'),
                              initialValue: data.isNotEmpty
                                  ? hourOptionsIni[data['saturdayIni']]
                                  : hourOptionsIni[6],
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(context)]),
                              items: hourOptionsIni
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
                              name: 'saturday_hour_end',
                              hint: Text('Hora Final'),
                              initialValue: data.isNotEmpty
                                  ? hourOptionsEnd[data['saturdayEnd']]
                                  : hourOptionsEnd[18],
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(context)]),
                              items: hourOptionsEnd
                                  .map((chosenHour) => DropdownMenuItem(
                                        value: chosenHour,
                                        child: Text('$chosenHour'),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      if (_isLoading)
                        CircularProgressIndicator()
                      else
                        MaterialButton(
                          color: Theme.of(context).accentColor,
                          child: Text(
                            "Enviar",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 20),
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

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
