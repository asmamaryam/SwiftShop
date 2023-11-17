// ignore_for_file: unused_field, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'dart:async';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token = "";
  DateTime _expriydate = DateTime.now();
  String _userId = "";
  Timer _authtimer = Timer(Duration(seconds: 0), () {});

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expriydate != null &&
        _expriydate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    } else {
      return null;
    }
  }

  // getter for user favouite
  String get userId {
    return _userId;
  }

  Future<void> _authentiication(
      String email, String passward, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBujKAA-hHqknFon3lzG89ZVQU_bhCyn-I');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': passward,
            'returnSecureToken': true,
          },
        ),
      );
      final responsedata = json.decode(response.body);
      if (responsedata['error'] != null) {
        throw HttpException(responsedata['error']['message']);
      }
      _token = responsedata['idToken'];
      _userId = responsedata['localId'];
      _expriydate = DateTime.now().add(
        Duration(
          seconds: int.parse(responsedata['expiresIn']),
        ),
      );
      _autoLogout();
      // converted data for automatically logging
      final prefs = await SharedPreferences.getInstance();
      final userdata = json.encode({
        'token': _token,
        'userId': _userId,
        'expirydate': _expriydate.toIso8601String(),
      });
      // data store in prefs
      prefs.setString('userdata', userdata);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String passward) async {
    return _authentiication(
      email,
      passward,
      'signUp',
    );
  }

  Future<void> logIn(String email, String passward) async {
    return _authentiication(
      email,
      passward,
      'signInWithPassword',
    );
  }

  // function to retreive data from prefs
  Future<bool> tryAutologin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userdata')) {
      return false;
    }
    final getextracedData =
        json.decode(prefs.getString('userdata')!) as Map<String, dynamic>;
    // by past date check if token is expire
    final expireydate = DateTime.parse(getextracedData['expirydate']);
    if (expireydate.isBefore(DateTime.now())) {
      return false;
    }
    _token = getextracedData['token'];
    _userId = getextracedData['userId'];
    _expriydate = expireydate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  // void logout() {
  //   _token = null;
  //   _userId = "";
  //   _expriydate = null;
  //   if (_authtimer != null) {
  //     _authtimer.cancel();
  //     _authtimer = null;
  //   }
  //   notifyListeners();
  // }
  // Future<void> logout() async {
  //   _token = "";
  //   _userId = "";
  //   _expriydate = "" as DateTime;
  //   _authtimer.cancel();
  //   _authtimer = "" as Timer;
  //   notifyListeners();
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.clear();
  // }

  // void _autoLogout() {
  //   // if (_authtimer != null) {
  //   //   _authtimer.cancel();
  //   // }
  //   final timeToExpiry = _expriydate.difference(DateTime.now()).inSeconds;
  //   _authtimer = Timer(Duration(seconds: timeToExpiry), logout);
  // }
  Future<void> logout() async {
    _token = "";
    _userId = "";
    _expriydate = DateTime
        .now(); // Reset _expriydate to the current time or an appropriate default value
    _authtimer.cancel();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authtimer.isActive) {
      _authtimer.cancel();
    }
    final timeToExpiry = _expriydate.difference(DateTime.now()).inSeconds;
    _authtimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
