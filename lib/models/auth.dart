import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:boramarcarapp/models/http_exception.dart';
import 'package:boramarcarapp/models/user.dart';
import 'package:flutter/widgets.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userMat;
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

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBpYE4-HlN8hgaeGNfUrVo2EYry7h2uiFQ';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userMat = responseData['localId'];
      /*_expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));*/
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {'token': _token, 'UserId': _userMat},
      );
      prefs.setString('userData', userData);
      // setUser(mat, _token!);
    } catch (e) {
      throw e;
    }
  }

  Future<void> signUp(String mat, String password) async {
    return _authenticate(mat, password, 'signUp');
  }

  Future<void> login(String mat, String password) async {
    return _authenticate(mat, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _token = null;
    _userMat = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<void> tryAutoAuth() async {
    return null;
  }
}
