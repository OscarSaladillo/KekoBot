import 'dart:convert';

import 'package:chat_bot/Models/message_model.dart';
import 'package:chat_bot/Providers/chat_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'message.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<Map<String, dynamic>> list = [];
  List<String> usersCount = [];
  TextEditingController messageCtrl = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  ScrollController scrollController = ScrollController();
  Widget? button;

  Future<void> listenChanges() async {
    FirebaseFirestore.instance
        .collection("messages")
        .where("chatRoom",
            isEqualTo: Provider.of<ChatProvider>(context, listen: false)
                .selectedChat
                ?.id)
        .orderBy("date")
        .snapshots()
        .listen((result) {
      setState(() {
        list = [];
      });
      for (var result in result.docs) {
        setState(() {
          list.add(result.data());
        });
        //Aqui obtendremos los usuarios que dejaron al menos un mensaje en el chat
        //Esa es la unica razon por la que hicimos una lista exclusiva en ves del mapa del userColor
        //Porque se puede dar el caso de que el usuario no haya dejado un mensaje
        if (!usersCount.contains(result.data()["email"])) {
          setState(() {
            usersCount.add(result.data()["email"] as String);
          });
        }
      }
    });
  }

  scrollListener() {
    if (scrollController.offset <=
        scrollController.position.maxScrollExtent - 100) {
      setState(() {
        button = FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          },
          child: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
        );
      });
    } else {
      setState(() {
        button = null;
      });
    }
  }

  Future<void> addMessage(String text) async {
    FirebaseFirestore.instance.collection("messages").add({
      "text": text,
      "date": DateTime.now(),
      "email": auth.currentUser!.email,
      "chatRoom":
          Provider.of<ChatProvider>(context, listen: false).selectedChat?.id
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    //listenChanges();
    //La razon por la que decidi poner un boton al inicio del chat, fue por si el usuario
    // queria ver los mensajes del inicio y si no queria, que le de al boton
    button = FloatingActionButton(
      backgroundColor: Colors.white,
      onPressed: () {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      },
      child: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(scrollListener);
    return Scaffold(
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 100),
        child: button,
      ),
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, "/userInfo");
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(20)),
            child: Image.memory(base64.decode(
                Provider.of<ChatProvider>(context, listen: false)
                    .selectedChat!
                    .avatar)),
          ),
        ),
        title: Column(
          children: [
            Text(Provider.of<ChatProvider>(context, listen: false)
                .selectedChat!
                .name),
            Text(
              "${Provider.of<ChatProvider>(context, listen: false).selectedChat!.users.length} Usuarios",
              style: const TextStyle(fontSize: 16),
            )
          ],
        ),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () async {
                await auth.signOut();
                Navigator.pushReplacementNamed(context, "/");
              },
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ))
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("messages")
              .where("chatRoom",
                  isEqualTo: Provider.of<ChatProvider>(context, listen: false)
                      .selectedChat
                      ?.id)
              .orderBy("date")
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: ListView(
                    controller: scrollController,
                    children: snapshot.data?.docs.map((document) {
                      MessageModel message =
                          MessageModel.fromJson(document.data(), document.id);
                      return getMessageContainer(
                          auth.currentUser!.email as String,
                          message,
                          MediaQuery.of(context).size.width / 2);
                    }).toList(growable: true) as List<Widget>,
                  )),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: messageCtrl,
                      maxLines: null,
                      decoration: InputDecoration(
                          suffixIcon: TextButton(
                            onPressed: () async {
                              if (messageCtrl.text.isNotEmpty &&
                                  //El limite de caracteres de Whatsapp ;)
                                  messageCtrl.text.length < 65536) {
                                FocusManager.instance.primaryFocus?.unfocus();
                                await addMessage(messageCtrl.text);
                                messageCtrl.text = "";
                                scrollController.jumpTo(
                                    scrollController.position.maxScrollExtent);
                              }
                            },
                            child: Image.asset(
                              "assets/images/send.png",
                              height: 40,
                              width: 40,
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2)),
                          labelText: 'Escribe tu mensaje'),
                    ),
                  )
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
