import 'package:flutter/cupertino.dart';

import '../Models/user_model.dart';

class SearchProvider with ChangeNotifier {
  String _input = "";
  int _usedHeight = 170;
  List<UserModel> _selectedUsers = [];

  String get input => _input;
  int get usedHeight => _usedHeight;
  List<UserModel> get selectedUsers => _selectedUsers;

  void resetAttributes() {
    _input = "";
    _usedHeight = 170;
    _selectedUsers = [];
    notifyListeners();
  }

  void addUser(UserModel user) {
    _selectedUsers.add(user);
    _selectedUsers = _selectedUsers.toSet().toList();
    notifyListeners();
  }

  void deleteUser(UserModel user) {
    _selectedUsers.remove(user);
    notifyListeners();
  }

  void incrementHeight(bool increment) {
    _usedHeight += (increment) ? 100 : -100;
    notifyListeners();
  }

  void changeInput(String input) {
    _input = input;
    notifyListeners();
  }
}
