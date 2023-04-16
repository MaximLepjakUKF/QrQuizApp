import 'package:flutter/material.dart';

class AuthenticationViewModel with ChangeNotifier {

  bool _obsecurePassword = true;

  bool get obsecurePassword => _obsecurePassword;

  set obsecurePassword(bool value) {
    _obsecurePassword = value;
    notifyListeners();
  }
}
