import 'package:flutter/cupertino.dart';

import '../Utils/add_message.dart';

Future<void> sendRouletteInfo(BuildContext context) async {
  await addMessage(context, "kekobot@kekobot.com",
      "La ruleta o tambien llamado rueda de la fortuna la apuesta es de 10 fichas y puedes ganar un gran premio o perderlo");
}

Future<void> sendSlotMachineInfo(BuildContext context) async {
  await addMessage(context, "kekobot@kekobot.com",
      "Son máquinas de juegos de azar donde se apuesta 1 ficha para ganar un premio");
}

Future<void> sendBlackJackInfo(BuildContext context) async {
  await addMessage(context, "kekobot@kekobot.com",
      "El blackjack es un juego de naipes que consiste en tener una mano lo mas cercano a 21 sin sobrepasarlo");
}

Future<void> sendKekoHouseInfo(BuildContext context) async {
  await addMessage(context, "kekobot@kekobot.com",
      "Estas en un casino donde aparte del juego, tambien esta la posibilidad de socializar con gente en los chats y crear una comunidad");
}
