import 'dart:convert';
import 'dart:typed_data';

class UserModel {
  String name, description, email, id;
  Uint8List avatar;
  int money;
  UserModel({
    required this.id,
    required this.name,
    required this.money,
    required this.email,
    required this.avatar,
    required this.description,
  });

  factory UserModel.fromJson(Map<String, Object?> jsonMap, String id) {
    return UserModel(
        id: id,
        name: jsonMap["username"] as String,
        money: jsonMap["money"] as int,
        avatar: base64.decode(jsonMap["avatar"] as String),
        email: jsonMap["email"] as String,
        description: jsonMap["description"] as String);
  }
}
