import 'dart:convert';

import 'dart:typed_data';

class ChatModel {
  String id, name, description;
  Uint8List avatar;
  bool isMP;
  List<dynamic> users;
  ChatModel(
      {required this.id,
      required this.name,
      required this.avatar,
      required this.isMP,
      required this.description,
      required this.users});

  factory ChatModel.fromJson(Map<String, Object?> jsonMap, String id) {
    return ChatModel(
        id: id,
        name: jsonMap["name"] as String,
        avatar: base64.decode(jsonMap["avatar"] as String),
        isMP: jsonMap["isMP"] as bool,
        description: jsonMap["description"] as String,
        users: jsonMap["users"] as List<dynamic>);
  }
}
