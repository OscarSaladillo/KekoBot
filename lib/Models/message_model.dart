import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String id, email, text, chatRoom;
  Timestamp date;
  MessageModel(
      {required this.id,
      required this.email,
      required this.text,
      required this.chatRoom,
      required this.date});

  factory MessageModel.fromJson(Map<String, Object?> jsonMap, String id) {
    return MessageModel(
        id: id,
        email: jsonMap["email"] as String,
        text: jsonMap["text"] as String,
        chatRoom: jsonMap["chatRoom"] as String,
        date: jsonMap["date"] as Timestamp);
  }

  Future<String> getUserName() async {
    QuerySnapshot? querySnap = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    return (querySnap.docs[0].data() as Map<dynamic, dynamic>)["username"]
        as String;
  }
}
