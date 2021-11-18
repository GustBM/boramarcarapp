import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import 'package:boramarcarapp/widgets/app_drawer.dart';
import 'package:boramarcarapp/models/user.dart';
import 'package:boramarcarapp/controllers/users_controller.dart';

import '../../utils.dart';

class EditUserInfoScreen extends StatefulWidget {
  static const routeName = '/edit-user';

  @override
  _EditUserInfoScreenState createState() => _EditUserInfoScreenState();
}

class _EditUserInfoScreenState extends State<EditUserInfoScreen> {
  final GlobalKey<FormBuilderState> _schedueleFormKey =
      GlobalKey<FormBuilderState>();
  final User? _userInfo = FirebaseAuth.instance.currentUser;
  var _isLoading = false;
  XFile? _imgFile;
  final ImagePicker _imgPicker = ImagePicker();
  var maskFormatter = new MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

  Future<void> _submit(List<String> invitedList) async {
    var message = 'Atualizado com Sucesso!';

    if (!_schedueleFormKey.currentState!.validate()) {
      return;
    }
    _schedueleFormKey.currentState!.save();

    final String name = _schedueleFormKey.currentState!.value['name'];
    final String email = _schedueleFormKey.currentState!.value['email'];
    final String lastName = _schedueleFormKey.currentState!.value['lastName'];
    final String bthDate = _schedueleFormKey.currentState!.value['bthDate'];

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
      await FirebaseAuth.instance.currentUser!.updateEmail(email);
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage
          .ref()
          .child("profile_picture")
          .child('prof_pic_' + FirebaseAuth.instance.currentUser!.uid);
      if (_imgFile != null) {
        ref.putFile(File(_imgFile!.path)).then((storageTask) async {
          String link = await storageTask.ref.getDownloadURL();
          await FirebaseAuth.instance.currentUser!.updatePhotoURL(link);
        });
      }
      await Provider.of<UserController>(context, listen: false)
          .addAndUpdateAppUser(
              _userInfo!.uid,
              AppUser(
                  uid: _userInfo!.uid,
                  firstName: name,
                  email: email,
                  bthDate: bthDate,
                  lastName: lastName,
                  invited: invitedList));
    } catch (e) {
      message = "Falha na atualização!\n" + e.toString();
      setState(() {
        _isLoading = false;
      });
    }
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  Widget _imageProfile() {
    final profilePicture = FirebaseAuth.instance.currentUser!.photoURL;
    return Stack(
      children: [
        CircleAvatar(
            radius: 80.0,
            backgroundImage: _imgFile == null
                ? profilePicture == null
                    ? Image.asset('assets/images/standard_user_photo.png').image
                    : Image.network(profilePicture).image
                : FileImage(File(_imgFile!.path))),
        Positioned(
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: ((builder) => _photoOptionBottomSheet()));
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.teal,
              size: 28.0,
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
      appBar: AppBar(
        title: Text('Editar'),
        automaticallyImplyLeading: true,
      ),
      // drawer: AppDrawer(),
      body: FutureBuilder(
          future: Provider.of<UserController>(context, listen: false)
              .getAppUserInfo(_userInfo!.uid),
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot<AppUser>> snapshot) {
            if (snapshot.hasError) {
              return SnapshotErroMsg(
                  'Houve um erro ao buscar os seus dados.\nTente novamente mais tarde.');
            }

            AppUser? userInfo;
            if (snapshot.connectionState == ConnectionState.done) {
              if (!(snapshot.hasData && !snapshot.data!.exists)) {
                userInfo = snapshot.data!.data();
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        _imageProfile(),
                        FormBuilder(
                          key: _schedueleFormKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              FormBuilderTextField(
                                name: 'name',
                                decoration: InputDecoration(
                                  labelText: 'Nome',
                                  prefixIcon: Icon(Icons.short_text_outlined),
                                  border: OutlineInputBorder(),
                                ),
                                validator: FormBuilderValidators.required(
                                    context,
                                    errorText: 'Campo Obrigatório'),
                                initialValue: _userInfo!.displayName,
                              ),
                              SizedBox(height: 10),
                              FormBuilderTextField(
                                name: 'lastName',
                                decoration: InputDecoration(
                                  labelText: 'Sobrenome',
                                  prefixIcon: Icon(Icons.short_text_outlined),
                                  border: OutlineInputBorder(),
                                ),
                                validator: FormBuilderValidators.required(
                                    context,
                                    errorText: 'Campo Obrigatório'),
                                initialValue: userInfo!.lastName,
                              ),
                              SizedBox(height: 10),
                              FormBuilderTextField(
                                enabled: false,
                                name: 'email',
                                decoration: InputDecoration(
                                  labelText: 'E-mail',
                                  prefixIcon: Icon(Icons.short_text_outlined),
                                  border: OutlineInputBorder(),
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(context,
                                      errorText: 'Campo Obrigatório'),
                                  FormBuilderValidators.email(context,
                                      errorText: 'Formato do e-mail inválido')
                                ]),
                                initialValue: userInfo.email,
                              ),
                              SizedBox(height: 10),
                              FormBuilderTextField(
                                name: 'bthDate',
                                keyboardType: TextInputType.datetime,
                                inputFormatters: [maskFormatter],
                                decoration: InputDecoration(
                                  labelText: 'Data de Nascimento',
                                  prefixIcon: Icon(Icons.short_text_outlined),
                                  border: OutlineInputBorder(),
                                ),
                                validator: FormBuilderValidators.required(
                                    context,
                                    errorText: 'Campo Obrigatório'),
                                initialValue: userInfo.bthDate,
                              ),
                              SizedBox(height: 20)
                            ],
                          ),
                        ),
                        if (_isLoading)
                          CircularProgressIndicator()
                        else
                          Row(
                            children: [
                              SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  child: Text("Salvar Alterações"),
                                  onPressed: () {
                                    _schedueleFormKey.currentState!.save();
                                    if (_schedueleFormKey.currentState!
                                        .validate()) {
                                      _submit(userInfo!.invited);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "Houve um erro ao enviar o formulário. Tente novamente mais tarde."),
                                      ));
                                    }
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
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
