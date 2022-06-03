import 'package:flutter/cupertino.dart';

import '../Models/chat_model.dart';

class SearchProvider with ChangeNotifier {
  String _input = "";

  String get input => _input;

  void changeInput(String input) {
    _input = input;
    notifyListeners();
  }
}
