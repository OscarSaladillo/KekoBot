import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
  TextEditingController nacionalityCtrl = TextEditingController();
  String? avatar, base64Avatar;
  ImageProvider? image;
  String? userColor;
  String emailError = "Debe ser un email valido";
  List<String> colors = [
    "0xFFFFFFFF",
    "0xFFFF0000",
    "0xFFFFF900",
    "0xFF08E4FC"
  ];
  QuerySnapshot? querySnap;
  QueryDocumentSnapshot? doc;
  DocumentReference? docRef;
  Map? docData;

  List<Widget> colorContainer() {
    List<Widget> containers = [];
    for (int i = 0; i < colors.length; i++) {
      containers.add(TextButton(
        onPressed: () {
          setState(() {
            userColor = colors[i];
          });
        },
        child: Container(
          padding: const EdgeInsets.all(5),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(20),
              color: Color(int.parse(colors[i]))),
          child: (userColor == colors[i])
              ? const Align(
                  alignment: Alignment.topRight,
                  child: Icon(Icons.verified, color: Color(0xFF128C7E)),
                )
              : null,
        ),
      ));
    }
    return containers;
  }

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
    setState(() {
      avatar = docData!["avatar"];
      image = MemoryImage(base64.decode(avatar!));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Informacion del usuario"),
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
      body: (avatar != null)
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
                                Uint8List? imageBytes;
                                FilePickerResult? result = await FilePicker
                                    .platform
                                    .pickFiles(type: FileType.image);
                                if (result != null) {
                                  if (kIsWeb) {
                                    imageBytes =
                                        result.files.first.bytes as Uint8List;
                                    setState(() {
                                      image = MemoryImage(imageBytes!);
                                    });
                                  } else {
                                    imageBytes = await File(
                                            result.files.single.path as String)
                                        .readAsBytes();
                                    setState(() {
                                      image = MemoryImage(imageBytes!);
                                    });
                                  }
                                  //print(result.files.single.bytes);//convert to bytes
                                  base64Avatar = base64.encode(imageBytes);
                                }
                              },
                              child: CircleAvatar(
                                backgroundImage: image!,
                                radius: 150,
                                child: Image.asset(
                                  "assets/images/modifyAvatar.png",
                                  width: 75,
                                ),
                              )),
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: TextFormField(
                                  controller: usernameCtrl,
                                  validator: (name) {
                                    if (name!.isEmpty) {
                                      return 'El nickname no debe estar vacio';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 5)),
                                    labelText: 'Usuario',
                                  ))),
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: TextFormField(
                                  maxLines: 4,
                                  controller: descriptionCtrl,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 5)),
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
                                                vertical: 20, horizontal: 50)),
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.blue[900]),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            side: const BorderSide(
                                                color: Color(0xFF000000),
                                                width: 1,
                                                style: BorderStyle.solid),
                                            borderRadius:
                                                BorderRadius.circular(30.0))))),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                          )
                        ])),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
