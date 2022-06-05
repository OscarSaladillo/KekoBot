import 'package:chat_bot/Models/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../Providers/chat_provider.dart';

Future<void> updateSelectedChat(BuildContext context) async {
  DocumentSnapshot<Object?>? querySnap = (await FirebaseFirestore.instance
      .collection('chatroom')
      .doc(Provider.of<ChatProvider>(context, listen: false).selectedChat!.id)
      .get());
  Map<String, Object?> doc = querySnap.data() as Map<String, Object?>;
  Provider.of<ChatProvider>(context, listen: false).setSelectedChat(
      ChatModel.fromJson(doc,
          Provider.of<ChatProvider>(context, listen: false).selectedChat!.id));
}
