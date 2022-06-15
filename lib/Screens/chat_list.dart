import 'package:chat_bot/Providers/user_provider.dart';
import 'package:chat_bot/Providers/chatbot_provider.dart';
import 'package:chat_bot/Providers/chat_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/chat_model.dart';
import '../Models/user_model.dart';
import '../Providers/avatar_provider.dart';
import '../Providers/form_provider.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> listenUser() async {
    FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: auth.currentUser!.email)
        .snapshots()
        .listen((document) {
      if (mounted) {
        UserModel user =
            UserModel.fromJson(document.docs[0].data(), document.docs[0].id);
        Provider.of<UserProvider>(context, listen: false).setUser(user);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    listenUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de chats"),
        centerTitle: true,
        leading: TextButton(
            onPressed: () async {
              Provider.of<FormProvider>(context, listen: false)
                  .savedLogin
                  .logout();
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
              Provider.of<AvatarProvider>(context, listen: false)
                  .setAvatar(null);
              Provider.of<ChatProvider>(context, listen: false)
                  .changeExistChat(false);
              Navigator.pushNamed(context, "/chatInfo");
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(20)),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              Provider.of<AvatarProvider>(context, listen: false)
                  .setAvatar(null);
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<Widget> listTiles = snapshot.data?.docs.map((document) {
              ChatModel chat = ChatModel.fromJson(document.data(), document.id);
              return TextButton(
                  onPressed: () {
                    Provider.of<ChatProvider>(context, listen: false)
                        .setSelectedChat(chat);
                    Provider.of<ChatBotProvider>(context, listen: false)
                        .setWidget(Container(), true);
                    Navigator.pushNamed(context, "/chat");
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: MemoryImage(chat.avatar),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_sharp,
                      color: Colors.white,
                    ),
                    title: Text(
                      chat.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ));
            }).toList() as List<Widget>;
            return ListView.separated(
                itemBuilder: (context, index) {
                  return listTiles[index];
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    thickness: 2,
                    color: Colors.white,
                  );
                },
                itemCount: listTiles.length);
          }
        },
      ),
    );
  }
}
