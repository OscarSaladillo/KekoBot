import 'package:chat_bot/SharedPreferences/remember_user.dart';
import 'package:flutter/cupertino.dart';

class FormProvider with ChangeNotifier {
  bool _loginPasswordVisible = true,
      _registerPasswordVisible = true,
      _registerConfirmPasswordVisible = true,
      _emailInUse = false,
      _rememberUser = false;
  String _errorLogin = "", _errorRegister = "";
  final RememberUser _savedLogin = RememberUser();

  bool get loginPasswordVisible => _loginPasswordVisible;
  bool get registerPasswordVisible => _registerPasswordVisible;
  bool get registerConfirmPasswordVisible => _registerConfirmPasswordVisible;
  bool get emailInUse => _emailInUse;
  bool get rememberUser => _rememberUser;
  String get errorLogin => _errorLogin;
  String get errorRegister => _errorRegister;
  RememberUser get savedLogin => _savedLogin;

  changeRememberUser() {
    _rememberUser = !_rememberUser;
    notifyListeners();
  }

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
