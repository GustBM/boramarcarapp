import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:boramarcarapp/models/http_exception.dart';
import 'package:boramarcarapp/models/user.dart';
import 'package:flutter/widgets.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userid;
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
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCy9f-Y2IaJx83ueK3084h_1TNIBebAfIQ';
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
      _userid = responseData['localId'];
      /*_expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));*/
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {'token': _token, 'UserId': _userid},
      );
      prefs.setString('userData', userData);
      // setUser(mat, _token!);
    } catch (e) {
      throw e;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _token = null;
    _userid = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<void> tryAutoAuth() async {
    return null;
  }
}
