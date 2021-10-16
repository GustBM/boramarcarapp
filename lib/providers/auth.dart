import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:boramarcarapp/models/http_exception.dart';
import 'package:boramarcarapp/models/user.dart';

class Auth with ChangeNotifier {
  late User _userData;
  late AppUser _userInfo;

  final _auth = FirebaseAuth.instance;

  bool get isAuth {
    if (_auth.currentUser != null) {
      return true;
    }
    return false;
  }

  User get getUser {
    return _userData;
  }

  Future<void> _authenticate(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          throw HttpException("E-mail inválido.");

        case "wrong-password":
          throw HttpException("Senha Incorreta");

        case "user-not-found":
          throw HttpException("E-mail não encontrado.");

        case "user-disabled":
          throw HttpException("Usuário desabilitado.");

        default:
          throw HttpException(
              "[" + error.code + "]" + "Houve um erro!\n" + error.toString());
      }
    }
    _userData = _auth.currentUser!;
    setUserInfo(_userData.uid);
    notifyListeners();
  }

  Future<void> signUp(String email, String password, String name,
      String lastname, String date) async {
    UserCredential? user;
    try {
      user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw HttpException(
            "Senha considerada muito fraca. Tente novamente com numeros, simbolos e letras maiusculas.");
      } else if (e.code == 'email-already-in-use') {
        throw HttpException("Já existe um usuário com este e-mail.");
      }
    } catch (e) {
      throw HttpException("Houve um Erro!" + e.toString());
    }

    User userResult = user!.user!;
    await userResult.updateDisplayName(name);
    await userResult.sendEmailVerification();
    await addNewUserSchedule(userResult.uid);

    await FirebaseFirestore.instance
        .collection('user')
        .doc(userResult.uid)
        .set({
      'firstName': name,
      'lastName': lastname,
      'bthDate': date,
      'email': email,
      'invited': null
    }).then((value) {
      _authenticate(email, password);
    }).catchError(
            (e) => throw HttpException("Houve um Erro!" + e.code.toString()));
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password);
  }

  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }

  Future<bool> setUserInfo(String uid) async {
    try {
      var snapshot =
          await FirebaseFirestore.instance.collection('user').doc(uid).get();
      var data = snapshot.data();
      _userInfo = new AppUser(
        firstName: data!['firstName'],
        lastName: data['lastName'],
        email: data['email'],
        bthDate: data['bthDate'],
      );
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<void> resetPwd(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e);
    }
  }

  void _registerUserInfo(String userId, String? name, String? lastname,
      String? date, String? email) async {
    var userRef = FirebaseFirestore.instance.collection('user').doc(userId);
    userRef.get().then((docSnapshot) => {
          if (!docSnapshot.exists)
            {
              userRef.set({
                'firstName': name,
                'lastName': lastname,
                'bthDate': date,
                'email': email,
                'invited': null
              })
            }
        });
  }

  Future<void> signInWithGoogle() async {
    var credential;
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Create a new credential
      credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      _userData = _auth.currentUser!;
      _registerUserInfo(
          _userData.uid, _userData.displayName, '', null, _userData.email);
      setUserInfo(_userData.uid);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "account-exists-with-different-credential":
          throw HttpException(
              "Este e-mail já está cadastrado com outro método.");

        case "invalid-credential":
          throw HttpException("Modo de Acesso Inválido.");

        case "operation-not-allowed":
          throw HttpException("Operação Inválida. Tente outro tipo de acesso.");

        case "wrong-password":
          throw HttpException("Senha do Modo de Acesso Inválido");

        case "invalid-verification-code":
          throw HttpException("Erro no Código de Validação.");

        case "invalid-verification-id":
          throw HttpException("Erro no ID de Validação.");

        case "user-not-found":
          throw HttpException("E-mail não encontrado.");

        case "user-disabled":
          throw HttpException("Usuário Bloqueado.");

        default:
          throw HttpException("Houve um erro!\n" + e.toString());
      }
    } catch (e) {
      print(e.toString());
      throw HttpException("Houve um erro!\n" + e.toString());
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      final fbLoginResult = await FacebookAuth.instance.login();
      // final userData = await FacebookAuth.instance.getUserData();

      final fbAuthCredential =
          FacebookAuthProvider.credential(fbLoginResult.accessToken!.token);
      await _auth.signInWithCredential(fbAuthCredential);

      _userData = _auth.currentUser!;
      _registerUserInfo(
          _userData.uid, _userData.displayName, '', null, _userData.email);
      setUserInfo(_userData.uid);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "account-exists-with-different-credential":
          throw HttpException(
              "Este e-mail já está cadastrado com outro método.");

        case "invalid-credential":
          throw HttpException("Modo de Acesso Inválido.");

        case "operation-not-allowed":
          throw HttpException("Operação Inválida. Tente outro tipo de acesso.");

        case "wrong-password":
          throw HttpException("Senha do Modo de Acesso Inválido");

        case "invalid-verification-code":
          throw HttpException("Erro no Código de Validação.");

        case "invalid-verification-id":
          throw HttpException("Erro no ID de Validação.");

        case "user-not-found":
          throw HttpException("E-mail não encontrado.");

        case "user-disabled":
          throw HttpException("Usuário Bloqueado.");

        default:
          throw HttpException("Houve um erro!\n" + e.toString());
      }
    } catch (e) {
      print(e);
    }
  }

  // TODO: ISSO TÁ ERRADO, CORRIGIR A QUEBRA DO FLUXO DE DADOS!
  Future<void> addNewUserSchedule(String userId) async {
    FirebaseFirestore.instance.collection('schedule').doc(userId).set({
      'sundayIni': 6,
      'sundayEnd': 18,
      'sundayCheck': true,
      'mondayIni': 6,
      'mondayEnd': 18,
      'mondayCheck': true,
      'tuesdayIni': 6,
      'tuesdayEnd': 18,
      'tuesdayCheck': true,
      'wednesdayIni': 6,
      'wednesdayEnd': 18,
      'wednesdayCheck': true,
      'thursdayIni': 6,
      'thursdayEnd': 18,
      'thursdayCheck': true,
      'fridayIni': 6,
      'fridayEnd': 18,
      'fridayCheck': true,
      'saturdayIni': 6,
      'saturdayEnd': 18,
      'saturdayCheck': true,
    });
  }
}
