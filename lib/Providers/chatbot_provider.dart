import 'package:flutter/cupertino.dart';

class ChatBotProvider with ChangeNotifier {
  Widget _assistantWidget = Container();
  bool _isContainer = true;

  Widget get assistantWidget => _assistantWidget;
  bool get isContainer => _isContainer;

  void setWidget(Widget widget, bool isContainer) {
    _assistantWidget = widget;
    _isContainer = isContainer;
    notifyListeners();
  }
}
