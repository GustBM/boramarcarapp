import 'package:boramarcarapp/widgets/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

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

  Future<void> _submit() async {
    if (!_schedueleFormKey.currentState!.validate()) {
      return;
    }
    _schedueleFormKey.currentState!.save();

    final String name = _schedueleFormKey.currentState!.value['name'];
    final String email = _schedueleFormKey.currentState!.value['email'];

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
      await FirebaseAuth.instance.currentUser!.updateEmail(email);
    } catch (e) {
      var errMessage = "Falha no novo evento.\n" + e.toString();
      print(errMessage);
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
        title: Text('Editar'),
      ),
      drawer: AppDrawer(),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
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
                          validator: FormBuilderValidators.required(context,
                              errorText: 'Campo Obrigatório'),
                          initialValue: _userInfo!.displayName,
                        ),
                        SizedBox(height: 10),
                        FormBuilderTextField(
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
                          initialValue: _userInfo!.email,
                        ),
                        SizedBox(height: 20),
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
                          child: MaterialButton(
                            color: Theme.of(context).accentColor,
                            child: Text(
                              "Enviar",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              _schedueleFormKey.currentState!.save();
                              if (_schedueleFormKey.currentState!.validate()) {
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
          )),
    );
  }
}
