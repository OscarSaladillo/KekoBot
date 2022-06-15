import 'package:chat_bot/ChatBot/push_to_game.dart';
import 'package:chat_bot/ChatBot/send_game_info.dart';
import 'package:chat_bot/Providers/user_provider.dart';
import 'package:chat_bot/Providers/chatbot_provider.dart';
import 'package:chat_bot/Utils/add_message.dart';
import 'package:chat_bot/Widgets/assistant_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Utils/manage_money.dart';

Future<void> seeMoney(BuildContext context, String word) async {
  List<String> moneyWords = [
    "cuenta",
    "dinero",
    "moneda",
    "ficha",
    "banco",
    "cartera",
    "billetera",
    "monedero",
    "cuanto tengo"
  ];
  test(String value) => word.contains(value);
  if (moneyWords.any((test))) {
    addMessage(
        context,
        "kekobot@kekobot.com",
        Provider.of<UserProvider>(context, listen: false).currentUser!.name +
            " tienes " +
            Provider.of<UserProvider>(context, listen: false)
                .currentUser!
                .money
                .toString() +
            " fichas");
  } else {
    notUnderstandMessage(context);
    setOptionsButtons(context,
        "Creo que lo mejor seria ofrecerte las opciones para ser de mejor ayuda ^^");
  }
}

Future<void> resetMoney(BuildContext context, String word) async {
  List<String> moneyWords = [
    "cuenta",
    "dinero",
    "moneda",
    "ficha",
    "banco",
    "cartera",
    "billetera",
    "monedero",
    "cuanto tengo"
  ];
  test(String value) => word.contains(value);
  if (moneyWords.any((test))) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Reiniciar cuenta'),
              content:
                  const Text('¿Estas seguro que quieres reiniciar tu cuenta?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    await addMessage(
                        context,
                        "kekobot@kekobot.com",
                        Provider.of<UserProvider>(context, listen: false)
                                .currentUser!
                                .name +
                            " Su cuenta ha sido reseteada con exito");
                    resetAccount(context);
                    Navigator.pop(context);
                  },
                  child: const Text('Confirmar'),
                ),
              ],
            ));
  } else {
    notUnderstandMessage(context);
    setOptionsButtons(context,
        "Creo que lo mejor seria ofrecerte las opciones para ser de mejor ayuda ^^");
  }
}

Future<void> sendInfo(String word, BuildContext context) async {
  if (word.contains("ruleta") ||
      word.contains("rueda") ||
      word.contains("ruletita")) {
    sendRouletteInfo(context);
    return;
  }
  if (word.contains("tragaperra") ||
      word.contains("tragamoneda") ||
      word.contains("ranura")) {
    sendSlotMachineInfo(context);
    return;
  }
  if (word.contains("blackjack") || word.contains("cartas")) {
    sendBlackJackInfo(context);
    return;
  }
  if (word.contains("casino") ||
      word.contains("esto") ||
      word.contains("app") ||
      word.contains("aplicacion")) {
    sendKekoHouseInfo(context);
    return;
  }
  setInfoButtons(context);
}

Future<void> goToScreen(String word, BuildContext context) async {
  if (word.contains("ruleta") || word.contains("rueda")) {
    goToRoulette(context);
    cleanWidget(context);
    return;
  }
  if (word.contains("tragaperra") ||
      word.contains("tragamoneda") ||
      word.contains("ranura")) {
    goToSlotMachine(context);
    cleanWidget(context);
    return;
  }
  if (word.contains("blackjack") ||
      word.contains("cartas") ||
      word.contains("ranura")) {
    goToBlackJack(context);
    cleanWidget(context);
    return;
  }
  setGameButtons(context);
}

Future<void> setGameButtons(BuildContext context) async {
  await addMessage(context, "kekobot@kekobot.com", "¿Que quieres jugar :)?");
  Provider.of<ChatBotProvider>(context, listen: false)
      .setWidget(getGameButtons(context), false);
}

Future<void> setInfoButtons(BuildContext context) async {
  await addMessage(context, "kekobot@kekobot.com",
      "Puedo ofrecerte informacion de las siguientes opciones ^^");
  Provider.of<ChatBotProvider>(context, listen: false)
      .setWidget(getInfoButtons(context), false);
}

Future<void> setOptionsButtons(BuildContext context, String text) async {
  await addMessage(context, "kekobot@kekobot.com", text);
  Provider.of<ChatBotProvider>(context, listen: false)
      .setWidget(getOptionButtons(context), false);
}

Future<void> notUnderstandMessage(BuildContext context) async {
  await addMessage(
      context, "kekobot@kekobot.com", "Lo siento no logro comprender");
}

void cleanWidget(BuildContext context) {
  Provider.of<ChatBotProvider>(context, listen: false)
      .setWidget(Container(), true);
}
