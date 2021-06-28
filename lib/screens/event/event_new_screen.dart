import 'package:boramarcarapp/providers/schedules.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:boramarcarapp/models/http_exception.dart';
import 'package:boramarcarapp/providers/events.dart';
import 'package:boramarcarapp/widgets/app_drawer.dart';

class EventFormScreen extends StatefulWidget {
  static const routeName = '/new-event';

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventFormScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final User? _userInfo = FirebaseAuth.instance.currentUser;
  final List<String> invitedList = [];

  var _isLoading = false;

  final userEmailController = TextEditingController();

  var errorText = '';

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

  Widget _buildChip(String label) {
    return Chip(
      labelPadding: EdgeInsets.all(2.0),
      avatar: CircleAvatar(
        backgroundImage: Image.asset(
          'assets/images/standard_user_photo.png',
        ).image,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Color(0xFF5f65d3),
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(8.0),
      deleteIcon: Icon(Icons.cancel),
      onDeleted: () {
        removeChip(label);
      },
    );
  }

  void _onChanged(dynamic value) {}

  bool _isValidEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  void removeChip(String label) {
    setState(() {
      invitedList.removeWhere((element) => element == label);
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
    var userId = _userInfo!.uid;
    var userEmail = _userInfo!.email;
    var userName = _userInfo!.displayName;
    try {
      /*await Provider.of<Auth>(context, listen: false)
          .validateEmails(invitedList);*/
      invitedList.add(userEmail!);
      await Provider.of<Events>(context, listen: false).addEvent(
          eventName,
          userName!,
          userId,
          eventDaterange.start,
          eventDaterange.start,
          eventDaterange.end,
          eventLocal,
          eventDescription,
          context,
          invitedList,
          null);
    } on HttpException catch (e) {
      var errMessage = "Erro no novo evento.\n${e.toString()}";
      _showErrorDialog(errMessage);
      setState(() {
        _isLoading = false;
      });
      return;
    } catch (e) {
      var errMessage = "Falha no novo evento.\n" + e.toString();
      _showErrorDialog(errMessage);
      setState(() {
        _isLoading = false;
      });
      return;
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              FormBuilder(
                key: _formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                    FormBuilderTextField(
                      name: 'name',
                      decoration: InputDecoration(
                        labelText: 'Nome do Evento',
                        prefixIcon: Icon(Icons.short_text_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: FormBuilderValidators.required(context,
                          errorText: 'Campo Obrigatório'),
                    ),
                    SizedBox(height: 10),
                    FormBuilderTextField(
                      name: 'local',
                      decoration: InputDecoration(
                        labelText: 'Endereço',
                        prefixIcon: Icon(Icons.location_on_sharp),
                        border: OutlineInputBorder(),
                      ),
                      validator: FormBuilderValidators.required(context,
                          errorText: 'Campo Obrigatório'),
                    ),
                    SizedBox(height: 10),
                    SafeArea(
                      child: FormBuilderDateRangePicker(
                        name: 'date_range',
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 1),
                        format: DateFormat('dd-MM-yyyy'),
                        onChanged: _onChanged,
                        decoration: InputDecoration(
                          labelText: 'Intervalo de Data',
                          helperText: '*Intervalo máximo de 6 meses',
                          prefixIcon: Icon(Icons.date_range),
                          hintText: 'Selecione o período',
                          border: OutlineInputBorder(),
                        ),
                        validator: FormBuilderValidators.required(context,
                            errorText: 'Campo Obrigatório'),
                      ),
                    ),
                    SizedBox(height: 10),
                    FormBuilderTextField(
                      name: 'description',
                      decoration: InputDecoration(
                        labelText: 'Descrição',
                        prefixIcon: Icon(Icons.short_text_outlined),
                        border: OutlineInputBorder(),
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
                    TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) => new AlertDialog(
                                  title: Text(
                                    'Insira o e-mail do convidado',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  content: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: TextField(
                                          decoration: InputDecoration(
                                              hintText: 'Insira o e-mail'),
                                          controller: userEmailController,
                                        ),
                                      ),
                                      Text(
                                        errorText,
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Fechar',
                                          style: TextStyle(fontSize: 16)),
                                      onPressed: () {
                                        setState(() {});
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                        child: Text(
                                          'Adicionar Convidado',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        onPressed: () {
                                          if (_isValidEmail(
                                              userEmailController.value.text)) {
                                            invitedList.add(
                                                userEmailController.value.text);
                                            setState(() {});
                                            Navigator.of(context).pop();
                                          }
                                        }),
                                  ],
                                ));
                        // Navigator.of(context).restorablePush(_dialogBuilder);
                      },
                      child: Text(
                        '+ Adicionar Convidado',
                        style: TextStyle(
                            decoration: TextDecoration.underline, fontSize: 22),
                      ),
                    ),
                    Column(
                      children: invitedList.map((e) {
                        return _buildChip(e);
                      }).toList(),
                    )
                    // InvitedChipList([], () {}),
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
      ),
    );
  }
}
