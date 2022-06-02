import 'package:chat_bot/SharedPreferences/remember_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';

import '../Providers/form_provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  RememberUser? savedLogin;
  bool rememberUser = false;

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
  void initState() {
    // TODO: implement initState
    savedLogin =
        Provider.of<FormProvider>(context, listen: false).savedLogin;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(future: savedLogin!.initializePreferences(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if(snapshot.hasData) {
            if(savedLogin!.getEmail == "") {
              return SingleChildScrollView(
                child: SizedBox(
                  height: 801,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(25),
                        child: Image.asset(
                          "assets/images/logo.png",
                          width: 250,
                        ),
                      ),
                      const Text(
                        "KekoHouse",
                        style: TextStyle(
                            color: Colors.white, fontSize: 45, fontFamily: "Parisienne"),
                      ),
                      const Text(
                        "El casino donde dejarse llevar",
                        style: TextStyle(
                            color: Colors.white, fontSize: 25, fontFamily: "Parisienne"),
                      ),
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
                                        textAlign: TextAlign.center,
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
                                            ))),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
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
                                                style:
                                                const TextStyle(color: Colors.white),
                                                decoration: InputDecoration(
                                                    focusedBorder:
                                                    const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                    const OutlineInputBorder(
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
                                                        !formInfo.loginPasswordVisible
                                                            ? Icons.visibility
                                                            : Icons.visibility_off,
                                                        color: Colors.white,
                                                      ),
                                                      onPressed: () {
                                                        formInfo
                                                            .changeLoginPasswordVisible();
                                                      },
                                                    )),
                                              )),
                                    ),
                                    Consumer<FormProvider>(
                                      builder: (context, formInfo, child) => SizedBox(
                                          width: 210,
                                          child: Theme(
                                            data: ThemeData(
                                                unselectedWidgetColor: Colors.white),
                                            child: CheckboxListTile(
                                              value: formInfo.rememberUser,
                                              onChanged: (value) {
                                                formInfo.changeRememberUser();
                                              },
                                              title: const Text(
                                                "Recordar Usuario",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15, color: Colors.white),
                                              ),
                                            ),
                                          )),
                                    ),
                                    Container(
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            bool allowEnter = await checkLogin(
                                                emailCtrl.text, passwordCtrl.text);
                                            if (_formKey.currentState!.validate() &&
                                                allowEnter) {
                                              if (Provider.of<FormProvider>(context,
                                                  listen: false)
                                                  .rememberUser) {
                                                savedLogin!.savedLogin(
                                                    emailCtrl.text, passwordCtrl.text);
                                              }
                                              Navigator.pushReplacementNamed(
                                                  context, "/chatList");
                                              Provider.of<FormProvider>(context,
                                                  listen: false)
                                                  .changeErrorLogin("");
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
                                                  const Color(0xFF680000)),
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      side: const BorderSide(
                                                          color: Color(0xFFFFFFFF),
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
                                                  const Color(0xFF680000)),
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      side: const BorderSide(
                                                          color: Color(0xFFFFFFFF),
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
              );
            } else {
              checkLogin(savedLogin!.getEmail!, savedLogin!.getPassword!).then((value) => Navigator.pushReplacementNamed(context,"/chatList"));
              return Container();
            }
          }else {
            return Container();
          }
          },));
  }
}
