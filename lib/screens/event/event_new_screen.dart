import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:boramarcarapp/models/http_exception.dart';
import 'package:boramarcarapp/providers/events.dart';
import 'package:boramarcarapp/widgets/app_drawer.dart';
import 'package:boramarcarapp/widgets/event/event_invite_modal.dart';
import 'package:boramarcarapp/utils.dart' as utils;

class EventFormScreen extends StatefulWidget {
  static const routeName = '/new-event';

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventFormScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final User? _userInfo = FirebaseAuth.instance.currentUser;
  final List<String> invitedList = [];
  XFile? _imgFile;
  final ImagePicker _imgPicker = ImagePicker();

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

  void _onChanged(dynamic value) {}

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
    String link = '';
    try {
      if (_imgFile != null) {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage
            .ref()
            .child("event_banner")
            .child('event_banner_' + utils.getRandomString(10));
        await ref.putFile(File(_imgFile!.path)).then((storageTask) async {
          link = await storageTask.ref.getDownloadURL();
          print(link);
        });
      }
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
        link,
      );
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

  Widget _eventImageBanner() {
    return Stack(
      children: [
        Container(
          child: _imgFile == null
              ? Image.asset('assets/images/baloes.jpg')
              : Image.file(File(_imgFile!.path)),
          height: 150.0,
        ),
        Positioned(
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: ((builder) => _photoOptionBottomSheet()));
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 28.0,
              semanticLabel: "Troque a foto",
            ),
          ),
          bottom: 20.0,
          right: 20.0,
        ),
      ],
    );
  }

  Widget _photoOptionBottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          Text("Escolha a Foto", style: TextStyle(fontSize: 20)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  _takePicture(ImageSource.camera);
                },
                child: Row(children: [
                  Icon(Icons.camera),
                  Text('Camera'),
                ]),
              ),
              SizedBox(width: 30),
              TextButton(
                onPressed: () {
                  _takePicture(ImageSource.gallery);
                },
                child: Row(children: [
                  Icon(Icons.photo_album),
                  Text('Galeria'),
                ]),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _takePicture(ImageSource source) async {
    final pickedFile = await _imgPicker.pickImage(source: source);
    setState(() {
      _imgFile = pickedFile;
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
                    _eventImageBanner(),
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
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      name: 'description',
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                        prefixIcon: Icon(Icons.short_text_outlined),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 30.0),
                        border: OutlineInputBorder(),
                        helperText: '*máximo de 500 caracteres',
                      ),
                      onChanged: _onChanged,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context,
                            errorText: 'Campo Obrigatório'),
                        FormBuilderValidators.max(context, 500,
                            errorText: 'Máximo de 500 caracteres'),
                      ]),
                    ),
                    EventInviteModal(invitedList),
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
                        color: Theme.of(context).colorScheme.secondary,
                        child: Text(
                          "Enviar",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          _formKey.currentState!.save();
                          if (_formKey.currentState!.validate()) {
                            _submit();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Houve um erro ao enviar o formulário. Tente novamente mais tarde."),
                            ));
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: MaterialButton(
                        color: Theme.of(context).colorScheme.secondary,
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
