import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import 'package:boramarcarapp/models/http_exception.dart';
import 'package:boramarcarapp/models/user.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

class Auth with ChangeNotifier {
  String _token;
  User _userData;
  AppUser _userInfo;

  bool get isAuth {
    if (FirebaseAuth.instance.currentUser != null) {
      setUserInfo(FirebaseAuth.instance.currentUser.uid);
      return true;
    }
    return false;
  }

  String get token {
    if (_token != null) return _token;
    return null;
  }

  User get getUser {
    return _userData;
  }

  AppUser get getUserInfo {
    return _userInfo;
  }

  Future<void> _authenticate(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (error) {
      switch (error.code) {
        case "invalid-email":
          throw HttpException("E-mail inválido.");
          break;
        case "wrong-password":
          throw HttpException("Senha Incorreta");
          break;
        case "user-not-found":
          throw HttpException("E-mail não encontrado.");
          break;
        case "user-disabled":
          throw HttpException("Usuário desabilitado.");
          break;
        default:
          throw HttpException("Houve um erro!\n" + error.code.toString());
      }
    }
    _userData = FirebaseAuth.instance.currentUser;
    setUserInfo(_userData.uid);
    notifyListeners();
  }

  Future<void> signUp(String email, String password, String name,
      String lastname, String date) async {
    UserCredential user;
    try {
      user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw HttpException(
            "Senha muito considerada fraca. Tente novamente com outra.");
      } else if (e.code == 'email-already-in-use') {
        throw HttpException("Já existe um usuário com este e-mail.");
      }
    } catch (e) {
      throw HttpException("Houve um Erro!" + e.code.toString());
    }

    await FirebaseFirestore.instance
        .collection('user')
        .doc(user.user.uid)
        .set({
          'firstName': name,
          'lastName': lastname,
          'bthDate': date,
          'email': email,
          'schedule': null,
        })
        .then((value) => _authenticate(email, password))
        .catchError(
            (e) => throw HttpException("Houve um Erro!" + e.code.toString()));
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password);
  }

  Future<void> logout() async {
    _token = null;
    _userInfo = null;
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  Future<bool> setUserInfo(String uid) async {
    try {
      var snapshot =
          await FirebaseFirestore.instance.collection('user').doc(uid).get();
      var data = snapshot.data();
      _userInfo = new AppUser(
        firstName: data['firstName'],
        lastName: data['lastName'],
        email: data['email'],
        bthDate: data['bthDate'],
      );
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> tryAutoAuth() async {
    if (FirebaseAuth.instance.currentUser != null) {
      return true;
    } else
      return false;
  }
}