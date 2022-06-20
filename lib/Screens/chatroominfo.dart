import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:chat_bot/Providers/chat_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ChatroomInfo extends StatefulWidget {
  const ChatroomInfo({Key? key}) : super(key: key);

  @override
  _ChatroomInfoState createState() => _ChatroomInfoState();
}

class _ChatroomInfoState extends State<ChatroomInfo> {
  final _formKey = GlobalKey<FormState>();
  bool allowEnter = true;
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  String? avatar, base64Avatar;
  ImageProvider? image;
  DocumentSnapshot<Object?>? querySnap;
  QueryDocumentSnapshot? doc;
  DocumentReference? docRef;
  Map? docData;

  Future<bool> saveChanges() async {
    try {
      //Esta condicion la necesitamos porque si tenemos un campo mal, pero el email
      //y la contraseña estan bien, entonces se registra el email, cosa que no queremos
      if (_formKey.currentState!.validate()) {
        docRef!.update({
          "avatar": base64Avatar,
          "description": descriptionCtrl.text,
          "name": nameCtrl.text
        });
        Provider.of<ChatProvider>(context, listen: false)
            .modifySelectedChat(nameCtrl.text, base64Avatar!);
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException {
      return false;
    }
  }

  void deleteChat()  {
     docRef!.delete();
  }

  Future<void> manageChanges() async {
    if (Provider.of<ChatProvider>(context, listen: false).existChat) {
      allowEnter = await saveChanges();
      if (allowEnter) {
        FocusManager.instance.primaryFocus?.unfocus();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Se han realizado los cambios con exito")));
        Navigator.pop(context);
      }
    } else if (_formKey.currentState!.validate()) {
      createChat();
      FocusManager.instance.primaryFocus?.unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Se ha creado el chatroom con exito")));
      Navigator.pop(context);
    }
  }

  Future<void> getUserData() async {
    querySnap = (await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(Provider.of<ChatProvider>(context, listen: false).selectedChat!.id)
        .get());
    docRef = querySnap!.reference;
    docData = querySnap!.data() as Map?;
    nameCtrl.text = docData!["name"];
    descriptionCtrl.text = docData!["description"];
    Provider.of<ChatProvider>(context, listen: false)
        .setAvatar(docData!["avatar"]);
  }

  Future<void> createChatTemplate() async {
    Provider.of<ChatProvider>(context, listen: false)
        .setImage(const AssetImage("assets/images/logo.png"), true);
    Provider.of<ChatProvider>(context, listen: false).setAvatarFromNewChat();
    ByteData bytesChatroom = await rootBundle.load('assets/images/logo.png');
    base64Avatar = base64.encode(bytesChatroom.buffer.asUint8List());
  }

  void createChat() {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore.instance.collection("chatroom").add({
      "avatar": base64Avatar,
      "name": nameCtrl.text,
      "isMP": false,
      "owner": auth.currentUser!.email,
      "mods": [auth.currentUser!.email],
      "description": descriptionCtrl.text,
      "users": [auth.currentUser!.email, "kekobot@kekobot.com"]
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    if (Provider.of<ChatProvider>(context, listen: false).existChat) {
      getUserData().then((value) {
        Provider.of<ChatProvider>(context, listen: false).setImage(
            MemoryImage(Provider.of<ChatProvider>(context, listen: false)
                .selectedChat!
                .avatar),
            false);
        base64Avatar = base64.encode(
            Provider.of<ChatProvider>(context, listen: false)
                .selectedChat!
                .avatar);
      });
    } else {
      createChatTemplate();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Perfil del grupo"),
          actions: [
            TextButton(
              onPressed: () async {
                await manageChanges();
              },
              child: const Icon(
                Icons.save,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: Consumer<ChatProvider>(
          builder: (context, avatar, child) => (avatar.avatar != null)
              ? SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    height: MediaQuery.of(context).size.height - 80,
                    width: MediaQuery.of(context).size.width,
                    child: Form(
                        key: _formKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                  onPressed: () async {
                                    bool rightSize = false;
                                    Uint8List? imageBytes;
                                    FilePickerResult? result = await FilePicker
                                        .platform
                                        .pickFiles(type: FileType.image);
                                    if (result != null) {
                                      if (kIsWeb) {
                                        if (result.files.first.size < 1040000) {
                                          imageBytes = result.files.first.bytes
                                              as Uint8List;
                                          avatar.setImage(
                                              MemoryImage(imageBytes), false);
                                          rightSize = true;
                                        }
                                      } else {
                                        if (result.files.single.size <
                                            1040000) {
                                          imageBytes = await File(result
                                                  .files.single.path as String)
                                              .readAsBytes();
                                          avatar.setImage(
                                              MemoryImage(imageBytes), false);
                                          rightSize = true;
                                        }
                                      }
                                      if (rightSize) {
                                        base64Avatar =
                                            base64.encode(imageBytes!);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "La imagen es muy grande, el limite es 1MB")));
                                      }
                                    }
                                  },
                                  child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 152,
                                      child: CircleAvatar(
                                        backgroundImage: avatar.image,
                                        backgroundColor:
                                            const Color(0xFF680000),
                                        radius: 150,
                                        child: Image.asset(
                                          "assets/images/modifyAvatar.png",
                                          width: 75,
                                        ),
                                      ))),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  child: TextFormField(
                                      controller: nameCtrl,
                                      validator: (name) {
                                        if (name!.isEmpty) {
                                          return 'El nombre no debe estar vacio';
                                        }
                                        return null;
                                      },
                                      style:
                                          const TextStyle(color: Colors.white),
                                      decoration: const InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 2.0,
                                          ),
                                        ),
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        labelText: 'Nombre',
                                      ))),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  child: TextFormField(
                                      maxLines: 4,
                                      controller: descriptionCtrl,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      decoration: const InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 2.0,
                                          ),
                                        ),
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        labelText: 'Descripcion',
                                      ))),
                              Container(
                                child: ElevatedButton(
                                    onPressed: () async {
                                      await manageChanges();
                                    },
                                    child: const Text('Guardar cambios'),
                                    style: ButtonStyle(
                                        padding:
                                            MaterialStateProperty.all<EdgeInsets>(
                                                const EdgeInsets.symmetric(
                                                    vertical: 20,
                                                    horizontal: 50)),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                const Color(0xFF680000)),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                side: const BorderSide(
                                                    color: Color(0xFFFFFFFF),
                                                    width: 1,
                                                    style: BorderStyle.solid),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        30.0))))),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                              ),
                              (Provider.of<ChatProvider>(context,listen: false).existChat &&
                                  Provider.of<ChatProvider>(context,listen: false).selectedChat!.owner == auth.currentUser!.email) ? Container(
                                child: ElevatedButton(
                                    onPressed: () {
                                      deleteChat();
                                    },
                                    child: const Text('Eliminar chat'),
                                    style: ButtonStyle(
                                        padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                            const EdgeInsets.symmetric(
                                                vertical: 20,
                                                horizontal: 50)),
                                        backgroundColor:
                                        MaterialStateProperty.all(
                                            const Color(0xFF680000)),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                side: const BorderSide(
                                                    color: Color(0xFFFFFFFF),
                                                    width: 1,
                                                    style: BorderStyle.solid),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    30.0))))),
                                margin:
                                const EdgeInsets.symmetric(vertical: 10),
                              ) : Container()
                            ])),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ));
  }
}
