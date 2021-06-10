import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:boramarcarapp/models/http_exception.dart';
// import 'package:boramarcarapp/models/user.dart';
import 'package:flutter/widgets.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

class Auth with ChangeNotifier {
  String _token;
  String _refreshToken;
  // AuthCredential _authCredential;
  User _userData;

  bool get isAuth {
    return _token != null;
  }

  String get token {
    if (_token != null) return _token;
    return null;
  }

  User get getUser {
    return _userData;
  }

  Future<void> _authenticate(String email, String password) async {
    // ignore: unused_local_variable
    UserCredential user;

    try {
      user = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      // authProblems errorType;
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          // errorType = authProblems.UserNotFound;
          throw HttpException('E-mail não encontrado.');
          break;
        case 'The password is invalid or the user does not have a password.':
          // errorType = authProblems.PasswordNotValid;
          throw HttpException('Senha Inválida.');
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          // errorType = authProblems.NetworkError;
          throw HttpException(
              'Erro de Conexão. Verifique sua conexão e tente novamente.');
          break;
        case 'The custom token format is incorrect.':
          break;
        default:
          throw HttpException(e.message);
      }
    }
    _userData = FirebaseAuth.instance.currentUser;
    // _authCredential = user.credential;
    _refreshToken = _userData.refreshToken;
    _token = await _userData.getIdToken();

    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode(
      {'token': _token, 'refreshToken': _refreshToken},
    );
    prefs.setString('userData', userData);
    notifyListeners();
  }

  Future<void> _authenticateWIthToken(String token) async {
    // ignore: unused_local_variable
    UserCredential user;

    try {
      // FirebaseAuth.instance.si
      if (token != null)
        user = await FirebaseAuth.instance.signInWithCustomToken(_refreshToken);
    } catch (e) {
      // authProblems errorType;
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          // errorType = authProblems.UserNotFound;
          throw HttpException('E-mail não encontrado.');
          break;
        case 'The password is invalid or the user does not have a password.':
          // errorType = authProblems.PasswordNotValid;
          throw HttpException('Senha Inválida.');
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          // errorType = authProblems.NetworkError;
          throw HttpException(
              'Erro de Conexão. Verifique sua conexão e tente novamente.');
          break;
        case 'The custom token format is incorrect.':
          break;
        default:
          throw HttpException(e.message);
      }
    }
    _userData = FirebaseAuth.instance.currentUser;
    // _authCredential = user.credential;
    _token = await _userData.getIdToken();
    _refreshToken = _userData.refreshToken;

    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode(
      {'token': _token, 'refreshToken': _refreshToken},
    );
    prefs.setString('userData', userData);
    notifyListeners();
  }

  Future<void> signUp(String email, String password) async {
    UserCredential userCredential;

    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw HttpException(e.message);
    } catch (e) {
      throw HttpException(e.message);
    }
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password);
  }

  Future<void> logout() async {
    _token = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  /*Future<bool> tryAutoAuth() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    print(FirebaseAuth.instance.currentUser);
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    _token = extractedUserData['token'];
    _authCredential = extractedUserData['userEmail'];

    if (_token == null || _authCredential == null) return false;

    _authenticateWIthToken(_authCredential);
    if (_userData != null) return true;
    return false;
  }*/

  Future<bool> tryAutoAuth() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    _token = extractedUserData['token'];
    _refreshToken = extractedUserData['refreshToken'];

    if (_refreshToken != null) return false;

    _authenticateWIthToken(_refreshToken);
    if (_userData != null) return true;
    return false;
  }
}
