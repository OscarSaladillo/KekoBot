import 'package:flutter/cupertino.dart';

class FormProvider with ChangeNotifier {
  bool _loginPasswordVisible = true,
      _registerPasswordVisible = true,
      _registerConfirmPasswordVisible = true,
      _emailInUse = false;
  String _errorLogin = "", _errorRegister = "";

  bool get loginPasswordVisible => _loginPasswordVisible;
  bool get registerPasswordVisible => _registerPasswordVisible;
  bool get registerConfirmPasswordVisible => _registerConfirmPasswordVisible;
  bool get emailInUse => _emailInUse;
  String get errorLogin => _errorLogin;
  String get errorRegister => _errorRegister;

  changeLoginPasswordVisible() {
    _loginPasswordVisible = !_loginPasswordVisible;
    notifyListeners();
  }

  changeRegisterPasswordVisible() {
    _registerPasswordVisible = !_registerPasswordVisible;
    notifyListeners();
  }

  changeRegisterConfirmPasswordVisible() {
    _registerConfirmPasswordVisible = !_registerConfirmPasswordVisible;
    notifyListeners();
  }

  changeEmailInUse() {
    _emailInUse = !_emailInUse;
    notifyListeners();
  }

  changeErrorLogin(String error) {
    _errorLogin = error;
    notifyListeners();
  }

  changeErrorRegister(String error) {
    _errorRegister = error;
    notifyListeners();
  }
}
