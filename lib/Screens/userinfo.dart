import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:chat_bot/Providers/avatar_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final _formKey = GlobalKey<FormState>();
  bool allowEnter = true;
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  String? avatar, base64Avatar;
  ImageProvider? image;
  QuerySnapshot? querySnap;
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
          "username": usernameCtrl.text
        });
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException {
      return false;
    }
  }

  Future<void> manageChanges() async {
    allowEnter = await saveChanges();
    //Esta condicion parece redundante con la condicion
    //del checkEmail,pero sirve
    //para comprobar si el correo esta en uso o no
    //porque el anterior comprueba si el correo es valido
    if (allowEnter) {
      FocusManager.instance.primaryFocus?.unfocus();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Se han realizado los cambios con exito")));
      Navigator.pop(context);
    }
  }

  Future<void> getUserData() async {
    querySnap = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: auth.currentUser!.email)
        .get();
    doc = querySnap!.docs[0];
    docRef = doc!.reference;
    docData = doc!.data() as Map?;
    usernameCtrl.text = docData!["username"];
    descriptionCtrl.text = docData!["description"];
    Provider.of<AvatarProvider>(context, listen: false)
        .setAvatar(docData!["avatar"]);
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserData().then((value) {
      Provider.of<AvatarProvider>(context, listen: false).setImage(MemoryImage(
          base64.decode(
              Provider.of<AvatarProvider>(context, listen: false).avatar!)));
      base64Avatar =
          Provider.of<AvatarProvider>(context, listen: false).avatar!;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Perfil"),
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
        body: Consumer<AvatarProvider>(
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
                                              MemoryImage(imageBytes));
                                          rightSize = true;
                                        }
                                      } else {
                                        if (result.files.single.size <
                                            1040000) {
                                          imageBytes = await File(result
                                                  .files.single.path as String)
                                              .readAsBytes();
                                          avatar.setImage(
                                              MemoryImage(imageBytes));
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
                                      controller: usernameCtrl,
                                      validator: (name) {
                                        if (name!.isEmpty) {
                                          return 'El nickname no debe estar vacio';
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
                                        labelText: 'Usuario',
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
                              )
                            ])),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ));
  }
}
