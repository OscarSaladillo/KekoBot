import 'package:shared_preferences/shared_preferences.dart';

class RememberUser {
  SharedPreferences? prefs;
  String? email, password;
  Future<String?> initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    email = prefs!.getString("email") ?? "";
    password = prefs!.getString("password") ?? "";
    return email;
  }

  String? get getEmail => email;
  String? get getPassword => password;

  void savedLogin(String email, String password) {
    prefs!.setString("email", email);
    prefs!.setString("password", password);
  }

  void logout() {
    prefs!.setString("email", "");
    prefs!.setString("password", "");
  }
}
