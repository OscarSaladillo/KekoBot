import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../Providers/chat_provider.dart';

Future<void> addMessage(BuildContext context, String email, String text) async {
  FirebaseFirestore.instance.collection("messages").add({
    "text": text,
    "date": DateTime.now(),
    "email": email,
    "chatRoom":
        Provider.of<ChatProvider>(context, listen: false).selectedChat?.id
  });
}
