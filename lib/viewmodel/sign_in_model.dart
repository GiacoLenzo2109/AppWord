import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignInModel extends ChangeNotifier {
  var _disposed = false;

  get title => _title;

  String _title = "LogIn";

  set title(value) {
    _title = value;
    notifyListeners();
  }

  get name => _name;

  String _name = "";

  set name(value) {
    _name = value;
    notifyListeners();
  }

  get surname => _surname;

  String _surname = "";

  set surname(value) {
    _surname = value;
    notifyListeners();
  }

  String get email => _email;

  String _email = "";

  set email(value) {
    _email = value;
    notifyListeners();
  }

  String get password => _password;

  String _password = "";

  set password(value) {
    _password = value;
    notifyListeners();
  }

  get isLogin => _isLogin;

  bool _isLogin = true;

  set isLogin(value) {
    _isLogin = value;
    notifyListeners();
  }

  get isVisible => _isVisible;

  bool _isVisible = false;

  set isVisible(value) {
    _isVisible = value;
    notifyListeners();
  }

  get isValidEmail => _isValid;

  bool _isValid = false;

  void validEmail(String input) {
    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(input)
        ? _isValid = true
        : _isValid = false;
    notifyListeners();
  }

  get isEmailVerified => _isEmailVerified;

  bool _isEmailVerified = false;

  void setVerifiedEmail(bool check) {
    _isEmailVerified = check;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}
