import 'package:chat_bot/Providers/blackjack_provider.dart';
import 'package:chat_bot/Providers/chatbot_provider.dart';
import 'package:chat_bot/Screens/blackjack.dart';
import 'package:chat_bot/Screens/chat_list.dart';
import 'package:chat_bot/Screens/chatroominfo.dart';
import 'package:chat_bot/Screens/register.dart';
import 'package:chat_bot/Screens/roulette.dart';
import 'package:chat_bot/Screens/search_user.dart';
import 'package:chat_bot/Screens/slot_machine.dart';
import 'package:chat_bot/Screens/userinfo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Providers/avatar_provider.dart';
import 'Providers/chat_provider.dart';
import 'Providers/form_provider.dart';
import 'Providers/search_provider.dart';
import 'Providers/user_provider.dart';
import 'Screens/chat.dart';
import 'Screens/manage_users.dart';
import 'firebase_options.dart';
import 'Screens/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) => runApp(MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => FormProvider()),
            ChangeNotifierProvider(create: (context) => ChatProvider()),
            ChangeNotifierProvider(create: (context) => AvatarProvider()),
            ChangeNotifierProvider(create: (context) => SearchProvider()),
            ChangeNotifierProvider(create: (context) => BlackJackProvider()),
            ChangeNotifierProvider(create: (context) => ChatBotProvider()),
            ChangeNotifierProvider(create: (context) => UserProvider()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                scaffoldBackgroundColor: const Color(0xFF205338),
                appBarTheme:
                    const AppBarTheme(backgroundColor: Color(0xFF680000))),
            routes: {
              '/': (context) => const Login(),
              '/register': (context) => const Register(),
              '/chatList': (context) => const ChatList(),
              '/chat': (context) => const Chat(),
              '/userInfo': (context) => const UserInfo(),
              '/chatInfo': (context) => const ChatroomInfo(),
              '/searchUser': (context) => const SearchUser(),
              "/manageUsers": (context) => const ManageUsers(),
              "/slotMachine": (context) => const SlotMachineScreen(),
              "/blackjack": (context) => const BlackJack(),
              "/roulette": (context) => const Roulette(),
            },
          ))));
}
