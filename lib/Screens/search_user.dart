import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchUser extends StatefulWidget {
  const SearchUser({Key? key}) : super(key: key);

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  TextEditingController nameCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Añadir usuario"),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: nameCtrl,
              maxLines: null,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  suffixIcon: TextButton(
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2)),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2)),
                  labelStyle: const TextStyle(color: Colors.white),
                  labelText: 'Nombre usuario'),
            ),
          ),
          StreamBuilder(
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
                  ChatModel chat =
                      ChatModel.fromJson(document.data(), document.id);
                  return TextButton(
                      onPressed: () {
                        Provider.of<ChatProvider>(context, listen: false)
                            .setSelectedChat(chat);
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
        ],
      ),
    );
  }
}
