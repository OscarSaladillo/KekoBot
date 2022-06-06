import 'package:chat_bot/Providers/search_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/user_model.dart';
import '../Providers/chat_provider.dart';

class SearchUser extends StatefulWidget {
  const SearchUser({Key? key}) : super(key: key);

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  TextEditingController nameCtrl = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  void searchUsers() {
    Provider.of<SearchProvider>(context, listen: false)
        .changeInput(nameCtrl.text);
  }

  Future<void> saveUsers() async {
    DocumentSnapshot<Object?>? querySnap = await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(Provider.of<ChatProvider>(context, listen: false).selectedChat!.id)
        .get();
    DocumentReference? docRef = querySnap.reference;
    docRef.update({
      "users": FieldValue.arrayUnion(
          Provider.of<SearchProvider>(context, listen: false)
              .selectedUsers
              .map((user) => user.email)
              .toList())
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Provider.of<SearchProvider>(context, listen: false)
                .resetAttributes();
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_sharp, color: Colors.white),
        ),
        title: const Text("Añadir usuario"),
        actions: [
          TextButton(
              onPressed: () async {
                await saveUsers();
                Provider.of<SearchProvider>(context, listen: false)
                    .resetAttributes();
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.save,
                color: Colors.white,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
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
                        searchUsers();
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
            Consumer<SearchProvider>(
              builder: (context, searchInfo, child) => SizedBox(
                height:
                    MediaQuery.of(context).size.height - searchInfo.usedHeight,
                child: Consumer<SearchProvider>(
                    builder: (context, input, child) => StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .where('email',
                                  isNotEqualTo: auth.currentUser!.email)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              List<Widget> listTiles = snapshot.data?.docs
                                  .where((user) =>
                                      user["username"].toLowerCase().startsWith(
                                          input.input.toLowerCase()) &&
                                      input.input.isNotEmpty &&
                                      !Provider.of<ChatProvider>(context,
                                              listen: false)
                                          .selectedChat!
                                          .users
                                          .contains(user["email"]))
                                  .map((document) {
                                UserModel user =
                                    UserModel.fromJson(document.data());
                                return TextButton(
                                    onPressed: () {
                                      if (searchInfo.selectedUsers
                                          .where((currentUser) =>
                                              currentUser.email == user.email)
                                          .isEmpty) {
                                        if (searchInfo.selectedUsers.isEmpty) {
                                          searchInfo.incrementHeight(true);
                                        }
                                        searchInfo.addUser(user);
                                      }
                                    },
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        backgroundImage:
                                            MemoryImage(user.avatar),
                                      ),
                                      trailing: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                      title: Text(
                                        user.name,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ));
                              }).toList() as List<Widget>;
                              if (listTiles.isNotEmpty) {
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
                              } else {
                                return const Center(
                                  child: Text(
                                    "No se encontraron coincidencias",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              }
                            }
                          },
                        )),
              ),
            ),
            Consumer<SearchProvider>(
              builder: (context, searchInfo, child) {
                if (searchInfo.selectedUsers.isEmpty) {
                  return Container();
                } else {
                  return Container(
                      color: Colors.white,
                      height: 100,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: searchInfo.selectedUsers.length,
                          itemBuilder: (context, index) => Stack(
                                children: [
                                  Container(
                                    child: Image.memory(
                                      searchInfo.selectedUsers[index].avatar,
                                      width: 80,
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                  ),
                                  Positioned(
                                      left: 50,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.red,
                                        child: TextButton(
                                            onPressed: () {
                                              searchInfo.deleteUser(searchInfo
                                                  .selectedUsers[index]);
                                              if (searchInfo
                                                  .selectedUsers.isEmpty) {
                                                searchInfo
                                                    .incrementHeight(false);
                                              }
                                            },
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            )),
                                      ))
                                ],
                              )));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
