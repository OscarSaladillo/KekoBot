import 'dart:typed_data';

import 'package:chat_bot/Models/message_model.dart';
import 'package:chat_bot/Providers/chat_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Extensions/update_selected_chat.dart';
import '../Widgets/message.dart';

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
  Map<String, String> userCache = {};
  Uint8List? memoryImage;
  ScrollController scrollController = ScrollController();
  Widget? button;

  scrollListener() {
    if (scrollController.offset >= 10) {
      setState(() {
        button = FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            scrollController.jumpTo(0);
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
      appBar: AppBar(
        title: Consumer<ChatProvider>(
          builder: (context, chatInfo, child) {
            return Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: MemoryImage(chatInfo.selectedChat!.avatar),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(chatInfo.selectedChat!.name),
                )
              ],
            );
          },
        ),
        centerTitle: true,
        actions: [
          Consumer<ChatProvider>(builder: (context, chatInfo, child) {
            if (!chatInfo.selectedChat!.isMP) {
              return Row(
                children: [
                  TextButton(
                    onPressed: () async {
                      await updateSelectedChat(context);
                      Navigator.pushNamed(context, "/chatInfo");
                    },
                    child: const Icon(
                      Icons.drive_file_rename_outline_rounded,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await updateSelectedChat(context);
                      Navigator.pushNamed(context, "/searchUser");
                    },
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  )
                ],
              );
            } else {
              return Container();
            }
          })
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("messages")
              .where("chatRoom",
                  isEqualTo: Provider.of<ChatProvider>(context, listen: false)
                      .selectedChat
                      ?.id)
              .orderBy("date", descending: true)
              .limit(100)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: ListView.builder(
                    reverse: true,
                    controller: scrollController,
                    itemCount: snapshot.data?.size,
                    itemBuilder: (BuildContext context, int index) {
                      MessageModel message = MessageModel.fromJson(
                          snapshot.data!.docs[index].data(),
                          snapshot.data!.docs[index].id);
                      if (!userCache.keys.contains(message.email)) {
                        Future<String> username = message.getUserName();
                        return FutureBuilder(
                            future: username,
                            builder: (context, username) {
                              if (username.hasData) {
                                String? userMemory;
                                userCache[message.email] =
                                    username.data as String;
                                userMemory = userCache[message.email];
                                return getMessageContainer(
                                    auth.currentUser!.email as String,
                                    message,
                                    userMemory as String,
                                    MediaQuery.of(context).size.width / 2);
                              } else {
                                return Container();
                              }
                            });
                      } else {
                        return getMessageContainer(
                            auth.currentUser!.email as String,
                            message,
                            userCache[message.email] as String,
                            MediaQuery.of(context).size.width / 2);
                      }
                    },
                  )),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: messageCtrl,
                      maxLines: null,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          suffixIcon: TextButton(
                            onPressed: () async {
                              if (messageCtrl.text.isNotEmpty &&
                                  //El limite de caracteres de Whatsapp ;)
                                  messageCtrl.text.length < 65536) {
                                FocusManager.instance.primaryFocus?.unfocus();
                                await addMessage(messageCtrl.text);
                                messageCtrl.text = "";
                                scrollController.jumpTo(0);
                              }
                            },
                            child: Image.asset(
                              "assets/images/send.png",
                              height: 30,
                              width: 30,
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2)),
                          enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2)),
                          labelStyle: const TextStyle(color: Colors.white),
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
