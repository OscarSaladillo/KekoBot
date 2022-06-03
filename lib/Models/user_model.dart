import 'dart:convert';
import 'dart:typed_data';

class UserModel {
  String name, description, email;
  Uint8List avatar;
  UserModel({
    required this.name,
    required this.email,
    required this.avatar,
    required this.description,
  });

  factory UserModel.fromJson(Map<String, Object?> jsonMap) {
    return UserModel(
        name: jsonMap["username"] as String,
        avatar: base64.decode(jsonMap["avatar"] as String),
        email: jsonMap["email"] as String,
        description: jsonMap["description"] as String);
  }
}
