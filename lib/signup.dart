import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      if (emailInUse) {
        setState(() {
          emailInUse = false;
        });
      }
      //Esta condicion la necesitamos porque si tenemos un campo mal, pero el email
      //y la contraseña estan bien, entonces se registra el email, cosa que no queremos
      if (_formKey.currentState!.validate()) {
        FirebaseAuth auth = FirebaseAuth.instance;
        await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        FirebaseFirestore.instance
            .collection("users")
            .add({"avatar": "", "email": email, "username": usernameCtrl.text});
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        setState(() {
          emailInUse = true;
          emailError = "El email esta en uso";
        });
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
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 5)),
                                labelText: 'Nickname',
                              ))),
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                              controller: emailCtrl,
                              validator: (email) {
                                if (!EmailValidator.validate(email!) ||
                                    emailInUse) {
                                  return emailError;
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 5)),
                                labelText: 'Email',
                              ))),
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
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 5)),
                                labelText: 'Confirmar Email',
                              ))),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                            controller: passwordCtrl,
                            validator: (password) {
                              if (password!.length > 10) {
                                return 'Máximo 10 caracteres';
                              } else if (password.length < 3) {
                                return 'Mínimo 3 caracteres';
                              }
                              return null;
                            },
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 5)),
                              labelText: 'Contraseña',
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                            controller: confirmPasswordCtrl,
                            validator: (password) {
                              if (password != passwordCtrl.text) {
                                return 'Debe ser la misma contraseña';
                              }
                              return null;
                            },
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 5)),
                              labelText: 'Confirmar contraseña',
                            )),
                      ),
                      Container(
                        child: ElevatedButton(
                            onPressed: () async {
                              if (emailError != "El email debe ser valido") {
                                setState(() {
                                  emailError = "El email debe ser valido";
                                });
                              }
                              allowEnter = await checkEmail(
                                  emailCtrl.text, passwordCtrl.text);
                              //Esta condicion parece redundante con la condicion
                              //del checkEmail,pero sirve
                              //para comprobar si el correo esta en uso o no
                              //porque el anterior comprueba si el correo es valido
                              if (_formKey.currentState!.validate()) {
                                FocusManager.instance.primaryFocus?.unfocus();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Se ha efectuado el registro con exito")));
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Registrar'),
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
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
        ));
  }
}
