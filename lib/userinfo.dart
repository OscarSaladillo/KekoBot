import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:chat_bot/base64Decoder/decoder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController nacionalityCtrl = TextEditingController();
  String? avatar;
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
          "color": userColor,
          "lastnames": emailCtrl.text,
          "nacionality": nacionalityCtrl.text,
          "name": usernameCtrl.text
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
    emailCtrl.text = docData!["email"];
    setState(() {
      avatar = docData!["avatar"];
      image = MemoryImage(convertBase64Image(avatar!));
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
                child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles();
                                if (result != null) {
                                  setState(() {
                                    image = FileImage(File(
                                        result.files.single.path as String));
                                  });
                                  Uint8List imagebytes = await File(
                                          result.files.single.path as String)
                                      .readAsBytes(); //convert to bytes
                                  String base64string = base64.encode(
                                      imagebytes); //convert bytes to base64 string
                                  print(base64string);
                                }
                              },
                              child: CircleAvatar(
                                backgroundImage: image!,
                                radius: 150,
                              )),
                          SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.7,
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
                                                    color: Colors.black,
                                                    width: 5)),
                                            labelText: 'Usuario',
                                          ))),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.7,
                                      child: TextFormField(
                                          controller: emailCtrl,
                                          validator: (lastName) {
                                            if (lastName!.isEmpty) {
                                              return 'El apellido no debe estar vacio';
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black,
                                                    width: 5)),
                                            labelText: 'Apellidos',
                                          )))
                                ],
                              )),
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
                                        Colors.orange[200]),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            side: const BorderSide(
                                                color: Color(0xFFE77A06),
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
