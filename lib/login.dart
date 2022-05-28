import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';

import 'Providers/form_provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

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
                          Consumer<FormProvider>(
                            builder: (context, formInfo, child) => Text(
                              formInfo.errorLogin,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 20),
                            ),
                          ),
                          Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                  controller: emailCtrl,
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
                            child: Consumer<FormProvider>(
                                builder: (context, formInfo, child) =>
                                    TextFormField(
                                      controller: passwordCtrl,
                                      validator: (password) {
                                        if (password!.isEmpty) {
                                          return 'Este campo no puede estar vacio';
                                        }
                                        return null;
                                      },
                                      obscureText:
                                          formInfo.loginPasswordVisible,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      decoration: InputDecoration(
                                          border: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 5)),
                                          labelText: 'Contraseña',
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              !formInfo.loginPasswordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                            ),
                                            onPressed: () {
                                              formInfo
                                                  .changeLoginPasswordVisible();
                                            },
                                          )),
                                    )),
                          ),
                          Container(
                            child: ElevatedButton(
                                onPressed: () async {
                                  bool allowEnter = await checkLogin(
                                      emailCtrl.text, passwordCtrl.text);
                                  if (_formKey.currentState!.validate() &&
                                      allowEnter) {
                                    Navigator.pushReplacementNamed(
                                        context, "/chatList");
                                  } //Esta condicion la pusimos por si los datos sintacticamente
                                  // estan bien, pero no tenemos registrados esos datos
                                  // ya que en caso de estar sintacticamente mal, los textfield hacen su trabajo
                                  // con el input decoration y seria redundante poner else en ves de else if
                                  else if (_formKey.currentState!.validate() &&
                                      !allowEnter) {
                                    Provider.of<FormProvider>(context,
                                            listen: false)
                                        .changeErrorLogin(
                                            "el email o la contraseña no son correctas");
                                  } //Esta condicion es para borrar el mensaje del errorLogin y que
                                  //no repita al usuario el mensaje ya que puede molestarlo
                                  else {
                                    Provider.of<FormProvider>(context,
                                            listen: false)
                                        .changeErrorLogin("");
                                  }
                                },
                                child: const Text(
                                  'Iniciar sesión',
                                  style: TextStyle(color: Colors.white),
                                ),
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
