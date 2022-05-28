import 'package:flutter/cupertino.dart';

import '../Models/chat_model.dart';

class ChatProvider with ChangeNotifier {
  ChatModel? _selectedChat;

  ChatModel? get selectedChat => _selectedChat;

  setSelectedChat(ChatModel? chat) {
    _selectedChat = chat;
    notifyListeners();
  }

  modifySelectedChat(String name, String avatar, bool isMP) {
    _selectedChat?.name = name;
    _selectedChat?.avatar = avatar;
    _selectedChat?.isMP = isMP;
    notifyListeners();
  }
}
