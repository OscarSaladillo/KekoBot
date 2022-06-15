import 'package:chat_bot/Utils/add_message.dart';
import 'package:flutter/cupertino.dart';

import '../Utils/remove_diacritics.dart';
import 'functionalities.dart';

void checkMessage(String word, BuildContext context) {
  List<String> playWords = [
    "jugar",
    "ir",
    "apostar",
    "arriesg",
    "lleva",
    "acompaña",
    "traeme",
    "dame",
    "juego",
    "echar",
  ];
  List<String> infoWords = [
    "Como",
    "info",
    "ayuda",
    "tutorial",
    "saber",
    "dato"
  ];
  List<String> seeMoneyWords = [
    "ver",
    "revisar",
    "analizar",
    "ojear",
    "presenciar",
    "observar",
    "mirar",
    "cantidad",
    "cuanta",
    "cuanto"
  ];
  List<String> resetMoneyWords = [
    "reiniciar",
    "formatear",
    "restablecer",
    "limpiar",
    "vaciar",
  ];
  List<String> hiWords = [
    "hola",
    "hi",
    "buenas",
    "hello",
  ];
  String message = removeDiacritics(word).toLowerCase();
  test(String value) => message.contains(value);
  if (infoWords.any((test))) {
    sendInfo(message, context);
    return;
  }
  if (seeMoneyWords.any((test))) {
    seeMoney(context, word);
    return;
  }
  if (playWords.any((test))) {
    goToScreen(message, context);
    return;
  }
  if (resetMoneyWords.any((test))) {
    resetMoney(context, word);
    return;
  }
  if (hiWords.any((test))) {
    addMessage(context, "kekobot@kekobot.com", "Buenos dias 😊");
    setOptionsButtons(context, "¿En que puedo ayudarle?");
    return;
  }
  notUnderstandMessage(context);
  setOptionsButtons(context,
      "Creo que lo mejor seria ofrecerte las opciones para ser de mejor ayuda ^^");
}
