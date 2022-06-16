import 'dart:convert';

import 'package:chat_bot/Providers/form_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  bool allowEnter = true;
  bool emailInUse = false;
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController confirmEmailCtrl = TextEditingController();
  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController confirmPasswordCtrl = TextEditingController();
  String emailError = "Debe ser un email valido";

  Future<bool> checkEmail(String email, String password) async {
    try {
      if (Provider.of<FormProvider>(context, listen: false).emailInUse) {
        Provider.of<FormProvider>(context, listen: false).changeEmailInUse();
      }
      ByteData bytesUser = await rootBundle.load('assets/images/user.png');
      ByteData bytesChatroom = await rootBundle.load('assets/images/logo.png');
      //Esta condicion la necesitamos porque si tenemos un campo mal, pero el email
      //y la contraseña estan bien, entonces se registra el email, cosa que no queremos
      if (_formKey.currentState!.validate()) {
        FirebaseAuth auth = FirebaseAuth.instance;
        await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        FirebaseFirestore.instance.collection("users").add({
          "avatar": base64.encode(bytesUser.buffer.asUint8List()),
          "email": email,
          "description": "",
          "username": usernameCtrl.text,
          "money": 500,
        });
        FirebaseFirestore.instance.collection("chatroom").add({
          "avatar": base64.encode(bytesChatroom.buffer.asUint8List()),
          "name": "Kekobot",
          "isMP": true,
          "description": "Mensajeria privada con el crupier Kekobot",
          "owner": emailCtrl.text,
          "mods": [emailCtrl.text],
          "users": [emailCtrl.text, "kekobot@kekobot.com"]
        });
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        Provider.of<FormProvider>(context, listen: false).changeEmailInUse();
        Provider.of<FormProvider>(context, listen: false)
            .changeErrorRegister("El email esta en uso");
      } else if (e.code == "invalid-email") {
        Provider.of<FormProvider>(context, listen: false).changeEmailInUse();
        Provider.of<FormProvider>(context, listen: false)
            .changeErrorRegister("Email invalido");
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Registrarse"),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            height: 700,
            child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                              controller: usernameCtrl,
                              validator: (name) {
                                if (name!.isEmpty) {
                                  return 'El nickname no debe estar vacio';
                                }
                                return null;
                              },
                              style: const TextStyle(color: Colors.white),
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
                                labelStyle: TextStyle(color: Colors.white),
                                labelText: 'Nickname',
                              ))),
                      Consumer<FormProvider>(
                          builder: (context, formInfo, child) => Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                  controller: emailCtrl,
                                  validator: (email) {
                                    if (!EmailValidator.validate(email!) ||
                                        formInfo.emailInUse) {
                                      return formInfo.errorRegister;
                                    }
                                    return null;
                                  },
                                  style: const TextStyle(color: Colors.white),
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
                                    labelStyle: TextStyle(color: Colors.white),
                                    labelText: 'Email',
                                  )))),
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                              controller: confirmEmailCtrl,
                              validator: (email) {
                                if (email != emailCtrl.text) {
                                  return 'los email no son iguales';
                                }
                                return null;
                              },
                              style: const TextStyle(color: Colors.white),
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
                                labelStyle: TextStyle(color: Colors.white),
                                labelText: 'Confirmar Email',
                              ))),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Consumer<FormProvider>(
                            builder: (context, formInfo, child) =>
                                TextFormField(
                                    controller: passwordCtrl,
                                    validator: (password) {
                                      if (password!.length < 3) {
                                        return 'Mínimo 3 caracteres';
                                      }
                                      return null;
                                    },
                                    obscureText:
                                        formInfo.registerPasswordVisible,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 2.0,
                                          ),
                                        ),
                                        labelStyle: const TextStyle(
                                            color: Colors.white),
                                        labelText: 'Contraseña',
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            !formInfo.registerPasswordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            formInfo
                                                .changeRegisterPasswordVisible();
                                          },
                                        )))),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Consumer<FormProvider>(
                            builder: (context, formInfo, child) =>
                                TextFormField(
                                    controller: confirmPasswordCtrl,
                                    validator: (password) {
                                      if (password != passwordCtrl.text) {
                                        return 'Debe ser la misma contraseña';
                                      }
                                      return null;
                                    },
                                    obscureText:
                                        formInfo.registerConfirmPasswordVisible,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 2.0,
                                          ),
                                        ),
                                        labelStyle: const TextStyle(
                                            color: Colors.white),
                                        labelText: 'Confirmar contraseña',
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            !formInfo
                                                    .registerConfirmPasswordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            formInfo
                                                .changeRegisterConfirmPasswordVisible();
                                          },
                                        )))),
                      ),
                      Container(
                        child: Consumer<FormProvider>(
                            builder: (context, formInfo, child) =>
                                ElevatedButton(
                                    onPressed: () async {
                                      if (formInfo.errorRegister !=
                                          "El email debe ser valido") {
                                        Provider.of<FormProvider>(context,
                                                listen: false)
                                            .changeErrorRegister(
                                                "El email debe ser valido");
                                      }
                                      allowEnter = await checkEmail(
                                          emailCtrl.text, passwordCtrl.text);
                                      //Esta condicion parece redundante con la condicion
                                      //del checkEmail,pero sirve
                                      //para comprobar si el correo esta en uso o no
                                      //porque el anterior comprueba si el correo es valido
                                      if (_formKey.currentState!.validate() &&
                                          allowEnter) {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Se ha efectuado el registro con exito")));
                                        Navigator.pop(context);
                                        Navigator.pushReplacementNamed(
                                            context, "/chatList");
                                        Provider.of<FormProvider>(context,
                                                listen: false)
                                            .changeErrorLogin("");
                                      }
                                    },
                                    child: const Text('Registrar'),
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
                                                    BorderRadius.circular(30.0)))))),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                      )
                    ])),
          ),
        ));
  }
}
