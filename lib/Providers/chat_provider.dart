import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

import '../Models/chat_model.dart';

class ChatProvider with ChangeNotifier {
  ChatModel? _selectedChat;
  ImageProvider? _image;
  Uint8List? _avatar;
  bool _existChat = true;

  ImageProvider? get image => _image;
  Uint8List? get avatar => _avatar;
  ChatModel? get selectedChat => _selectedChat;
  bool get existChat => _existChat;

  changeExistChat() {
    _existChat = !_existChat;
    notifyListeners();
  }

  setImage(ImageProvider? image) {
    _image = image;
    notifyListeners();
  }

  setSelectedChat(ChatModel? chat) {
    _selectedChat = chat;
    notifyListeners();
  }

  modifySelectedChat(String name, String avatar) {
    _selectedChat?.name = name;
    _selectedChat?.avatar = base64.decode(avatar);
    notifyListeners();
  }

  setAvatar(String? avatar) {
    _avatar = base64.decode(avatar!);
    notifyListeners();
  }

  setAvatarFromNewChat() {
    _avatar = Uint8List(1);
    notifyListeners();
  }
}
