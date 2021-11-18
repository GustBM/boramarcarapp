import 'dart:io';

import 'package:boramarcarapp/controllers/groups_controller.dart';
import 'package:boramarcarapp/widgets/event/event_invite_modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:boramarcarapp/models/group.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../utils.dart';

class NewGroupScreen extends StatefulWidget {
  static const routeName = '/new-group';

  @override
  _NewGroupScreenState createState() => _NewGroupScreenState();
}

class _NewGroupScreenState extends State<NewGroupScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  XFile? _imgFile;
  final ImagePicker _imgPicker = ImagePicker();
  String? groupPicture;
  final User? _user = FirebaseAuth.instance.currentUser;
  var _isLoading = false;

  List<String> invitedList = [];

  Widget _imageProfile() {
    return Stack(
      children: [
        CircleAvatar(
            radius: 80.0,
            backgroundImage: _imgFile == null
                ? groupPicture == null
                    ? Image.asset('assets/images/standard_user_photo.png').image
                    : Image.network(groupPicture!).image
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    final String groupName = _formKey.currentState!.value['name'];
    final String groupDescription = _formKey.currentState!.value['description'];

    try {
      Provider.of<GroupController>(context, listen: false).addNewGroup(
          context,
          Group(
              groupId: getRandomString(20),
              name: groupName,
              groupAdmin: _user!.uid,
              description: groupDescription,
              imageUrl: groupPicture,
              groupMembers: invitedList));
    } on HttpException catch (e) {
      var errMessage = "Erro \n${e.toString()}";
      showErrorDialog(context, errMessage);
      setState(() {
        _isLoading = false;
      });
      return;
    } catch (e) {
      var errMessage = "Houve um erro ao criar novo grupo. Tente novamente.";
      print(e.toString());
      showErrorDialog(context, errMessage);
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
      appBar: AppBar(
        title: Text('Novo Grupo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _imageProfile(),
                FormBuilder(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        name: 'name',
                        decoration: InputDecoration(
                          labelText: 'Nome do Grupo',
                          prefixIcon: Icon(Icons.short_text_outlined),
                          border: OutlineInputBorder(),
                        ),
                        validator: FormBuilderValidators.required(context,
                            errorText: 'Campo Obrigatório'),
                        // initialValue: _userInfo!.displayName,
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
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context,
                              errorText: 'Campo Obrigatório'),
                          FormBuilderValidators.max(context, 500,
                              errorText: 'Máximo de 500 caracteres'),
                        ]),
                      ),
                      SizedBox(height: 10),
                      EventInviteModal(invitedList),
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
                          child: Text(
                            "Criar Grupo",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            _formKey.currentState!.save();
                            if (_formKey.currentState!.validate()) {
                              _submit();
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
      ),
    );
  }
}
