class ChatModel {
  String id, name, avatar;
  bool isMP;
  List<dynamic> users;
  ChatModel(
      {required this.id,
      required this.name,
      required this.avatar,
      required this.isMP,
      required this.users});

  factory ChatModel.fromJson(Map<String, Object?> jsonMap, String id) {
    return ChatModel(
        id: id,
        name: jsonMap["name"] as String,
        avatar: jsonMap["avatar"] as String,
        isMP: jsonMap["isMP"] as bool,
        users: jsonMap["users"] as List<dynamic>);
  }
}
