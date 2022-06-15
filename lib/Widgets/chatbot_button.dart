import 'package:chat_bot/ChatBot/functionalities.dart';
import 'package:chat_bot/Utils/add_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/chatbot_provider.dart';
import 'assistant_widgets.dart';

SizedBox chatBotButton(BuildContext context) {
  return SizedBox(
      width: 40,
      child: TextButton(
        onPressed: () {
          if (Provider.of<ChatBotProvider>(context, listen: false)
              .isContainer) {
            setOptionsButtons(context,
                "Yo soy capaz de ayudarte con las siguientes opciones");
          }
        },
        child: Image.asset(
          "assets/images/buttonlogo.png",
          width: 40,
        ),
      ));
}
