import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  String errorlogin = "";

  Future<bool> checkLogin(String email, String password) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: SizedBox(
        height: 700,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Container(
              padding: const EdgeInsets.all(50),
              child: Image.asset(
                "assets/images/logo.png",
                width: 300,
              ),
            )),
            Expanded(
                child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            errorlogin,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 20),
                          ),
                          Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                  controller: nameCtrl,
                                  validator: (email) {
                                    if (!EmailValidator.validate(email!)) {
                                      return 'Debe ser un email valido';
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
                            child: ElevatedButton(
                                onPressed: () async {
                                  bool allowEnter = await checkLogin(
                                      nameCtrl.text, passwordCtrl.text);
                                  if (_formKey.currentState!.validate() &&
                                      allowEnter) {
                                    Navigator.pushReplacementNamed(
                                        context, "/chat");
                                  } //Esta condicion la pusimos por si los datos sintacticamente
                                  // estan bien, pero no tenemos registrados esos datos
                                  // ya que en caso de estar sintacticamente mal, los textfield hacen su trabajo
                                  // con el input decoration y seria redundante poner else en ves de else if
                                  else if (_formKey.currentState!.validate() &&
                                      !allowEnter) {
                                    setState(() {
                                      errorlogin =
                                          "el email o la contraseña no son correctas";
                                    });
                                  } //Esta condicion es para borrar el mensaje del errorLogin y que
                                  //no repita al usuario el mensaje ya que puede molestarlo
                                  else {
                                    setState(() {
                                      errorlogin = "";
                                    });
                                  }
                                },
                                child: const Text('Acceder'),
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
                          ),
                          Container(
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, "/register");
                                },
                                child: const Text('Registrar'),
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
                        ])))
          ],
        ),
      ),
    ));
  }
}
