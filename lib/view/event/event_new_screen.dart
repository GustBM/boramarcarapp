import 'dart:io';

import 'package:boramarcarapp/controllers/users_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:boramarcarapp/controllers/events_controller.dart';
import 'package:boramarcarapp/models/event.dart';
import 'package:boramarcarapp/models/http_exception.dart';
import 'package:boramarcarapp/widgets/event/event_invite_modal.dart';
import 'package:boramarcarapp/widgets/group/group_invite_modal.dart';
import 'package:boramarcarapp/utils.dart' as utils;

import '../../utils.dart';

class EventFormScreen extends StatefulWidget {
  static const routeName = '/new-event';

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventFormScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final User? _userInfo = FirebaseAuth.instance.currentUser;
  List<String> invitedList = [];
  XFile? _imgFile;
  final ImagePicker _imgPicker = ImagePicker();

  var _isLoading = false;

  final userEmailController = TextEditingController();

  var errorText = '';

  int _typeOfEvent = 0;

  String? updateEventId;

  late FocusNode nameFocusNode;
  late FocusNode eventTypeFocusNode;
  late FocusNode adressFocusNode;
  late FocusNode dateIntervalFocusNode;
  late FocusNode descriptionFocusNode;

  @override
  void initState() {
    super.initState();

    nameFocusNode = FocusNode();
    eventTypeFocusNode = FocusNode();
    adressFocusNode = FocusNode();
    dateIntervalFocusNode = FocusNode();
    descriptionFocusNode = FocusNode();
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    eventTypeFocusNode.dispose();
    adressFocusNode.dispose();
    dateIntervalFocusNode.dispose();
    descriptionFocusNode.dispose();
    super.dispose();
  }

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
    final int eventType = _formKey.currentState!.value['event_type'];
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
        });
      }

      if (updateEventId != null) {
        await Provider.of<EventController>(context, listen: false).newEvent(
          eventName,
          userName!,
          userId,
          eventDaterange.start,
          eventDaterange.end,
          eventLocal,
          eventDescription,
          context,
          invitedList,
          link,
          updateEventId: updateEventId,
        );
      } else {
        invitedList.add(userEmail!);
        await Provider.of<EventController>(context, listen: false).newEvent(
          eventName,
          userName!,
          userId,
          eventDaterange.start,
          eventDaterange.end,
          eventLocal,
          eventDescription,
          context,
          invitedList,
          link,
          eventType: eventType,
        );
      }
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
              ? _typeOfEvent == 0
                  ? Image.asset('assets/images/baloes.jpg')
                  : Image.asset('assets/images/tabuleiro.png')
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
    final eventId = ModalRoute.of(context)!.settings.arguments as String?;
    final bool isEdit = eventId == null;

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: !(eventId == null),
          title: eventId == null ? Text('Novo Evento') : Text('Editar Evento')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: Provider.of<EventController>(context, listen: false)
                .getEvent(eventId),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot<Event>?> snapshot) {
              if (snapshot.hasError) {
                return SnapshotErroMsg(
                    'Houve um erro ao buscar o Evento.\nTente novamente mais tarde.');
              }
              if (snapshot.hasData && !snapshot.data!.exists) {
                return SnapshotErroMsg(
                    "Evento n??o encontrado ou deletado. Verifique o link.");
              }
              Event? thisEvent;
              if (snapshot.connectionState == ConnectionState.done) {
                if (!(snapshot.hasData && !snapshot.data!.exists) &&
                    snapshot.data != null) {
                  thisEvent = snapshot.data!.data();
                  updateEventId = thisEvent!.eventId;
                  thisEvent.invited.forEach((uid) async {
                    var userInfo = await Provider.of<UserController>(context,
                            listen: false)
                        .getAppUserInfo(uid);
                    invitedList.add(userInfo.data()!.email);
                  });
                }
                return Column(
                  children: <Widget>[
                    FormBuilder(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Column(
                        children: <Widget>[
                          _eventImageBanner(),
                          SizedBox(height: 10),
                          isEdit
                              ? FormBuilderChoiceChip<int>(
                                  decoration: InputDecoration(
                                    labelText: 'Selecione uma op????o',
                                  ),
                                  name: 'event_type',
                                  alignment: WrapAlignment.spaceEvenly,
                                  initialValue: 0,
                                  selectedColor: Theme.of(context).primaryColor,
                                  options: [
                                    FormBuilderFieldOption(
                                        value: 0,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.work),
                                            Text(
                                              '  Trabalho',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            )
                                          ],
                                        )),
                                    FormBuilderFieldOption(
                                        value: 1,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.beach_access),
                                            Text(
                                              '  Lazer',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            )
                                          ],
                                        )),
                                  ],
                                  focusNode: eventTypeFocusNode,
                                )
                              : SizedBox(),
                          SizedBox(height: 10),
                          FormBuilderTextField(
                            focusNode: nameFocusNode,
                            name: 'name',
                            decoration: InputDecoration(
                              labelText: 'Nome do Evento',
                              prefixIcon: Icon(Icons.short_text_outlined),
                              border: OutlineInputBorder(),
                            ),
                            validator: FormBuilderValidators.required(context,
                                errorText: 'Campo Obrigat??rio'),
                            initialValue:
                                thisEvent == null ? null : thisEvent.name,
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(height: 10),
                          FormBuilderTextField(
                              focusNode: adressFocusNode,
                              name: 'local',
                              decoration: InputDecoration(
                                labelText: 'Endere??o',
                                prefixIcon: Icon(Icons.location_on_sharp),
                                border: OutlineInputBorder(),
                              ),
                              validator: FormBuilderValidators.required(context,
                                  errorText: 'Campo Obrigat??rio'),
                              initialValue:
                                  thisEvent == null ? null : thisEvent.location,
                              textInputAction: TextInputAction.next),
                          SizedBox(height: 10),
                          SafeArea(
                            child: FormBuilderDateRangePicker(
                                focusNode: dateIntervalFocusNode,
                                name: 'date_range',
                                firstDate: DateTime.now(),
                                lastDate: DateTime(DateTime.now().year + 1),
                                format: DateFormat('dd-MM-yyyy'),
                                onChanged: _onChanged,
                                enabled: isEdit,
                                decoration: InputDecoration(
                                  labelText: 'Intervalo de Data',
                                  helperText: '*Intervalo m??ximo de 6 meses',
                                  prefixIcon: Icon(Icons.date_range),
                                  hintText: 'Selecione o per??odo',
                                  border: OutlineInputBorder(),
                                ),
                                validator: FormBuilderValidators.required(
                                    context,
                                    errorText: 'Campo Obrigat??rio'),
                                initialValue: thisEvent == null
                                    ? null
                                    : DateTimeRange(
                                        start: thisEvent.dateIni,
                                        end: thisEvent.dateEnd),
                                textInputAction: TextInputAction.next),
                          ),
                          SizedBox(height: 10),
                          FormBuilderTextField(
                              focusNode: descriptionFocusNode,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              name: 'description',
                              decoration: const InputDecoration(
                                labelText: 'Descri????o',
                                prefixIcon: Icon(Icons.short_text_outlined),
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 30.0),
                                border: OutlineInputBorder(),
                                helperText: '*m??ximo de 500 caracteres',
                              ),
                              onChanged: _onChanged,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context,
                                    errorText: 'Campo Obrigat??rio'),
                                FormBuilderValidators.max(context, 500,
                                    errorText: 'M??ximo de 500 caracteres'),
                              ]),
                              initialValue: thisEvent == null
                                  ? null
                                  : thisEvent.description,
                              textInputAction: TextInputAction.next),
                          GroupInviteModal(invitedList),
                          SizedBox(height: 10),
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
                            child: isEdit
                                ? ElevatedButton(
                                    child: Text("Enviar"),
                                    onPressed: () {
                                      _formKey.currentState!.save();
                                      if (_formKey.currentState!.validate()) {
                                        _submit();
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              "Houve um erro ao enviar o formul??rio. Tente novamente mais tarde."),
                                        ));
                                      }
                                    },
                                  )
                                : ElevatedButton(
                                    child: Text("Salvar Altera????es"),
                                    onPressed: () {
                                      _formKey.currentState!.save();
                                      if (_formKey.currentState!.validate()) {
                                        _submit();
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              "Houve um erro ao enviar o formul??rio. Tente novamente mais tarde."),
                                        ));
                                      }
                                    },
                                  ),
                          ),
                          SizedBox(width: 20),
                          isEdit
                              ? Expanded(
                                  child: OutlinedButton(
                                    child: Text("Limpar"),
                                    onPressed: () {
                                      _formKey.currentState!.reset();
                                    },
                                  ),
                                )
                              : SizedBox(),
                          isEdit ? SizedBox(width: 10) : SizedBox(),
                        ],
                      )
                  ],
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
