import 'dart:convert';

import 'dart:typed_data';

class ChatModel {
  String id, name, description, owner;
  Uint8List avatar;
  bool isMP;
  List<dynamic> users, mods;
  ChatModel(
      {required this.id,
      required this.owner,
      required this.name,
      required this.avatar,
      required this.isMP,
      required this.description,
      required this.mods,
      required this.users});

  factory ChatModel.fromJson(Map<String, Object?> jsonMap, String id) {
    return ChatModel(
        id: id,
        owner: jsonMap["owner"] as String,
        name: jsonMap["name"] as String,
        avatar: base64.decode(jsonMap["avatar"] as String),
        isMP: jsonMap["isMP"] as bool,
        description: jsonMap["description"] as String,
        mods: jsonMap["mods"] as List<dynamic>,
        users: jsonMap["users"] as List<dynamic>);
  }
}
