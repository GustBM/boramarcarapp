import 'dart:math';

import 'package:boramarcarapp/widgets/auth/auth_buttons.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:boramarcarapp/models/http_exception.dart';
import 'package:boramarcarapp/providers/auth.dart';

import '../utils.dart' show showErrorDialog, isValidEmail;

enum AuthMode { Signup, Login, ForgotPwd }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(255, 191, 0, 1).withOpacity(0.5),
                  Color.fromRGBO(154, 206, 235, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 54.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-6.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'BoraMarcar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  AuthCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'name': '',
    'date': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  Future<void> _forgotPwd() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }

    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Auth>(context, listen: false)
          .resetPwd(_authData['email']!);
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      _isLoading = false;
      _authMode = AuthMode.Login;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email']!, _authData['password']!);
      } else {
        await Provider.of<Auth>(context, listen: false).signUp(
          _authData['email']!,
          _authData['password']!,
          _authData['firstName']!,
          _authData['lastName']!,
          _authData['date']!,
        );
      }
    } on HttpException catch (e) {
      var errMessage = "Erro na autenticação\n${e.toString()}";
      showErrorDialog(context, errMessage);
    } catch (e) {
      var errMessage = "Falha na autenticação.\n" + e.toString();
      showErrorDialog(context, errMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode({bool fgtPwd = false}) {
    if (fgtPwd) {
      setState(() {
        _authMode = AuthMode.ForgotPwd;
      });
      return;
    }
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  var maskFormatter = new MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final cardSize = deviceSize.width * 0.75;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.ForgotPwd ? 230 : 420,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 400 : 230),
        width: cardSize,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !isValidEmail(value)) {
                      return 'Email inválido!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                if (_authMode != AuthMode.ForgotPwd)
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Senha'),
                    obscureText: true,
                    controller: _passwordController,
                    // ignore: missing_return
                    validator: (value) {
                      if (value!.isEmpty || value.length < 6) {
                        return 'Senha muito curta. Minimo 6 letras!';
                      }
                    },
                    onSaved: (value) {
                      _authData['password'] = value!;
                    },
                  ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(labelText: 'Confirmar Senha'),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        // ignore: missing_return
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Senha e confirmação não estão diferentes.';
                            }
                          }
                        : null,
                  ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(labelText: 'Nome'),
                    validator: _authMode == AuthMode.Signup
                        // ignore: missing_return
                        ? (value) {
                            if (value!.isEmpty) {
                              return 'Nome é Obrigatório';
                            }
                          }
                        : null,
                    onSaved: (value) {
                      _authData['firstName'] = value!;
                    },
                  ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(labelText: 'Sobrenome'),
                    validator: _authMode == AuthMode.Signup
                        // ignore: missing_return
                        ? (value) {
                            if (value!.isEmpty) {
                              return 'Sobrenome é Obrigatório';
                            }
                          }
                        : null,
                    onSaved: (value) {
                      _authData['lastName'] = value!;
                    },
                  ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    keyboardType: TextInputType.datetime,
                    inputFormatters: [maskFormatter],
                    decoration:
                        InputDecoration(labelText: 'Data de Nascimento'),
                    validator: _authMode == AuthMode.Signup
                        // ignore: missing_return
                        ? (value) {
                            if (value!.isEmpty) {
                              return 'Data de Nascimento é Obrigatório';
                            }
                          }
                        : null,
                    onSaved: (value) {
                      _authData['date'] = value!;
                    },
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else if (_authMode != AuthMode.ForgotPwd)
                  ElevatedButton(
                    child: Text(
                        _authMode == AuthMode.Login ? 'LOGIN' : 'NOVO USUÁRIO'),
                    onPressed: () {
                      _submit();
                      FocusScope.of(context).unfocus();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      primary: Theme.of(context).primaryColor,
                      textStyle: TextStyle(
                        color: Theme.of(context).primaryTextTheme.button?.color,
                      ),
                    ),
                  ),
                if (_authMode == AuthMode.ForgotPwd && !_isLoading)
                  ElevatedButton(
                    child: Text('ENVIAR'),
                    onPressed: _forgotPwd,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      primary: Theme.of(context).primaryColor,
                      textStyle: TextStyle(
                        color: Theme.of(context).primaryTextTheme.button?.color,
                      ),
                    ),
                  ),
                TextButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'NOVO USUÁRIO' : 'LOGIN'}'),
                  onPressed: _switchAuthMode,
                  style: TextButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
                _authMode == AuthMode.Login
                    ? TextButton(
                        onPressed: () {
                          _switchAuthMode(fgtPwd: true);
                        },
                        child: Text('ESQUECEU A SENHA?'),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 4),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          textStyle: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      )
                    : SizedBox(),
                _authMode != AuthMode.ForgotPwd
                    ? Column(
                        children: [
                          Divider(thickness: 1),
                          Text('Ou Acesse com'),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              SizedBox(width: cardSize / 5),
                              GoogleIconLoginButton(),
                              SizedBox(width: 40),
                              FacebookIconLoginButton(),
                              // SizedBox(width: deviceSize.width / 5),
                            ],
                          ),
                        ],
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
