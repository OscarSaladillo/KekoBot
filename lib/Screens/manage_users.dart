import 'package:chat_bot/Providers/chat_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:provider/provider.dart';

import '../Models/user_model.dart';

class ManageUsers extends StatefulWidget {
  const ManageUsers({Key? key}) : super(key: key);

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> deleteUser(String email) async {
    DocumentSnapshot<Object?>? querySnap = await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(Provider.of<ChatProvider>(context, listen: false).selectedChat!.id)
        .get();
    DocumentReference? docRef = querySnap.reference;
    docRef.update({
      "users": FieldValue.arrayRemove([email]),
      "mods": FieldValue.arrayRemove([email])
    });
  }

  Future<void> giveAdmin(String email) async {
    DocumentSnapshot<Object?>? querySnap = await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(Provider.of<ChatProvider>(context, listen: false).selectedChat!.id)
        .get();
    DocumentReference? docRef = querySnap.reference;
    docRef.update({
      "mods": FieldValue.arrayUnion([email])
    });
  }

  Future<void> quitAdmin(String email) async {
    DocumentSnapshot<Object?>? querySnap = await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(Provider.of<ChatProvider>(context, listen: false).selectedChat!.id)
        .get();
    DocumentReference? docRef = querySnap.reference;
    docRef.update({
      "mods": FieldValue.arrayRemove([email])
    });
  }

  FocusedMenuItem deleteWidget(UserModel user) {
    return FocusedMenuItem(
        title: const Text(
          "Eliminar",
          style: TextStyle(color: Colors.redAccent),
        ),
        trailingIcon: const Icon(
          Icons.delete,
          color: Colors.redAccent,
        ),
        onPressed: () {
          deleteUser(user.email);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Usuarios de " +
            Provider.of<ChatProvider>(context, listen: false)
                .selectedChat!
                .name),
        centerTitle: true,
      ),
      body: Consumer<ChatProvider>(
          builder: (context, chatInfo, child) => StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
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
                            user["email"] != "kekobot@kekobot.com" &&
                            Provider.of<ChatProvider>(context, listen: false)
                                .selectedChat!
                                .users
                                .contains(user["email"]))
                        .map((document) {
                      UserModel user =
                          UserModel.fromJson(document.data(), document.id);
                      return FocusedMenuHolder(
                          onPressed: () {},
                          menuItems: (chatInfo.selectedChat!.owner ==
                                  auth.currentUser!.email)
                              ? [
                                  FocusedMenuItem(
                                      title: Text((chatInfo.selectedChat!.mods
                                              .contains(user.email))
                                          ? "Quitar Mod"
                                          : "Dar mod"),
                                      trailingIcon: Icon((chatInfo
                                              .selectedChat!.mods
                                              .contains(user.email)
                                          ? Icons.star_border
                                          : Icons.star)),
                                      onPressed: () {
                                        if (chatInfo.selectedChat!.mods
                                            .contains(user.email)) {
                                          quitAdmin(user.email);
                                        } else {
                                          giveAdmin(user.email);
                                        }
                                      }),
                                  deleteWidget(user),
                                ]
                              : ((chatInfo.selectedChat!.mods
                                          .contains(auth.currentUser!.email) &&
                                      !chatInfo.selectedChat!.mods
                                          .contains(user.email)))
                                  ? [deleteWidget(user)]
                                  : [],
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              backgroundImage: MemoryImage(user.avatar),
                            ),
                            trailing: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                            title: Text(
                              user.name,
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
              )),
    );
  }
}
