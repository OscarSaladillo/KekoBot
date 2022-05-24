import 'package:chat_bot/signup.dart';
import 'package:chat_bot/userinfo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'chat.dart';
import 'firebase_options.dart';
import 'login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) => runApp(MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF128C7E))),
        routes: {
          '/': (context) => const Login(),
          '/register': (context) => const Register(),
          '/chat': (context) => const Chat(),
          '/userInfo': (context) => const UserInfo(),
        },
      )));
}
