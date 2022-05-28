import 'dart:convert';
import 'dart:typed_data';

import 'package:chat_bot/base64Decoder/decoder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Models/chat_model.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de chats"),
        centerTitle: true,
        leading: TextButton(
            onPressed: () async {
              await auth.signOut();
              Navigator.pushReplacementNamed(context, "/");
            },
            child: const Icon(
              Icons.logout,
              color: Colors.white,
            )),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, "/userInfo");
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(20)),
              child: const Icon(Icons.person_outline, color: Colors.white),
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chatroom')
            .where('users', arrayContains: auth.currentUser?.email)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            // ERROR
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              children: snapshot.data?.docs.map((document) {
                ChatModel chat =
                    ChatModel.fromJson(document.data(), document.id);
                return TextButton(
                    onPressed: () {},
                    child: ListTile(
                      leading: Image.memory(convertBase64Image(chat.avatar)),
                      title: Text(chat.name),
                    ));
              }).toList() as List<Widget>,
            );
          }
        },
      ),
    );
  }
}
