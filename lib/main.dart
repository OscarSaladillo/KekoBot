import 'package:chat_bot/chat_list.dart';
import 'package:chat_bot/register.dart';
import 'package:chat_bot/userinfo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Providers/form_provider.dart';
import 'chat.dart';
import 'firebase_options.dart';
import 'login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) => runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => FormProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xFFDEE3FF),
            appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF000E7A))),
        routes: {
          '/': (context) => const Login(),
          '/register': (context) => const Register(),
          '/chatList': (context) => const ChatList(),
          '/chat': (context) => const Chat(),
          '/userInfo': (context) => const UserInfo(),
        },
      ))));
}
