import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:boramarcarapp/models/http_exception.dart';
import 'package:boramarcarapp/providers/events.dart';
import 'package:boramarcarapp/widgets/app_drawer.dart';
import 'package:boramarcarapp/widgets/date_range/date_range_selector.dart';
import 'package:boramarcarapp/widgets/event/event_invited_chip.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class EventFormScreen extends StatefulWidget {
  static const routeName = '/new-event';

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventFormScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  final invitedList = ['Teste 1', 'Teste 2'];

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

  void _onChanged(dynamic value) {}

  void _refreshEventRange(dynamic value) {
    print(value);
  }

  void removeChip(String label) {
    setState(() {
      invitedList.removeWhere((element) => element == label);
    });
  }

  void addChip(String label) {
    setState(() {
      invitedList.add(label);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    final String eventName = _formKey.currentState!.value['name'];
    final String eventLocal = _formKey.currentState!.value['local'];
    final String eventDescription = _formKey.currentState!.value['description'];
    final DateTimeRange eventDaterange =
        _formKey.currentState!.value['date_range'];
    try {
      await Provider.of<Events>(context, listen: false).addEvent(
          eventName,
          'manager',
          'managerId',
          eventDaterange.start,
          eventLocal,
          eventDescription,
          context,
          null);
    } on HttpException catch (e) {
      var errMessage = "Erro no novo evento.\n${e.toString()}";
      _showErrorDialog(errMessage);
    } catch (e) {
      var errMessage = "Falha no novo evento.\n" + e.toString();
      _showErrorDialog(errMessage);
    } finally {
      _formKey.currentState!.reset();
      Navigator.of(context).pushReplacementNamed('/');
      setState(() {
        _isLoading = false;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Novo Evento')),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                children: <Widget>[
                  FormBuilderTextField(
                    name: 'name',
                    decoration: InputDecoration(
                      labelText: 'Nome do Evento',
                    ),
                    validator: FormBuilderValidators.required(context,
                        errorText: 'Campo Obrigatório'),
                  ),
                  FormBuilderTextField(
                    name: 'local',
                    decoration: InputDecoration(
                      labelText: 'Endereço',
                    ),
                    validator: FormBuilderValidators.required(context,
                        errorText: 'Campo Obrigatório'),
                  ),
                  FormBuilderTextField(
                    name: 'description',
                    decoration: InputDecoration(
                      labelText: 'Descrição',
                    ),
                    onChanged: _onChanged,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context,
                          errorText: 'Campo Obrigatório'),
                      FormBuilderValidators.max(context, 500,
                          errorText: 'Máximo de 500 caracteres'),
                    ]),
                    keyboardType: TextInputType.text,
                  ),
                  FormBuilderDateRangePicker(
                    name: 'date_range',
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 1),
                    format: DateFormat('dd-MM-yyyy'),
                    onChanged: _onChanged,
                    decoration: InputDecoration(
                      labelText: 'Intervalo de Data',
                      helperText: '*Intervalo máximo de 6 meses',
                    ),
                    validator: FormBuilderValidators.required(context,
                        errorText: 'Campo Obrigatório'),
                  ),
                  TextButton(
                    onPressed: () {
                      /*showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return EventInviteModal(invitedList, addChip);
                          });*/
                    },
                    child: Text(
                      '+ Adicionar Convidado',
                      style: TextStyle(
                          decoration: TextDecoration.underline, fontSize: 22),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (_isLoading)
              CircularProgressIndicator()
            else
              Row(
                children: <Widget>[
                  SizedBox(width: 10),
                  Expanded(
                    child: MaterialButton(
                      color: Theme.of(context).accentColor,
                      child: Text(
                        "Enviar",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _formKey.currentState!.save();
                        if (_formKey.currentState!.validate()) {
                          _submit();
                        } else {
                          print("validation failed");
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: MaterialButton(
                      color: Theme.of(context).accentColor,
                      child: Text(
                        "Limpar",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _formKey.currentState!.reset();
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              )
          ],
        ),
      ),
    );
  }
}
