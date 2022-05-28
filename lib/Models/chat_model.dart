class ChatModel {
  String id, name, avatar;
  bool isMP;
  ChatModel(
      {required this.id,
      required this.name,
      required this.avatar,
      required this.isMP});

  factory ChatModel.fromJson(Map<String, Object?> jsonMap, String id) {
    return ChatModel(
        id: id,
        name: jsonMap["name"] as String,
        avatar: jsonMap["avatar"] as String,
        isMP: jsonMap["isMP"] as bool);
  }
}
